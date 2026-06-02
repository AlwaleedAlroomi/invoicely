import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();

  Future init() async {
    final androidSettings = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );

    final initSettings = InitializationSettings(android: androidSettings);

    await _notification.initialize(settings: initSettings);

    tz.initializeTimeZones();
  }

  Future showBasicNotification({
    required String title,
    required String body,
  }) async {
    try {
      await _notification.show(
        id: 0,
        title: title,
        body: body,
        notificationDetails: buildNotificationDetails(
          channelId: 'reminder_channel',
          channelName: 'reminder channel',
          channelDescription: 'Channedl for invoice due date reminders',
        ),
      );
    } catch (e) {}
  }

  NotificationDetails buildNotificationDetails({
    required String channelId,
    required String channelName,
    String? channelDescription,
    Importance importance = Importance.high,
    Priority priority = Priority.high,
    bool silent = false,
  }) {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: importance,
      priority: priority,
      silent: silent,
      enableVibration: !silent,
      icon: '@mipmap/ic_launcher',
    );

    return NotificationDetails(android: androidDetails);
  }
}
