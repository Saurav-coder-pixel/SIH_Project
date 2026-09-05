const Report = require('../models/Report');
const Need = require('../models/Need');
const ConnectionRequest = require('../models/ConnectionRequest');
const Connection = require('../models/Connection');

/**
 * @route   POST /api/reports
 * @desc    Submit a user or false skill claim report
 */
exports.createReport = async (req, res) => {
  try {
    const { target_type, target_id, reason, comment } = req.body;

    if (!target_type || !target_id || !reason) {
      return res.status(400).json({ success: false, error: 'target_type, target_id, and reason are required' });
    }

    const newReport = await Report.create({
      reporter_id: req.user._id,
      target_type,
      target_id,
      reason,
      comment: comment || ''
    });

    return res.status(201).json({
      success: true,
      message: 'Report submitted for admin review',
      report: newReport
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * @route   GET /api/admin/analytics/funnel
 * @desc    Get funnel conversion metrics (needs -> requests -> accepted connections)
 */
exports.getAnalyticsFunnel = async (req, res) => {
  try {
    const totalNeeds = await Need.countDocuments();
    const totalRequests = await ConnectionRequest.countDocuments();
    const acceptedRequests = await ConnectionRequest.countDocuments({ status: 'accepted' });
    const totalConnections = await Connection.countDocuments({ consent_state: 'accepted' });

    const conversionRate = totalNeeds > 0 ? (acceptedRequests / totalNeeds) * 100 : 0;

    return res.status(200).json({
      success: true,
      funnel: {
        total_needs_submitted: totalNeeds,
        total_connection_requests_sent: totalRequests,
        total_requests_accepted: acceptedRequests,
        total_active_connections: totalConnections,
        conversion_rate_percentage: Math.round(conversionRate * 10) / 10
      }
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};
