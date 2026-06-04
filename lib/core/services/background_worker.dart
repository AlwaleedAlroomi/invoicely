import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/core/services/notification_service.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:path/path.dart' as p;

const String dailyInvoiceTask = "com.invoicely.dailyInvoiceCheck";
const String immediateFirstRuncInvoiceTask = 'immediate_first_run_check';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == dailyInvoiceTask ||
        taskName == immediateFirstRuncInvoiceTask) {
      AppDatabase? db;
      try {
        final notificationPlugin = FlutterLocalNotificationsPlugin();
        final notificationService = NotificationService();
        await notificationService.init();

        final dbFolder = await getApplicationDocumentsDirectory();
        final dbFile = File(p.join(dbFolder.path, 'invoicely.db'));

        final backgroundExecutor = NativeDatabase(dbFile);
        db = AppDatabase.connect(DatabaseConnection(backgroundExecutor));

        final now = DateTime.now();
        final todayStart = DateTime(now.year, now.month, now.day);
        final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

        final List<Invoice> dueInvoices =
            await (db.select(db.invoices)
                  ..where(
                    (tbl) =>
                        tbl.status.equalsValue(InvoiceStatus.sent) |
                        tbl.status.equalsValue(InvoiceStatus.overdue),
                  )
                  ..where(
                    (tbl) => tbl.dueDate.isBetweenValues(todayStart, todayEnd),
                  )
                  ..where((tbl) => tbl.isActive.equals(true)))
                .get();

        await db.close();
        db = null;

        if (dueInvoices.isEmpty) return true;

        for (var invoice in dueInvoices) {
          await notificationPlugin.show(
            id: invoice.id,
            title: "Invoice Due Today! ⚠️",
            body:
                "Invoice ${invoice.invoiceNumber} for \$${invoice.totalAmount} is pending payment.",
            notificationDetails: notificationService.buildNotificationDetails(
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
  var targetTime = DateTime(
    now.year,
    now.month,
    now.day,
    9,
    0,
    0,
  ).add(Duration(days: 1));

  final delay = targetTime.difference(now);

  await Workmanager().registerOneOffTask(
    dailyInvoiceTask,
    dailyInvoiceTask,
    initialDelay: delay,
    existingWorkPolicy: ExistingWorkPolicy.replace,
  );
}
