const mongoose = require('mongoose');

const ratingSchema = new mongoose.Schema({
  connection_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Connection',
    required: true
  },
  rater_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  rated_user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  score: {
    type: Number,
    required: true,
    min: 1,
    max: 5
  },
  tags: [{
    type: String,
    trim: true
  }],
  comment: {
    type: String,
    trim: true
  },
  moderation_state: {
    type: String,
    enum: ['published', 'flagged', 'hidden'],
    default: 'published'
  },
  created_at: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Rating', ratingSchema);
