const mongoose = require('mongoose');

const connectionRequestSchema = new mongoose.Schema({
  requester_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  provider_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  need_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Need'
  },
  message: {
    type: String,
    trim: true,
    default: 'I would like to connect regarding your service.'
  },
  status: {
    type: String,
    enum: ['pending', 'accepted', 'rejected'],
    default: 'pending'
  },
  created_at: {
    type: Date,
    default: Date.now
  },
  responded_at: Date
});

module.exports = mongoose.model('ConnectionRequest', connectionRequestSchema);
