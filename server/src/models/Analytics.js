const mongoose = require('mongoose');

const analyticsEventSchema = new mongoose.Schema({
  event_type: {
    type: String,
    required: true,
    enum: ['need_created', 'match_viewed', 'feedback_given', 'request_sent', 'request_accepted', 'message_sent']
  },
  actor_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  actor_role: {
    type: String
  },
  locality_name: {
    type: String
  },
  need_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Need'
  },
  candidate_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  metadata: {
    type: mongoose.Schema.Types.Mixed
  },
  created_at: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('AnalyticsEvent', analyticsEventSchema);
