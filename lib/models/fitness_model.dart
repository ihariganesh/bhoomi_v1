/// Fitness and Mobility Tracking
/// Integrates with health APIs to track eco-friendly commute
/// and reward users for walking, cycling, and using public transport

class FitnessTracker {
  /// Track a commute activity
  static Future<CommuteActivity> trackActivity({
    required CommuteType type,
    required double distance, // in km
    required Duration duration,
    required DateTime startTime,
    DateTime? endTime,
  }) async {
    final activity = CommuteActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      distance: distance,
      duration: duration,
      startTime: startTime,
      endTime: endTime ?? DateTime.now(),
      co2Saved: _calculateCO2Saved(type, distance),
      caloriesBurned: _calculateCalories(type, distance, duration),
      pointsEarned: _calculatePoints(type, distance),
    );

    return activity;
  }

  /// Calculate CO2 saved compared to driving
  static double _calculateCO2Saved(CommuteType type, double distance) {
    // Car emits ~0.12 kg CO2 per km
    const carEmission = 0.12;

    switch (type) {
      case CommuteType.walking:
      case CommuteType.cycling:
        return distance * carEmission; // Full savings
      case CommuteType.publicTransport:
        return distance * carEmission * 0.6; // 60% savings
      case CommuteType.carpool:
        return distance * carEmission * 0.5; // 50% savings
      case CommuteType.electricVehicle:
        return distance * carEmission * 0.8; // 80% savings
      default:
        return 0;
    }
  }

  /// Calculate calories burned
  static int _calculateCalories(
    CommuteType type,
    double distance,
    Duration duration,
  ) {
    final hours = duration.inMinutes / 60.0;

    switch (type) {
      case CommuteType.walking:
        return (280 * hours).round(); // ~280 cal/hour walking
      case CommuteType.cycling:
        return (400 * hours).round(); // ~400 cal/hour cycling
      case CommuteType.publicTransport:
        return (100 * hours).round(); // Standing/walking to stop
      case CommuteType.carpool:
      case CommuteType.electricVehicle:
        return 0; // No calories burned
    }
  }

  /// Calculate points earned
  static int _calculatePoints(CommuteType type, double distance) {
    switch (type) {
      case CommuteType.walking:
        return (distance * 15).round(); // 15 points per km
      case CommuteType.cycling:
        return (distance * 20).round(); // 20 points per km
      case CommuteType.publicTransport:
        return (distance * 10).round(); // 10 points per km
      case CommuteType.carpool:
        return (distance * 8).round(); // 8 points per km
      case CommuteType.electricVehicle:
        return (distance * 5).round(); // 5 points per km
    }
  }

  /// Get weekly summary
  static FitnessSummary getWeeklySummary(List<CommuteActivity> activities) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final weekActivities = activities
        .where((a) => a.startTime.isAfter(weekAgo))
        .toList();

    return FitnessSummary(
      totalDistance: weekActivities.fold(0.0, (sum, a) => sum + a.distance),
      totalCO2Saved: weekActivities.fold(0.0, (sum, a) => sum + a.co2Saved),
      totalCalories: weekActivities.fold(0, (sum, a) => sum + a.caloriesBurned),
      totalPoints: weekActivities.fold(0, (sum, a) => sum + a.pointsEarned),
      activeDays: weekActivities.map((a) => a.startTime.day).toSet().length,
      activitiesByType: _groupByType(weekActivities),
    );
  }

  static Map<CommuteType, int> _groupByType(List<CommuteActivity> activities) {
    final map = <CommuteType, int>{};
    for (final activity in activities) {
      map[activity.type] = (map[activity.type] ?? 0) + 1;
    }
    return map;
  }
}

/// Commute Activity Model
class CommuteActivity {
  final String id;
  final CommuteType type;
  final double distance; // in km
  final Duration duration;
  final DateTime startTime;
  final DateTime endTime;
  final double co2Saved; // in kg
  final int caloriesBurned;
  final int pointsEarned;
  final String? notes;
  final bool isSynced;

  CommuteActivity({
    required this.id,
    required this.type,
    required this.distance,
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.co2Saved,
    required this.caloriesBurned,
    required this.pointsEarned,
    this.notes,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'distance': distance,
      'duration': duration.inSeconds,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'co2Saved': co2Saved,
      'caloriesBurned': caloriesBurned,
      'pointsEarned': pointsEarned,
      'notes': notes,
      'isSynced': isSynced,
    };
  }

  factory CommuteActivity.fromJson(Map<String, dynamic> json) {
    return CommuteActivity(
      id: json['id'],
      type: CommuteType.values.firstWhere((e) => e.toString() == json['type']),
      distance: json['distance'].toDouble(),
      duration: Duration(seconds: json['duration']),
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      co2Saved: json['co2Saved'].toDouble(),
      caloriesBurned: json['caloriesBurned'],
      pointsEarned: json['pointsEarned'],
      notes: json['notes'],
      isSynced: json['isSynced'] ?? false,
    );
  }
}

/// Fitness Summary
class FitnessSummary {
  final double totalDistance;
  final double totalCO2Saved;
  final int totalCalories;
  final int totalPoints;
  final int activeDays;
  final Map<CommuteType, int> activitiesByType;

  FitnessSummary({
    required this.totalDistance,
    required this.totalCO2Saved,
    required this.totalCalories,
    required this.totalPoints,
    required this.activeDays,
    required this.activitiesByType,
  });
}

enum CommuteType { walking, cycling, publicTransport, carpool, electricVehicle }

extension CommuteTypeExtension on CommuteType {
  String get displayName {
    switch (this) {
      case CommuteType.walking:
        return 'Walking';
      case CommuteType.cycling:
        return 'Cycling';
      case CommuteType.publicTransport:
        return 'Public Transport';
      case CommuteType.carpool:
        return 'Carpooling';
      case CommuteType.electricVehicle:
        return 'Electric Vehicle';
    }
  }

  String get displayNameHi {
    switch (this) {
      case CommuteType.walking:
        return 'पैदल';
      case CommuteType.cycling:
        return 'साइकिल';
      case CommuteType.publicTransport:
        return 'सार्वजनिक परिवहन';
      case CommuteType.carpool:
        return 'कारपूलिंग';
      case CommuteType.electricVehicle:
        return 'इलेक्ट्रिक वाहन';
    }
  }

  String get icon {
    switch (this) {
      case CommuteType.walking:
        return '🚶';
      case CommuteType.cycling:
        return '🚴';
      case CommuteType.publicTransport:
        return '🚌';
      case CommuteType.carpool:
        return '🚗';
      case CommuteType.electricVehicle:
        return '⚡';
    }
  }
}
