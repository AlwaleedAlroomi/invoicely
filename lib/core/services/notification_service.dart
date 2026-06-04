import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:invoicely/core/utils/fade_through_route.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/invoice/view/invoice_view_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future init() async {
    final androidSettings = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );

    final initSettings = InitializationSettings(android: androidSettings);

    await _notification.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        final String? payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          _navigateToInvoice(payload);
        }
      },
    );

    final NotificationAppLaunchDetails? appLaunchDetails = await _notification
        .getNotificationAppLaunchDetails();
    if (appLaunchDetails != null && appLaunchDetails.didNotificationLaunchApp) {
      final String? payload = appLaunchDetails.notificationResponse?.payload;
      if (payload != null && payload.isNotEmpty) {
        _navigateToInvoice(payload);
      }
    }
  }

  void _navigateToInvoice(String invoiceId) async {
    final intId = int.tryParse(invoiceId);

    if (intId == null) return;

    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'invoicely.db'));
    final backgroundExecutor = NativeDatabase(dbFile);
    final db = AppDatabase.connect(DatabaseConnection(backgroundExecutor));

    final Invoice? driftInvoice = await (db.select(
      db.invoices,
    )..where((tbl) => tbl.id.equals(intId))).getSingleOrNull();

    await db.close();
    if (driftInvoice != null) {
      final InvoiceModel initInvoice = InvoiceModel.fromDb(driftInvoice);
      navigatorKey.currentState?.push(
        FadeThroughRoute(page: InvoiceViewScreen(initInvoice: initInvoice)),
      );
    }
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
          channelDescription: 'Channel for invoice due date reminders',
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
