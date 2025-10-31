const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const CarbonActivity = require('../models/CarbonActivity');

// Create activity
router.post('/', auth.protect, async (req, res) => {
  try {
    const activity = await CarbonActivity.create({ user: req.user.id, ...req.body });
    res.status(201).json({ success: true, data: { activity } });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Get activities
router.get('/', auth.protect, async (req, res) => {
  try {
    const activities = await CarbonActivity.find({ user: req.user.id }).sort({ date: -1 }).limit(50);
    res.json({ success: true, data: { activities } });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Get activity by ID
router.get('/:id', auth.protect, async (req, res) => {
  try {
    const activity = await CarbonActivity.findOne({ _id: req.params.id, user: req.user.id });
    if (!activity) return res.status(404).json({ success: false, message: 'Activity not found' });
    res.json({ success: true, data: { activity } });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Update activity
router.put('/:id', auth.protect, async (req, res) => {
  try {
    const activity = await CarbonActivity.findOneAndUpdate(
      { _id: req.params.id, user: req.user.id },
      req.body,
      { new: true }
    );
    if (!activity) return res.status(404).json({ success: false, message: 'Activity not found' });
    res.json({ success: true, data: { activity } });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Delete activity
router.delete('/:id', auth.protect, async (req, res) => {
  try {
    const activity = await CarbonActivity.findOneAndDelete({ _id: req.params.id, user: req.user.id });
    if (!activity) return res.status(404).json({ success: false, message: 'Activity not found' });
    res.json({ success: true, message: 'Activity deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

module.exports = router;
