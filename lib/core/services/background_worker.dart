import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/core/services/notification_service.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:path/path.dart' as p;

const String dailyInvoiceTask = "com.example.invoicely.dailyInvoiceCheck";
const String immediateFirstRuncInvoiceTask =
    'com.example.invoicely.immediate_first_run_check';

const String _firstRunDoneKey = 'immediate_invoice_check_done';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == dailyInvoiceTask ||
        taskName == immediateFirstRuncInvoiceTask) {
      if (taskName == immediateFirstRuncInvoiceTask) {
        final prefs = await SharedPreferences.getInstance();
        if (prefs.getBool(_firstRunDoneKey) == true) {
          debugPrint('Immediate first-run task already executed, skipping.');
          return true;
        }
        await prefs.setBool(_firstRunDoneKey, true);
      }

      AppDatabase? db;
      debugPrint('Workmanager executing background task: $taskName');
      try {
        final dbFolder = await getApplicationDocumentsDirectory();
        final dbFile = File(p.join(dbFolder.path, 'invoicely.db'));
        final backgroundExecutor = NativeDatabase(dbFile);
        db = AppDatabase.connect(DatabaseConnection(backgroundExecutor));

        final now = DateTime.now();
        final todayStart = DateTime(now.year, now.month, now.day);
        final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
        debugPrint('Checking invoices due between $todayStart and $todayEnd');
        final List<Invoice> dueInvoices =
            await (db.select(db.invoices)
                  ..where(
                    (tbl) =>
                        tbl.status.equalsValue(InvoiceStatus.sent) |
                        tbl.status.equalsValue(InvoiceStatus.overdue) |
                        tbl.status.equalsValue(InvoiceStatus.today),
                  )
                  ..where(
                    (tbl) => tbl.dueDate.isBetweenValues(todayStart, todayEnd),
                  )
                  ..where((tbl) => tbl.isActive.equals(true)))
                .get();

        await db.close();
        db = null;

        debugPrint('Found ${dueInvoices.length} invoices due today.');

        if (dueInvoices.isEmpty) {
          debugPrint('No invoices due today. Self-rescheduling...');
          await rescheduleNextDailyCheck();
          return true;
        }

        final notificationPlugin = FlutterLocalNotificationsPlugin();
        await notificationPlugin.initialize(
          settings: InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          ),
        );

        for (var invoice in dueInvoices) {
          await notificationPlugin.show(
            id: invoice.id,
            title: "Invoice Due Today! ⚠️",
            body:
                "Invoice ${invoice.invoiceNumber} for \$${invoice.totalAmount} is pending payment.",
            notificationDetails: NotificationService.buildNotificationDetails(
              channelId: 'daily_invoice_reminders',
              channelName: 'Daily Due Reminders',
              importance: Importance.max,
              priority: Priority.high,
            ),
            payload: invoice.id.toString(),
          );
        }

        await rescheduleNextDailyCheck();
      } catch (e) {
        debugPrint('Background Worker Error: $e');
        await rescheduleNextDailyCheck();
        return false;
      } finally {
        if (db != null) {
          await db.close();
        }
      }
    }
    return true;
  });
}

Future<void> rescheduleNextDailyCheck() async {
  final now = DateTime.now();
  var targetTime = DateTime(now.year, now.month, now.day, 9, 0, 0);
  if (now.isAfter(targetTime)) {
    targetTime = targetTime.add(const Duration(days: 1));
  }

  final delay = targetTime.difference(now);

  await Workmanager().registerOneOffTask(
    dailyInvoiceTask,
    dailyInvoiceTask,
    initialDelay: delay,
    existingWorkPolicy: ExistingWorkPolicy.replace,
    constraints: Constraints(
      networkType: NetworkType.notRequired,
      requiresBatteryNotLow: false,
    ),
  );
}
