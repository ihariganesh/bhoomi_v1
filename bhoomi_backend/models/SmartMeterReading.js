const mongoose = require('mongoose');

const smartMeterReadingSchema = new mongoose.Schema({
  lab_name: {
    type: String,
    required: true,
    trim: true
  },
  timestamp: {
    type: Date,
    required: true,
    default: Date.now
  },
  voltage: {
    type: Number,
    required: true,
    min: 0
  },
  current: {
    type: Number,
    required: true,
    min: 0
  },
  power_watts: {
    type: Number,
    required: true,
    min: 0
  },
  power_kwh: {
    type: Number,
    required: true,
    min: 0
  },
  co2_kg: {
    type: Number,
    required: true,
    min: 0
  },
  total_kwh: {
    type: Number,
    default: 0
  },
  total_co2_kg: {
    type: Number,
    default: 0
  },
  lab_state: {
    type: String,
    enum: ['idle', 'normal', 'busy', 'peak'],
    default: 'normal'
  },
  reading_number: {
    type: Number,
    default: 0
  }
}, {
  timestamps: true
});

// Indexes for efficient queries
smartMeterReadingSchema.index({ lab_name: 1, timestamp: -1 });
smartMeterReadingSchema.index({ timestamp: -1 });

// Static method to get latest reading for a lab
smartMeterReadingSchema.statics.getLatestReading = async function(labName) {
  return this.findOne({ lab_name: labName })
    .sort({ timestamp: -1 })
    .limit(1);
};

// Static method to get readings in time range
smartMeterReadingSchema.statics.getReadingsByTimeRange = async function(labName, startTime, endTime) {
  return this.find({
    lab_name: labName,
    timestamp: { $gte: startTime, $lte: endTime }
  }).sort({ timestamp: 1 });
};

// Static method to get hourly summary
smartMeterReadingSchema.statics.getHourlySummary = async function(labName, hours = 24) {
  const startTime = new Date(Date.now() - hours * 60 * 60 * 1000);
  
  return this.aggregate([
    {
      $match: {
        lab_name: labName,
        timestamp: { $gte: startTime }
      }
    },
    {
      $group: {
        _id: {
          $dateToString: {
            format: '%Y-%m-%d %H:00',
            date: '$timestamp'
          }
        },
        avg_voltage: { $avg: '$voltage' },
        avg_current: { $avg: '$current' },
        avg_power_watts: { $avg: '$power_watts' },
        total_kwh: { $sum: '$power_kwh' },
        total_co2_kg: { $sum: '$co2_kg' },
        reading_count: { $sum: 1 },
        max_power: { $max: '$power_watts' },
        min_power: { $min: '$power_watts' }
      }
    },
    { $sort: { _id: 1 } }
  ]);
};

// Static method to check if limit exceeded
smartMeterReadingSchema.statics.checkLimitExceeded = async function(labName, limitKg, timeWindowMinutes = 60) {
  const startTime = new Date(Date.now() - timeWindowMinutes * 60 * 1000);
  
  const result = await this.aggregate([
    {
      $match: {
        lab_name: labName,
        timestamp: { $gte: startTime }
      }
    },
    {
      $group: {
        _id: null,
        total_co2: { $sum: '$co2_kg' },
        total_kwh: { $sum: '$power_kwh' }
      }
    }
  ]);
  
  if (result.length > 0) {
    const totalCO2 = result[0].total_co2;
    return {
      exceeded: totalCO2 > limitKg,
      current: totalCO2,
      limit: limitKg,
      percentage: (totalCO2 / limitKg) * 100,
      timeWindow: timeWindowMinutes
    };
  }
  
  return {
    exceeded: false,
    current: 0,
    limit: limitKg,
    percentage: 0,
    timeWindow: timeWindowMinutes
  };
};

module.exports = mongoose.model('SmartMeterReading', smartMeterReadingSchema);
