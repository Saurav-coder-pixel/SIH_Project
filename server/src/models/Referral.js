const mongoose = require('mongoose');

const referralSchema = new mongoose.Schema({
  referrer_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  code: {
    type: String,
    required: true,
    unique: true,
    uppercase: true,
    trim: true
  },
  referred_user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  locality_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Locality'
  },
  conversion_state: {
    type: String,
    enum: ['shared', 'registered', 'verified'],
    default: 'shared'
  },
  created_at: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Referral', referralSchema);
