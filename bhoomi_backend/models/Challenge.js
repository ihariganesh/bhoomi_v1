const mongoose = require('mongoose');

const challengeSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true
  },
  description: {
    type: String,
    required: true
  },
  type: {
    type: String,
    enum: ['individual', 'team', 'community'],
    default: 'individual'
  },
  category: {
    type: String,
    enum: ['transportation', 'energy', 'waste', 'food', 'water', 'general'],
    required: true
  },
  difficulty: {
    type: String,
    enum: ['easy', 'medium', 'hard'],
    default: 'medium'
  },
  points: {
    type: Number,
    required: true,
    min: 0
  },
  target: {
    value: Number,
    unit: String,
    description: String
  },
  duration: {
    type: Number, // in days
    default: 7
  },
  startDate: {
    type: Date,
    default: Date.now
  },
  endDate: {
    type: Date,
    required: true
  },
  isFestivalCampaign: {
    type: Boolean,
    default: false
  },
  festival: {
    name: String,
    icon: String
  },
  icon: String,
  badge: {
    name: String,
    icon: String
  },
  participants: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    progress: {
      type: Number,
      default: 0,
      min: 0,
      max: 100
    },
    completed: {
      type: Boolean,
      default: false
    },
    completedAt: Date,
    joinedAt: {
      type: Date,
      default: Date.now
    }
  }],
  teams: [{
    team: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Team'
    },
    progress: Number,
    rank: Number
  }],
  rewards: [{
    rank: Number,
    points: Number,
    badge: String
  }],
  isActive: {
    type: Boolean,
    default: true
  },
  featured: {
    type: Boolean,
    default: false
  }
}, {
  timestamps: true
});

// Index for performance
challengeSchema.index({ startDate: 1, endDate: 1 });
challengeSchema.index({ isActive: 1, featured: -1 });

// Method to join challenge
challengeSchema.methods.joinChallenge = function(userId) {
  const exists = this.participants.some(p => p.user.toString() === userId.toString());
  if (!exists) {
    this.participants.push({ user: userId });
    return this.save();
  }
  return this;
};

// Method to update progress
challengeSchema.methods.updateProgress = function(userId, progressValue) {
  const participant = this.participants.find(p => p.user.toString() === userId.toString());
  if (participant) {
    participant.progress = Math.min(progressValue, 100);
    if (participant.progress >= 100 && !participant.completed) {
      participant.completed = true;
      participant.completedAt = new Date();
    }
    return this.save();
  }
  return this;
};

module.exports = mongoose.model('Challenge', challengeSchema);
