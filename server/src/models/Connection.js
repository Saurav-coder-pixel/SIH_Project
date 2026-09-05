const mongoose = require('mongoose');

const connectionSchema = new mongoose.Schema({
  user_a: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  user_b: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  connection_request_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'ConnectionRequest'
  },
  consent_state: {
    type: String,
    enum: ['accepted', 'revoked'],
    default: 'accepted'
  },
  chat_enabled: {
    type: Boolean,
    default: true
  },
  call_enabled: {
    type: Boolean,
    default: true
  },
  created_at: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Connection', connectionSchema);
