const ConnectionRequest = require('../models/ConnectionRequest');
const Connection = require('../models/Connection');
const User = require('../models/User');
const { toPublicProfileDTO } = require('../utils/privacyDto');

/**
 * @route   POST /api/connections/requests
 * @desc    Send a connection request to a provider
 */
exports.createRequest = async (req, res) => {
  try {
    const { provider_id, need_id, message } = req.body;

    if (!provider_id) {
      return res.status(400).json({ success: false, error: 'provider_id is required' });
    }

    if (provider_id.toString() === req.user._id.toString()) {
      return res.status(400).json({ success: false, error: 'Cannot send connection request to yourself' });
    }

    const targetProvider = await User.findById(provider_id);
    if (!targetProvider) {
      return res.status(404).json({ success: false, error: 'Provider not found' });
    }

    // Check if request already exists
    const existingReq = await ConnectionRequest.findOne({
      requester_id: req.user._id,
      provider_id,
      status: 'pending'
    });

    if (existingReq) {
      return res.status(400).json({ success: false, error: 'Connection request already pending' });
    }

    const newRequest = await ConnectionRequest.create({
      requester_id: req.user._id,
      provider_id,
      need_id: need_id || null,
      message: message || 'I would like to connect regarding your service.'
    });

    return res.status(201).json({
      success: true,
      message: 'Connection request sent successfully',
      request: newRequest
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * @route   GET /api/connections/requests
 * @desc    Get user's pending incoming and outgoing connection requests
 */
exports.getRequests = async (req, res) => {
  try {
    const incoming = await ConnectionRequest.find({ provider_id: req.user._id, status: 'pending' })
      .populate('requester_id', 'name profession locality_name')
      .sort({ created_at: -1 });

    const outgoing = await ConnectionRequest.find({ requester_id: req.user._id })
      .populate('provider_id', 'name profession locality_name')
      .sort({ created_at: -1 });

    return res.status(200).json({
      success: true,
      incoming,
      outgoing
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * @route   PATCH /api/connections/requests/:id
 * @desc    Accept or reject connection request.
 *          Accepting creates mutual consent connection and unlocks contact details!
 */
exports.respondToRequest = async (req, res) => {
  try {
    const { action } = req.body; // 'accept' or 'reject'
    if (!['accept', 'reject'].includes(action)) {
      return res.status(400).json({ success: false, error: "Action must be 'accept' or 'reject'" });
    }

    const connReq = await ConnectionRequest.findById(req.params.id);
    if (!connReq) {
      return res.status(404).json({ success: false, error: 'Connection request not found' });
    }

    if (connReq.provider_id.toString() !== req.user._id.toString()) {
      return res.status(403).json({ success: false, error: 'Not authorized to respond to this request' });
    }

    connReq.status = action === 'accept' ? 'accepted' : 'rejected';
    connReq.responded_at = new Date();
    await connReq.save();

    let activeConnection = null;

    if (action === 'accept') {
      // Create established connection with mutual consent
      activeConnection = await Connection.create({
        user_a: connReq.requester_id,
        user_b: connReq.provider_id,
        connection_request_id: connReq._id,
        consent_state: 'accepted',
        chat_enabled: true,
        call_enabled: true
      });
    }

    return res.status(200).json({
      success: true,
      message: `Connection request ${connReq.status}`,
      request: connReq,
      connection: activeConnection
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * @route   GET /api/connections
 * @desc    Get user's active accepted connections (with consent-unlocked contact info)
 */
exports.getConnections = async (req, res) => {
  try {
    const activeConns = await Connection.find({
      $or: [{ user_a: req.user._id }, { user_b: req.user._id }],
      consent_state: 'accepted'
    }).populate('user_a user_b', 'name phone profession locality_name verification reputation location');

    const result = activeConns.map(conn => {
      const isUserA = conn.user_a._id.toString() === req.user._id.toString();
      const partner = isUserA ? conn.user_b : conn.user_a;

      // UNLOCKED PROFILE DTO: phone number is exposed because consent_state === 'accepted'!
      const unlockedProfile = toPublicProfileDTO(partner, {
        isConnectedWithConsent: true
      });

      return {
        connection_id: conn._id,
        partner: unlockedProfile,
        chat_enabled: conn.chat_enabled,
        created_at: conn.created_at
      };
    });

    return res.status(200).json({ success: true, connections: result });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};
