import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Offline Storage Service
/// Uses SharedPreferences for cross-platform offline storage

class OfflineStorageService {
  static SharedPreferences? _prefs;

  /// Get preferences instance
  static Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Add to sync queue
  static Future<void> addToSyncQueue(
    String type,
    Map<String, dynamic> data,
  ) async {
    final p = await prefs;
    final queue = await getPendingSyncItems();
    queue.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': type,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'status': 'pending',
    });
    await p.setString('sync_queue', jsonEncode(queue));
  }

  /// Get pending sync items
  static Future<List<Map<String, dynamic>>> getPendingSyncItems() async {
    final p = await prefs;
    final queueStr = p.getString('sync_queue') ?? '[]';
    final List<dynamic> queueList = jsonDecode(queueStr);
    return queueList.cast<Map<String, dynamic>>();
  }

  /// Mark sync item as completed
  static Future<void> markSyncCompleted(String id) async {
    final p = await prefs;
    final queue = await getPendingSyncItems();
    queue.removeWhere((item) => item['id'] == id);
    await p.setString('sync_queue', jsonEncode(queue));
  }

  /// Save commute activity offline
  static Future<void> saveCommuteActivity(Map<String, dynamic> activity) async {
    final p = await prefs;
    final activities = await getCommuteActivities();
    activities.insert(0, activity);
    // Keep only last 100 activities
    if (activities.length > 100) {
      activities.removeRange(100, activities.length);
    }
    await p.setString('commute_activities', jsonEncode(activities));
  }

  /// Get commute activities
  static Future<List<Map<String, dynamic>>> getCommuteActivities({
    int limit = 100,
  }) async {
    final p = await prefs;
    final activitiesStr = p.getString('commute_activities') ?? '[]';
    final List<dynamic> activitiesList = jsonDecode(activitiesStr);
    final activities = activitiesList.cast<Map<String, dynamic>>();
    return activities.take(limit).toList();
  }

  /// Save recommendation
  static Future<void> saveRecommendation(
    Map<String, dynamic> recommendation,
  ) async {
    final p = await prefs;
    final recommendations = await getActiveRecommendations();
    recommendations.add(recommendation);
    await p.setString('recommendations', jsonEncode(recommendations));
  }

  /// Get active recommendations
  static Future<List<Map<String, dynamic>>> getActiveRecommendations() async {
    final p = await prefs;
    final recsStr = p.getString('recommendations') ?? '[]';
    final List<dynamic> recsList = jsonDecode(recsStr);
    return recsList.cast<Map<String, dynamic>>();
  }

  /// Save verified impact
  static Future<void> saveVerifiedImpact(Map<String, dynamic> impact) async {
    final p = await prefs;
    final impacts = await getUnsyncedImpacts();
    impacts.add(impact);
    await p.setString('verified_impacts', jsonEncode(impacts));
  }

  /// Get unsynced verified impacts
  static Future<List<Map<String, dynamic>>> getUnsyncedImpacts() async {
    final p = await prefs;
    final impactsStr = p.getString('verified_impacts') ?? '[]';
    final List<dynamic> impactsList = jsonDecode(impactsStr);
    return impactsList.cast<Map<String, dynamic>>();
  }

  /// Clear old data
  static Future<void> clearOldData() async {
    final p = await prefs;
    final queue = await getPendingSyncItems();
    final cutoffTime = DateTime.now()
        .subtract(const Duration(days: 90))
        .millisecondsSinceEpoch;
    queue.removeWhere(
      (item) =>
          item['status'] == 'completed' &&
          (item['timestamp'] as int) < cutoffTime,
    );
    await p.setString('sync_queue', jsonEncode(queue));
  }
}

/// Offline Sync Manager
class OfflineSyncManager {
  static bool _isSyncing = false;

  /// Sync all pending data
  static Future<void> syncAll() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final pendingItems = await OfflineStorageService.getPendingSyncItems();

      for (final item in pendingItems) {
        try {
          await _syncItem(item);
          await OfflineStorageService.markSyncCompleted(item['id']);
        } catch (e) {
          print('Sync error for item ${item['id']}: $e');
          // Will retry on next sync
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync individual item
  static Future<void> _syncItem(Map<String, dynamic> item) async {
    final type = item['type'];
    // TODO: Sync to backend API when online
    print('Syncing $type: ${item['id']}');
  }

  /// Check if online
  static Future<bool> isOnline() async {
    // TODO: Implement with connectivity_plus
    return true;
  }
}
