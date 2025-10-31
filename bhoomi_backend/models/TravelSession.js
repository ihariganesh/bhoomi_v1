const mongoose = require('mongoose');

const travelSessionSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  startTime: {
    type: Date,
    required: true
  },
  endTime: {
    type: Date
  },
  vehicleType: {
    type: String,
    required: true,
    enum: ['petrol', 'diesel', 'electric', 'hybrid', 'bicycle', 'walk', 'bus', 'train', 'metro'],
    default: 'petrol'
  },
  totalDistanceKm: {
    type: Number,
    default: 0,
    min: 0
  },
  carbonEmittedKg: {
    type: Number,
    default: 0,
    min: 0
  },
  fuelConsumedLitres: {
    type: Number,
    default: 0,
    min: 0
  },
  locations: [{
    latitude: { type: Number, required: true },
    longitude: { type: Number, required: true },
    timestamp: { type: Date, default: Date.now },
    accuracy: Number
  }],
  isActive: {
    type: Boolean,
    default: true
  },
  route: {
    startLocation: {
      address: String,
      coordinates: {
        latitude: Number,
        longitude: Number
      }
    },
    endLocation: {
      address: String,
      coordinates: {
        latitude: Number,
        longitude: Number
      }
    }
  },
  weather: {
    temperature: Number,
    condition: String
  },
  notes: String,
  synced: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true
});

// Index for efficient queries
travelSessionSchema.index({ user: 1, startTime: -1 });
travelSessionSchema.index({ createdAt: -1 });

// Virtual for duration
travelSessionSchema.virtual('durationMinutes').get(function() {
  if (!this.endTime) return 0;
  return Math.round((this.endTime - this.startTime) / 60000);
});

// Method to calculate carbon saved vs average car
travelSessionSchema.methods.calculateCarbonSaved = function() {
  const averageCarEmission = 0.24; // kg CO2 per km
  const emissionFactor = {
    petrol: 0.24,
    diesel: 0.27,
    electric: 0.05,
    hybrid: 0.12,
    bicycle: 0,
    walk: 0,
    bus: 0.089,
    train: 0.041,
    metro: 0.033
  };
  
  const actualEmission = this.totalDistanceKm * (emissionFactor[this.vehicleType] || 0.24);
  return (this.totalDistanceKm * averageCarEmission) - actualEmission;
};

module.exports = mongoose.model('TravelSession', travelSessionSchema);
