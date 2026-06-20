import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' hide Priority;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:invoicely/core/utils/fade_through_route.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/invoice/view/invoice_view_screen.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  factory NotificationService() => instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();
  AppDatabase? _db;

  String? _pendingPaylod;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future init(AppDatabase db) async {
    _db = db;
    final androidSettings = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );

    final initSettings = InitializationSettings(android: androidSettings);

    await _notification.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
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
        // await Future.delayed(const Duration(milliseconds: 500));
        // _navigateToInvoice(payload);
        _pendingPaylod = payload;
      }
    }
  }

  void drainPendingPayload() {
    if (_pendingPaylod == null) return;

    final payload = _pendingPaylod;
    _pendingPaylod = null;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _navigateToInvoice(payload!);
    });
  }

  void _navigateToInvoice(String invoiceId) async {
    final db = _db;
    if (db == null) return;
    final intId = int.tryParse(invoiceId);
    if (intId == null) return;

    final Invoice? driftInvoice = await (db.select(
      db.invoices,
    )..where((tbl) => tbl.id.equals(intId))).getSingleOrNull();

    if (driftInvoice != null) {
      final InvoiceModel initInvoice = InvoiceModel.fromDb(driftInvoice);
      navigatorKey.currentState?.push(
        FadeThroughRoute(page: InvoiceViewScreen(initInvoice: initInvoice)),
      );
    }
  }

  static NotificationDetails buildNotificationDetails({
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

  Future<void> scheduleDaily9AMReminder() async {
    const channelId = 'daily_invoice_reminders';
    const channelName = 'Daily Due Reminders';

    await _notification
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            channelId,
            channelName,
            description: 'Daily invoice due reminders at 9 AM',
            importance: Importance.max,
          ),
        );

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      9,
      0,
      0,
    );
    if (now.isAfter(scheduledDate)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notification.cancel(id: 999);

    await _notification.zonedSchedule(
      id: 999,
      scheduledDate: scheduledDate,
      title: 'Invoices Due Today ⚠️',
      body: 'Check invoices due for payment today.',
      notificationDetails: buildNotificationDetails(
        channelId: channelId,
        channelName: channelName,
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_reminder',
    );
  }
}
