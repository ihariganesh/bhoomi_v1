const mongoose = require('mongoose');

const carbonActivitySchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  type: {
    type: String,
    required: true,
    enum: [
      'transportation',
      'electricity',
      'food',
      'waste',
      'water',
      'shopping',
      'travel',
      'other'
    ]
  },
  category: {
    type: String,
    required: true
  },
  value: {
    type: Number,
    required: true,
    min: 0
  },
  unit: {
    type: String,
    required: true
  },
  carbonFootprint: {
    type: Number,
    required: true,
    min: 0
  },
  date: {
    type: Date,
    default: Date.now,
    index: true
  },
  description: String,
  tags: [String],
  isRecurring: {
    type: Boolean,
    default: false
  },
  recurringFrequency: {
    type: String,
    enum: ['daily', 'weekly', 'monthly', null]
  },
  photo: String,
  verified: {
    type: Boolean,
    default: false
  },
  verifiedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  synced: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true
});

// Indexes for performance
carbonActivitySchema.index({ user: 1, date: -1 });
carbonActivitySchema.index({ type: 1 });
carbonActivitySchema.index({ createdAt: -1 });

// Static method to get user's total carbon footprint
carbonActivitySchema.statics.getUserTotalCarbon = async function(userId, startDate, endDate) {
  return await this.aggregate([
    {
      $match: {
        user: mongoose.Types.ObjectId(userId),
        date: { $gte: startDate, $lte: endDate }
      }
    },
    {
      $group: {
        _id: '$type',
        total: { $sum: '$carbonFootprint' },
        count: { $sum: 1 }
      }
    }
  ]);
};

module.exports = mongoose.model('CarbonActivity', carbonActivitySchema);
