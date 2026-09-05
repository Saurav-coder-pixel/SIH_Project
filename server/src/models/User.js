const mongoose = require('mongoose');

const RegulatedProfessions = [
  'doctor',
  'physician',
  'chartered accountant',
  'ca',
  'financial advisor',
  'lawyer',
  'advocate',
  'pharmacist'
];

const userSchema = new mongoose.Schema({
  phone: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  name: {
    type: String,
    required: true,
    trim: true
  },
  role: {
    type: String,
    enum: ['seeker', 'provider', 'both'],
    default: 'both'
  },
  bio: {
    type: String,
    default: ''
  },
  profession: {
    type: String,
    default: '',
    trim: true
  },
  skills: [{
    type: String,
    trim: true
  }],
  services: [{
    type: String,
    trim: true
  }],
  interests: [{
    type: String,
    trim: true
  }],
  experience: [{
    title: String,
    organization: String,
    years: Number
  }],
  availability: {
    status: {
      type: String,
      enum: ['available', 'busy', 'offline'],
      default: 'available'
    },
    hours: {
      type: String,
      default: 'Flexible'
    }
  },
  verification: {
    tier: {
      type: Number,
      enum: [1, 2, 3],
      default: 1
    },
    status: {
      type: String,
      enum: ['unverified', 'pending', 'verified'],
      default: 'unverified'
    },
    verified_at: Date
  },
  reputation: {
    score: {
      type: Number,
      default: 5.0,
      min: 0,
      max: 5.0
    },
    review_count: {
      type: Number,
      default: 0
    }
  },
  // Exact coordinates stored server-side ONLY. Indexed with 2dsphere.
  location: {
    type: {
      type: String,
      enum: ['Point'],
      default: 'Point'
    },
    coordinates: {
      type: [Number], // [longitude, latitude]
      required: true,
      default: [77.5946, 12.9716] // Default: Bengaluru
    }
  },
  locality_name: {
    type: String,
    required: true,
    default: 'Central Bengaluru'
  },
  location_visibility: {
    type: String,
    enum: ['exact_hidden', 'locality_only', 'approx_distance'],
    default: 'locality_only'
  },
  contact_settings: {
    allow_direct_message: {
      type: Boolean,
      default: false
    },
    hide_contact_until_consent: {
      type: Boolean,
      default: true
    }
  },
  search_radius_km: {
    type: Number,
    default: 5,
    min: 1,
    max: 50
  },
  status: {
    type: String,
    enum: ['active', 'suspended', 'pending_verification'],
    default: 'active'
  },
  created_at: {
    type: Date,
    default: Date.now
  }
});

// Enable 2dsphere index for fast nearby geospatial search
userSchema.index({ location: '2dsphere' });

// Helper to check if user's profession is regulated
userSchema.methods.isRegulatedProfession = function() {
  if (!this.profession) return false;
  const norm = this.profession.toLowerCase().trim();
  return RegulatedProfessions.some(p => norm.includes(p));
};

module.exports = mongoose.model('User', userSchema);
module.exports.RegulatedProfessions = RegulatedProfessions;
