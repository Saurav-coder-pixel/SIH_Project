const mongoose = require('mongoose');

const verificationRecordSchema = new mongoose.Schema({
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  tier: {
    type: Number,
    enum: [1, 2, 3],
    required: true
  },
  method: {
    type: String,
    enum: ['phone_otp', 'kyc_id', 'peer_community', 'license_registration'],
    required: true
  },
  status: {
    type: String,
    enum: ['pending', 'approved', 'rejected'],
    default: 'pending'
  },
  registration_number: {
    type: String,
    trim: true
  },
  evidence_ref: {
    type: String
  },
  verified_at: Date,
  expires_at: Date,
  created_at: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('VerificationRecord', verificationRecordSchema);
