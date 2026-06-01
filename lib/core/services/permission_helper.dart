import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PermissionHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<bool> requestNotificationPermissions() async {
    if (Platform.isAndroid) {
      _requestAndroidNotificationPermissions();
    }
    return true;
  }

  Future<bool> _requestAndroidNotificationPermissions() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) {
      print('android pluging not available');
      return false;
    }

    final notificationGranted = await androidPlugin
        .requestNotificationsPermission();
    print('Notification permission granted: $notificationGranted');

    if (notificationGranted != true) {
      return false;
    }

    final exactAlarmGranted = await androidPlugin
        .requestExactAlarmsPermission();
    print('Exact alarm permission granted: $exactAlarmGranted');
    return true;
  }
}
