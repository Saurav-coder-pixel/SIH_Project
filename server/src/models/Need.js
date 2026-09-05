const mongoose = require('mongoose');

const needSchema = new mongoose.Schema({
  requester_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  raw_text: {
    type: String,
    required: true,
    trim: true
  },
  parsed_need: {
    category: { type: String, required: true },
    urgency: { type: String, enum: ['immediate', 'this_week', 'flexible'], default: 'this_week' },
    extracted_keywords: [String],
    budget_range: { type: String },
    preferred_availability: { type: String }
  },
  location: {
    type: {
      type: String,
      enum: ['Point'],
      default: 'Point'
    },
    coordinates: {
      type: [Number], // [lng, lat]
      required: true
    }
  },
  locality_name: {
    type: String,
    required: true
  },
  radius_km: {
    type: Number,
    default: 5,
    min: 1,
    max: 50
  },
  status: {
    type: String,
    enum: ['active', 'matched', 'connected', 'closed'],
    default: 'active'
  },
  created_at: {
    type: Date,
    default: Date.now
  }
});

needSchema.index({ location: '2dsphere' });

module.exports = mongoose.model('Need', needSchema);
