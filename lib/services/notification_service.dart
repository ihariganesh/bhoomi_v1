import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Notification Service
/// Handles local notifications for challenges and achievements

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Initialize notifications
  static Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _initialized = true;
  }

  /// Handle notification tap
  static void _onNotificationTap(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // TODO: Navigate to relevant screen based on payload
  }

  /// Show simple notification
  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'bhoomi_channel',
      'Bhoomi Notifications',
      channelDescription: 'Notifications for eco-challenges and achievements',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Show achievement notification
  static Future<void> showAchievementNotification({
    required String title,
    required int points,
  }) async {
    await showNotification(
      title: '🎉 Achievement Unlocked!',
      body: '$title (+$points points)',
      payload: 'achievement',
    );
  }

  /// Show challenge reminder
  static Future<void> showChallengeReminder({
    required String challengeName,
  }) async {
    await showNotification(
      title: '🌱 Challenge Reminder',
      body: 'Don\'t forget: $challengeName',
      payload: 'challenge',
    );
  }

  /// Show festival campaign notification
  static Future<void> showFestivalNotification({
    required String festivalName,
    required String message,
  }) async {
    await showNotification(
      title: '🪔 $festivalName Special',
      body: message,
      payload: 'festival',
    );
  }

  /// Show CO2 milestone notification
  static Future<void> showMilestoneNotification({
    required double co2Saved,
  }) async {
    await showNotification(
      title: '🎯 Milestone Reached!',
      body: 'You\'ve saved ${co2Saved.toStringAsFixed(1)} kg of CO2!',
      payload: 'milestone',
    );
  }
}
