const mongoose = require('mongoose');

const reportSchema = new mongoose.Schema({
  reporter_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  target_type: {
    type: String,
    enum: ['user', 'need', 'message'],
    required: true
  },
  target_id: {
    type: mongoose.Schema.Types.ObjectId,
    required: true
  },
  reason: {
    type: String,
    required: true,
    enum: ['false_skill_claim', 'spam', 'harassment', 'too_far', 'unprofessional', 'other']
  },
  comment: {
    type: String,
    trim: true
  },
  status: {
    type: String,
    enum: ['pending', 'reviewed', 'resolved', 'dismissed'],
    default: 'pending'
  },
  created_at: {
    type: Date,
    default: Date.now
  },
  resolved_at: Date
});

module.exports = mongoose.model('Report', reportSchema);
