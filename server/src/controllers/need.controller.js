const Need = require('../models/Need');
const { parseNeedText } = require('../services/nlpParser.service');
const RankingService = require('../services/ranking.service');

// In-memory feedback store for match analytics feedback
const feedbackStore = [];

/**
 * @route   POST /api/needs
 * @desc    Create a natural language need, parse intent, and store need record
 */
exports.createNeed = async (req, res) => {
  try {
    const { raw_text, radius_km, locality_name, coordinates } = req.body;

    if (!raw_text || typeof raw_text !== 'string' || raw_text.trim().length === 0) {
      return res.status(400).json({ success: false, error: 'raw_text is required' });
    }

    // 1. Parse text using NLP Need Parser
    const parsed = parseNeedText(raw_text);

    // 2. Use user location or explicit need location
    let needCoords = req.user.location ? req.user.location.coordinates : [77.5946, 12.9716];
    if (Array.isArray(coordinates) && coordinates.length === 2) {
      needCoords = coordinates;
    }

    const needLocality = locality_name || req.user.locality_name || 'Central Bengaluru';

    // 3. Create Need document
    const newNeed = await Need.create({
      requester_id: req.user._id,
      raw_text: raw_text.trim(),
      parsed_need: parsed,
      location: {
        type: 'Point',
        coordinates: needCoords
      },
      locality_name: needLocality,
      radius_km: radius_km || req.user.search_radius_km || 5
    });

    return res.status(201).json({
      success: true,
      message: 'Need created and parsed successfully',
      need: newNeed
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * @route   GET /api/needs/me
 * @desc    Get user's submitted needs
 */
exports.getMyNeeds = async (req, res) => {
  try {
    const needs = await Need.find({ requester_id: req.user._id }).sort({ created_at: -1 });
    return res.status(200).json({ success: true, needs });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * @route   GET /api/needs/:id/matches
 * @desc    Get ranked nearby candidates for a specific Need (supports ?radius_km= slider)
 */
exports.getNeedMatches = async (req, res) => {
  try {
    const need = await Need.findById(req.params.id);
    if (!need) {
      return res.status(404).json({ success: false, error: 'Need not found' });
    }

    const overrideRadius = req.query.radius_km ? parseFloat(req.query.radius_km) : null;

    const rankingResults = await RankingService.findMatchesForNeed(need, {
      overrideRadiusKm: overrideRadius
    });

    return res.status(200).json({
      success: true,
      need_id: need._id,
      category: need.parsed_need.category,
      urgency: need.parsed_need.urgency,
      metadata: rankingResults.metadata,
      matches: rankingResults.results
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * @route   POST /api/matches/:id/feedback
 * @desc    Record structured user feedback on a match result
 *          (Useful / Not Relevant / Too Far / Not Trustworthy / Unavailable)
 */
exports.recordMatchFeedback = async (req, res) => {
  try {
    const { feedback_type, comment } = req.body;
    const validTypes = ['Useful', 'Not Relevant', 'Too Far', 'Not Trustworthy', 'Unavailable'];

    if (!validTypes.includes(feedback_type)) {
      return res.status(400).json({
        success: false,
        error: `Invalid feedback_type. Must be one of: ${validTypes.join(', ')}`
      });
    }

    const record = {
      match_id: req.params.id,
      user_id: req.user._id,
      feedback_type,
      comment: comment || '',
      created_at: new Date()
    };

    feedbackStore.push(record);

    return res.status(200).json({
      success: true,
      message: 'Feedback recorded successfully',
      feedback: record
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};
