const Message = require('../models/Message');
const Connection = require('../models/Connection');

/**
 * @route   POST /api/conversations/messages
 * @desc    Send a message within an accepted connection
 */
exports.sendMessage = async (req, res) => {
  try {
    const { connection_id, text } = req.body;

    if (!connection_id || !text) {
      return res.status(400).json({ success: false, error: 'connection_id and text are required' });
    }

    const conn = await Connection.findById(connection_id);
    if (!conn) {
      return res.status(404).json({ success: false, error: 'Connection not found' });
    }

    if (conn.consent_state !== 'accepted') {
      return res.status(403).json({ success: false, error: 'Cannot send messages without active mutual consent' });
    }

    const isUserA = conn.user_a.toString() === req.user._id.toString();
    const isUserB = conn.user_b.toString() === req.user._id.toString();

    if (!isUserA && !isUserB) {
      return res.status(403).json({ success: false, error: 'Not a member of this connection' });
    }

    const recipientId = isUserA ? conn.user_b : conn.user_a;

    const newMessage = await Message.create({
      connection_id: conn._id,
      sender_id: req.user._id,
      recipient_id: recipientId,
      text: text.trim()
    });

    return res.status(201).json({
      success: true,
      message: newMessage
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * @route   GET /api/conversations/:connectionId/messages
 * @desc    Get message history for a connection
 */
exports.getMessages = async (req, res) => {
  try {
    const conn = await Connection.findById(req.params.connectionId);
    if (!conn) {
      return res.status(404).json({ success: false, error: 'Connection not found' });
    }

    const isUserA = conn.user_a.toString() === req.user._id.toString();
    const isUserB = conn.user_b.toString() === req.user._id.toString();

    if (!isUserA && !isUserB) {
      return res.status(403).json({ success: false, error: 'Not authorized to view these messages' });
    }

    const messages = await Message.find({ connection_id: conn._id }).sort({ created_at: 1 });

    return res.status(200).json({
      success: true,
      messages
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};
