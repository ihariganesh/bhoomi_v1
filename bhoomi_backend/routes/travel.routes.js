const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const TravelSession = require('../models/TravelSession');

// Create travel session
router.post('/', auth.protect, async (req, res) => {
  try {
    const session = await TravelSession.create({
      user: req.user.id,
      ...req.body
    });

    res.status(201).json({ success: true, data: { session } });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Get user's travel sessions
router.get('/', auth.protect, async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const skip = (page - 1) * limit;

    const sessions = await TravelSession.find({ user: req.user.id })
      .sort({ startTime: -1 })
      .limit(limit)
      .skip(skip);

    const total = await TravelSession.countDocuments({ user: req.user.id });

    res.json({
      success: true,
      data: {
        sessions,
        pagination: {
          current: page,
          pages: Math.ceil(total / limit),
          total
        }
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Get specific travel session
router.get('/:id', auth.protect, async (req, res) => {
  try {
    const session = await TravelSession.findOne({
      _id: req.params.id,
      user: req.user.id
    });

    if (!session) {
      return res.status(404).json({ success: false, message: 'Session not found' });
    }

    res.json({ success: true, data: { session } });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Update travel session
router.put('/:id', auth.protect, async (req, res) => {
  try {
    const session = await TravelSession.findOneAndUpdate(
      { _id: req.params.id, user: req.user.id },
      req.body,
      { new: true, runValidators: true }
    );

    if (!session) {
      return res.status(404).json({ success: false, message: 'Session not found' });
    }

    res.json({ success: true, data: { session } });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Delete travel session
router.delete('/:id', auth.protect, async (req, res) => {
  try {
    const session = await TravelSession.findOneAndDelete({
      _id: req.params.id,
      user: req.user.id
    });

    if (!session) {
      return res.status(404).json({ success: false, message: 'Session not found' });
    }

    res.json({ success: true, message: 'Session deleted successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Get travel statistics
router.get('/stats/summary', auth.protect, async (req, res) => {
  try {
    const stats = await TravelSession.aggregate([
      { $match: { user: req.user._id } },
      {
        $group: {
          _id: null,
          totalDistance: { $sum: '$totalDistanceKm' },
          totalCarbon: { $sum: '$carbonEmittedKg' },
          totalSessions: { $sum: 1 }
        }
      }
    ]);

    res.json({
      success: true,
      data: {
        stats: stats[0] || {
          totalDistance: 0,
          totalCarbon: 0,
          totalSessions: 0
        }
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

module.exports = router;
