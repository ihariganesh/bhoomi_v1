const express = require('express');
const router = express.Router();
const SmartMeterReading = require('../models/SmartMeterReading');

// Configuration for emission limits
const EMISSION_LIMITS = {
  hourly: 20,    // kg CO2 per hour
  daily: 400,    // kg CO2 per day
  warning: 0.8   // Warn at 80% of limit
};

/**
 * @route   POST /api/smart-meter/reading
 * @desc    Receive smart meter reading from simulator
 * @access  Public
 */
router.post('/reading', async (req, res) => {
  try {
    const {
      lab_name,
      timestamp,
      voltage,
      current,
      power_watts,
      power_kwh,
      co2_kg,
      total_kwh,
      total_co2_kg,
      lab_state,
      reading_number
    } = req.body;

    // Validate required fields
    if (!lab_name || voltage === undefined || current === undefined) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields'
      });
    }

    // Create new reading
    const reading = new SmartMeterReading({
      lab_name,
      timestamp: timestamp || Date.now(),
      voltage,
      current,
      power_watts,
      power_kwh,
      co2_kg,
      total_kwh,
      total_co2_kg,
      lab_state,
      reading_number
    });

    await reading.save();

    // Check if emission limit exceeded
    const hourlyCheck = await SmartMeterReading.checkLimitExceeded(
      lab_name,
      EMISSION_LIMITS.hourly,
      60
    );

    const response = {
      success: true,
      message: 'Reading received',
      reading_id: reading._id,
      limit_status: hourlyCheck
    };

    // Add warning if approaching or exceeded limit
    if (hourlyCheck.exceeded) {
      response.warning = `🚨 CRITICAL: CO₂ limit exceeded! ${hourlyCheck.current.toFixed(2)} kg / ${hourlyCheck.limit} kg (${hourlyCheck.percentage.toFixed(1)}%)`;
      response.alert_level = 'critical';
    } else if (hourlyCheck.percentage >= EMISSION_LIMITS.warning * 100) {
      response.warning = `⚠️ WARNING: Approaching CO₂ limit! ${hourlyCheck.current.toFixed(2)} kg / ${hourlyCheck.limit} kg (${hourlyCheck.percentage.toFixed(1)}%)`;
      response.alert_level = 'warning';
    } else {
      response.alert_level = 'normal';
    }

    res.json(response);

  } catch (error) {
    console.error('Error receiving meter reading:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/smart-meter/latest/:labName
 * @desc    Get latest reading for a lab
 * @access  Public
 */
router.get('/latest/:labName', async (req, res) => {
  try {
    const { labName } = req.params;
    
    const reading = await SmartMeterReading.getLatestReading(labName);
    
    if (!reading) {
      return res.status(404).json({
        success: false,
        message: 'No readings found for this lab'
      });
    }

    // Get limit status
    const limitStatus = await SmartMeterReading.checkLimitExceeded(
      labName,
      EMISSION_LIMITS.hourly,
      60
    );

    res.json({
      success: true,
      reading,
      limit_status: limitStatus
    });

  } catch (error) {
    console.error('Error fetching latest reading:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/smart-meter/history/:labName
 * @desc    Get reading history for a lab
 * @access  Public
 */
router.get('/history/:labName', async (req, res) => {
  try {
    const { labName } = req.params;
    const { hours = 1, limit = 100 } = req.query;
    
    const startTime = new Date(Date.now() - hours * 60 * 60 * 1000);
    
    const readings = await SmartMeterReading.find({
      lab_name: labName,
      timestamp: { $gte: startTime }
    })
      .sort({ timestamp: -1 })
      .limit(parseInt(limit));

    res.json({
      success: true,
      count: readings.length,
      readings
    });

  } catch (error) {
    console.error('Error fetching reading history:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/smart-meter/summary/:labName
 * @desc    Get hourly summary for a lab
 * @access  Public
 */
router.get('/summary/:labName', async (req, res) => {
  try {
    const { labName } = req.params;
    const { hours = 24 } = req.query;
    
    const summary = await SmartMeterReading.getHourlySummary(
      labName,
      parseInt(hours)
    );

    // Calculate totals
    const totals = summary.reduce((acc, hour) => {
      acc.total_kwh += hour.total_kwh;
      acc.total_co2_kg += hour.total_co2_kg;
      acc.reading_count += hour.reading_count;
      return acc;
    }, { total_kwh: 0, total_co2_kg: 0, reading_count: 0 });

    res.json({
      success: true,
      lab_name: labName,
      time_range: `${hours} hours`,
      hourly_data: summary,
      totals: {
        total_kwh: totals.total_kwh.toFixed(4),
        total_co2_kg: totals.total_co2_kg.toFixed(4),
        reading_count: totals.reading_count,
        estimated_cost_inr: (totals.total_kwh * 7).toFixed(2),
        trees_needed: (totals.total_co2_kg / 21).toFixed(2)
      }
    });

  } catch (error) {
    console.error('Error fetching summary:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/smart-meter/labs
 * @desc    Get list of all labs with latest readings
 * @access  Public
 */
router.get('/labs', async (req, res) => {
  try {
    // Get distinct lab names
    const labNames = await SmartMeterReading.distinct('lab_name');
    
    // Get latest reading for each lab
    const labs = await Promise.all(
      labNames.map(async (labName) => {
        const latest = await SmartMeterReading.getLatestReading(labName);
        const limitStatus = await SmartMeterReading.checkLimitExceeded(
          labName,
          EMISSION_LIMITS.hourly,
          60
        );
        
        return {
          lab_name: labName,
          latest_reading: latest,
          limit_status: limitStatus,
          alert_level: limitStatus.exceeded ? 'critical' 
            : limitStatus.percentage >= 80 ? 'warning' 
            : 'normal'
        };
      })
    );

    res.json({
      success: true,
      count: labs.length,
      labs
    });

  } catch (error) {
    console.error('Error fetching labs:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

/**
 * @route   DELETE /api/smart-meter/readings/:labName
 * @desc    Delete all readings for a lab (for testing)
 * @access  Public
 */
router.delete('/readings/:labName', async (req, res) => {
  try {
    const { labName } = req.params;
    
    const result = await SmartMeterReading.deleteMany({ lab_name: labName });

    res.json({
      success: true,
      message: `Deleted ${result.deletedCount} readings for ${labName}`
    });

  } catch (error) {
    console.error('Error deleting readings:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

module.exports = router;
