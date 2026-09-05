const mongoose = require('mongoose');

const localitySchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  region: {
    type: String,
    required: true
  },
  launch_status: {
    type: String,
    enum: ['active', 'seeding', 'planned'],
    default: 'active'
  },
  supported_categories: [{
    type: String
  }],
  density_metrics: {
    total_providers: { type: Number, default: 0 },
    total_seekers: { type: Number, default: 0 },
    supply_gap_categories: [String]
  },
  created_at: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Locality', localitySchema);
