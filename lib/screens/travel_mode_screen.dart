import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../services/travel_tracking_service.dart';
import '../models/travel_session.dart';

class TravelModeScreen extends StatefulWidget {
  const TravelModeScreen({Key? key}) : super(key: key);

  @override
  State<TravelModeScreen> createState() => _TravelModeScreenState();
}

class _TravelModeScreenState extends State<TravelModeScreen> {
  final TravelTrackingService _trackingService = TravelTrackingService();
  String _selectedVehicle = 'petrol';
  bool _isTracking = false;
  Timer? _updateTimer;
  List<TravelSession> _travelHistory = [];

  @override
  void initState() {
    super.initState();
    _trackingService.initialize();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _trackingService.dispose();
    super.dispose();
  }

  Future<void> _toggleTracking() async {
    if (_isTracking) {
      // Stop tracking
      final session = await _trackingService.stopTracking();
      if (session != null) {
        setState(() {
          _travelHistory.insert(0, session);
          _isTracking = false;
        });
        _updateTimer?.cancel();
        _showSessionSummary(session);
      }
    } else {
      // Start tracking
      final started = await _trackingService.startTracking(_selectedVehicle);
      if (started) {
        setState(() {
          _isTracking = true;
        });
        // Update UI every second
        _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {});
          }
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location permission denied. Please enable location access.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showSessionSummary(TravelSession session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏁 Travel Session Complete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duration: ${session.durationString}'),
            const SizedBox(height: 8),
            Text('Distance: ${session.totalDistanceKm.toStringAsFixed(2)} km'),
            const SizedBox(height: 8),
            Text(
              'Fuel Used: ${session.fuelConsumedLitres.toStringAsFixed(2)} L',
            ),
            const SizedBox(height: 8),
            Text(
              'Carbon Emitted: ${session.carbonEmittedKg.toStringAsFixed(2)} kg CO2',
              style: TextStyle(
                color: session.hasExceededLimit ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (session.hasExceededLimit)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '⚠️ You exceeded the daily limit!',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Color _getLimitColor(double percentage) {
    if (percentage < 70) return Colors.green;
    if (percentage < 90) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final session = _trackingService.currentSession;
    final percentage = session?.percentageOfLimit ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '🚗 Travel Mode',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Selection
            if (!_isTracking) ...[
              Text(
                'Select Vehicle Type',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildVehicleSelector(),
              const SizedBox(height: 24),
            ],

            // Tracking Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isTracking
                    ? Colors.green.shade50
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isTracking ? Colors.green : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _isTracking ? Icons.location_on : Icons.location_off,
                    size: 48,
                    color: _isTracking ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isTracking ? 'Tracking Active' : 'Ready to Track',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _toggleTracking,
                    icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
                    label: Text(
                      _isTracking ? 'Stop Tracking' : 'Start Tracking',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isTracking ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      textStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Real-time Stats
            if (_isTracking && session != null) ...[
              const SizedBox(height: 24),
              Text(
                'Current Session',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                '🛣️ Distance',
                '${session.totalDistanceKm.toStringAsFixed(2)} km',
                Colors.blue,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                '⛽ Fuel Used',
                '${session.fuelConsumedLitres.toStringAsFixed(2)} L',
                Colors.orange,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                '🌱 Carbon Emitted',
                '${session.carbonEmittedKg.toStringAsFixed(2)} kg CO2',
                _getLimitColor(percentage),
              ),
              const SizedBox(height: 12),
              _buildProgressCard(percentage),
            ],

            // Travel History
            if (_travelHistory.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Travel History',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ..._travelHistory.take(5).map((s) => _buildHistoryCard(s)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildVehicleChip('petrol', '⛽ Petrol', '0.24 kg/km'),
        _buildVehicleChip('diesel', '🚛 Diesel', '0.27 kg/km'),
        _buildVehicleChip('electric', '⚡ Electric', '0.05 kg/km'),
        _buildVehicleChip('hybrid', '🔋 Hybrid', '0.12 kg/km'),
      ],
    );
  }

  Widget _buildVehicleChip(String type, String label, String emission) {
    final isSelected = _selectedVehicle == type;
    return FilterChip(
      selected: isSelected,
      label: Column(
        children: [
          Text(label),
          Text(emission, style: const TextStyle(fontSize: 10)),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _selectedVehicle = type;
        });
      },
      selectedColor: Colors.green.shade100,
      checkmarkColor: Colors.green,
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(double percentage) {
    final color = _getLimitColor(percentage);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Limit Progress',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 16,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          if (percentage >= 100) ...[
            const SizedBox(height: 8),
            Text(
              '⚠️ Daily limit exceeded! Consider eco-friendly transport.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHistoryCard(TravelSession session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: session.hasExceededLimit ? Colors.red : Colors.green,
          child: const Icon(Icons.route, color: Colors.white),
        ),
        title: Text(
          '${session.totalDistanceKm.toStringAsFixed(2)} km - ${session.vehicleType.toUpperCase()}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${session.carbonEmittedKg.toStringAsFixed(2)} kg CO2 • ${session.durationString}',
          style: GoogleFonts.poppins(fontSize: 12),
        ),
        trailing: session.hasExceededLimit
            ? const Icon(Icons.warning, color: Colors.red)
            : const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
