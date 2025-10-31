const mongoose = require('mongoose');

const teamSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
    maxlength: 50
  },
  description: {
    type: String,
    maxlength: 200
  },
  type: {
    type: String,
    enum: ['family', 'office', 'campus', 'community', 'friends', 'other'],
    default: 'friends'
  },
  avatar: String,
  coverImage: String,
  creator: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  members: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    role: {
      type: String,
      enum: ['admin', 'moderator', 'member'],
      default: 'member'
    },
    joinedAt: {
      type: Date,
      default: Date.now
    }
  }],
  stats: {
    totalCarbonSaved: { type: Number, default: 0 },
    totalMembers: { type: Number, default: 0 },
    totalActivities: { type: Number, default: 0 },
    rank: { type: Number, default: 0 }
  },
  goals: [{
    target: Number,
    current: { type: Number, default: 0 },
    deadline: Date,
    achieved: { type: Boolean, default: false }
  }],
  isPublic: {
    type: Boolean,
    default: true
  },
  inviteCode: {
    type: String,
    unique: true
  },
  isActive: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true
});

// Generate invite code
teamSchema.pre('save', function(next) {
  if (!this.inviteCode) {
    this.inviteCode = Math.random().toString(36).substring(2, 10).toUpperCase();
  }
  this.stats.totalMembers = this.members.length;
  next();
});

// Method to add member
teamSchema.methods.addMember = function(userId, role = 'member') {
  const exists = this.members.some(m => m.user.toString() === userId.toString());
  if (!exists) {
    this.members.push({ user: userId, role });
    return this.save();
  }
  return this;
};

// Method to remove member
teamSchema.methods.removeMember = function(userId) {
  this.members = this.members.filter(m => m.user.toString() !== userId.toString());
  return this.save();
};

module.exports = mongoose.model('Team', teamSchema);
