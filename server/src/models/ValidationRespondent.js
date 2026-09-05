const mongoose = require('mongoose');

const validationRespondentSchema = new mongoose.Schema({
  segment: {
    type: String,
    enum: ['service_seeker', 'local_provider', 'regulated_professional', 'student'],
    required: true
  },
  approached: {
    type: Boolean,
    default: true
  },
  completed: {
    type: Boolean,
    default: true
  },
  current_solution: {
    type: String,
    trim: true
  },
  pain_points: [{
    type: String
  }],
  trust_concern: {
    type: String,
    trim: true
  },
  willingness: {
    type: String,
    enum: ['high', 'medium', 'low'],
    default: 'high'
  },
  evidence_ref: {
    type: String
  },
  created_at: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('ValidationRespondent', validationRespondentSchema);
