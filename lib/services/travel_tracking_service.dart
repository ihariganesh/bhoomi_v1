import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/travel_session.dart';

class TravelTrackingService {
  TravelSession? _currentSession;
  StreamSubscription<Position>? _positionStream;
  Position? _previousPosition;
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool get isTracking => _currentSession?.isActive ?? false;
  TravelSession? get currentSession => _currentSession;

  Future<void> initialize() async {
    // Initialize notifications
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(initSettings);
  }

  Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<bool> startTracking(String vehicleType) async {
    if (isTracking) {
      return false;
    }

    final hasPermission = await checkPermissions();
    if (!hasPermission) {
      return false;
    }

    _currentSession = TravelSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: DateTime.now(),
      vehicleType: vehicleType,
    );

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(_onLocationUpdate);

    return true;
  }

  void _onLocationUpdate(Position position) {
    if (_currentSession == null || !_currentSession!.isActive) {
      return;
    }

    final locationPoint = LocationPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
      accuracy: position.accuracy,
    );

    _currentSession!.locations.add(locationPoint);

    if (_previousPosition != null) {
      final distance = _calculateDistance(
        _previousPosition!.latitude,
        _previousPosition!.longitude,
        position.latitude,
        position.longitude,
      );

      _currentSession!.totalDistanceKm += distance;

      // Calculate carbon emissions
      final emissionFactor =
          TravelSession.emissionFactors[_currentSession!.vehicleType] ?? 0.24;
      _currentSession!.carbonEmittedKg =
          _currentSession!.totalDistanceKm * emissionFactor;

      // Check if limit exceeded
      if (_currentSession!.hasExceededLimit) {
        _showWarningNotification();
      }
    }

    _previousPosition = position;
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // km

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  Future<void> _showWarningNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'travel_warnings',
      'Travel Warnings',
      channelDescription: 'Warnings for exceeding carbon emission limits',
      importance: Importance.high,
      priority: Priority.high,
      color: Color.fromARGB(255, 255, 0, 0),
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      1,
      '⚠️ Carbon Limit Exceeded!',
      'You have reached your daily carbon limit of ${TravelSession.dailyLimitKg} kg CO2. Consider using eco-friendly transport.',
      notificationDetails,
    );
  }

  Future<TravelSession?> stopTracking() async {
    if (_currentSession == null || !_currentSession!.isActive) {
      return null;
    }

    _currentSession!.isActive = false;
    _currentSession!.endTime = DateTime.now();

    await _positionStream?.cancel();
    _positionStream = null;
    _previousPosition = null;

    final session = _currentSession;
    _currentSession = null;

    return session;
  }

  Future<Position?> getCurrentLocation() async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _positionStream?.cancel();
  }
}
