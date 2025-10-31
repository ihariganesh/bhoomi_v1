const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const User = require('../models/User');

// Get user leaderboard
router.get('/users', auth.protect, async (req, res) => {
  try {
    const limit = parseInt(req.query.limit) || 50;
    
    const users = await User.find()
      .select('name avatar stats')
      .sort({ 'stats.points': -1, 'stats.totalCarbonSaved': -1 })
      .limit(limit);

    res.json({ success: true, data: { leaderboard: users } });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Get team leaderboard
router.get('/teams', auth.protect, async (req, res) => {
  res.json({ success: true, data: { teams: [] }, message: 'Team leaderboard - to be implemented' });
});

// Get weekly leaderboard
router.get('/weekly', auth.protect, async (req, res) => {
  res.json({ success: true, data: { users: [] }, message: 'Weekly leaderboard - to be implemented' });
});

module.exports = router;
