import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

/// Connectivity Service
/// Monitors online/offline status and triggers sync

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  final _statusController = StreamController<bool>.broadcast();
  Stream<bool> get statusStream => _statusController.stream;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial status
    final result = await _connectivity.checkConnectivity();
    _isOnline = !result.contains(ConnectivityResult.none);

    // Listen for changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final wasOnline = _isOnline;
      _isOnline = !results.contains(ConnectivityResult.none);

      if (_isOnline && !wasOnline) {
        _onBackOnline();
      }

      _statusController.add(_isOnline);
    });
  }

  /// Called when connection is restored
  void _onBackOnline() {
    print('Connection restored - triggering sync');
    // Trigger sync when back online
    // OfflineSyncManager.syncAll(); // Will be called by the app
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _statusController.close();
  }
}
