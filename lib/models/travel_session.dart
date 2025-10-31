class TravelSession {
  final String id;
  final DateTime startTime;
  DateTime? endTime;
  final String vehicleType; // petrol, diesel, electric
  double totalDistanceKm;
  double carbonEmittedKg;
  List<LocationPoint> locations;
  bool isActive;

  TravelSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.vehicleType,
    this.totalDistanceKm = 0.0,
    this.carbonEmittedKg = 0.0,
    List<LocationPoint>? locations,
    this.isActive = true,
  }) : locations = locations ?? [];

  // Emission factors in kg CO2 per km
  static const Map<String, double> emissionFactors = {
    'petrol': 0.24,
    'diesel': 0.27,
    'electric': 0.05,
    'hybrid': 0.12,
  };

  static const double dailyLimitKg = 20.0; // Daily carbon limit
  static const double fuelEfficiencyKmPerLitre = 17.0;

  double get fuelConsumedLitres => totalDistanceKm / fuelEfficiencyKmPerLitre;

  bool get hasExceededLimit => carbonEmittedKg >= dailyLimitKg;

  double get percentageOfLimit => (carbonEmittedKg / dailyLimitKg) * 100;

  String get durationString {
    if (endTime == null) {
      final duration = DateTime.now().difference(startTime);
      return _formatDuration(duration);
    } else {
      final duration = endTime!.difference(startTime);
      return _formatDuration(duration);
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'vehicleType': vehicleType,
    'totalDistanceKm': totalDistanceKm,
    'carbonEmittedKg': carbonEmittedKg,
    'locations': locations.map((l) => l.toJson()).toList(),
    'isActive': isActive,
  };

  factory TravelSession.fromJson(Map<String, dynamic> json) => TravelSession(
    id: json['id'],
    startTime: DateTime.parse(json['startTime']),
    endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    vehicleType: json['vehicleType'],
    totalDistanceKm: json['totalDistanceKm'],
    carbonEmittedKg: json['carbonEmittedKg'],
    locations: (json['locations'] as List)
        .map((l) => LocationPoint.fromJson(l))
        .toList(),
    isActive: json['isActive'] ?? false,
  );
}

class LocationPoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double? accuracy;

  LocationPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'timestamp': timestamp.toIso8601String(),
    'accuracy': accuracy,
  };

  factory LocationPoint.fromJson(Map<String, dynamic> json) => LocationPoint(
    latitude: json['latitude'],
    longitude: json['longitude'],
    timestamp: DateTime.parse(json['timestamp']),
    accuracy: json['accuracy'],
  );
}
