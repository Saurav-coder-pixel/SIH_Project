const mongoose = require('mongoose');

const profileEmbeddingSchema = new mongoose.Schema({
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true
  },
  embedding_vector: {
    type: [Number],
    required: true
  },
  embedding_model: {
    type: String,
    default: 'sentence-transformers/all-MiniLM-L6-v2'
  },
  embedding_version: {
    type: String,
    default: 'v1.0'
  },
  updated_at: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('ProfileEmbedding', profileEmbeddingSchema);
