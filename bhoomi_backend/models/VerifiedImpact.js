const mongoose = require('mongoose');

const verifiedImpactSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  activity: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'CarbonActivity'
  },
  title: {
    type: String,
    required: true,
    trim: true
  },
  description: {
    type: String,
    required: true
  },
  category: {
    type: String,
    required: true,
    enum: ['tree-planting', 'cleanup', 'recycling', 'community-event', 'education', 'other']
  },
  photos: [{
    url: String,
    caption: String,
    uploadedAt: { type: Date, default: Date.now }
  }],
  location: {
    address: String,
    coordinates: {
      latitude: Number,
      longitude: Number
    },
    verified: { type: Boolean, default: false }
  },
  impact: {
    carbonSavedKg: Number,
    treesPlanted: Number,
    wasteRecycledKg: Number,
    participantsCount: Number
  },
  verification: {
    status: {
      type: String,
      enum: ['pending', 'approved', 'rejected'],
      default: 'pending'
    },
    verifiedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    verifiedAt: Date,
    notes: String
  },
  likes: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  comments: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    text: String,
    createdAt: { type: Date, default: Date.now }
  }],
  tags: [String],
  date: {
    type: Date,
    required: true,
    default: Date.now
  },
  isPublic: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true
});

// Indexes
verifiedImpactSchema.index({ user: 1, createdAt: -1 });
verifiedImpactSchema.index({ 'verification.status': 1 });
verifiedImpactSchema.index({ category: 1 });

module.exports = mongoose.model('VerifiedImpact', verifiedImpactSchema);
