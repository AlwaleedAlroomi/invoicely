import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/services/background_worker.dart';
import 'package:invoicely/core/services/notification_service.dart';
import 'package:invoicely/core/theme/app_theme.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:invoicely/features/settings/providers/settings_providers.dart';
import 'package:invoicely/routing/main_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const String _firstRunDoneKey = 'immediate_invoice_check_done';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefs = await SharedPreferences.getInstance();

  if (Platform.isAndroid) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));
    final db = AppDatabase();
    await NotificationService.instance.init(db);
    await NotificationService.instance.scheduleDaily9AMReminder();
    await Workmanager().initialize(callbackDispatcher);

    final now = DateTime.now();
    var firstTarget = DateTime(now.year, now.month, now.day, 9, 0, 0);

    if (now.isAfter(firstTarget)) {
      firstTarget = firstTarget.add(const Duration(days: 1));
    }
    await Workmanager().registerOneOffTask(
      dailyInvoiceTask,
      dailyInvoiceTask,
      initialDelay: firstTarget.difference(now),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: false,
      ),
    );
    final alreadyRan = sharedPrefs.getBool(_firstRunDoneKey) ?? false;
    if (!alreadyRan) {
      await Workmanager().registerOneOffTask(
        immediateFirstRuncInvoiceTask,
        immediateFirstRuncInvoiceTask,
        initialDelay: Duration.zero,
        existingWorkPolicy: ExistingWorkPolicy.replace,
        constraints: Constraints(
          networkType: NetworkType.notRequired,
          requiresBatteryNotLow: false,
        ),
      );
    }
  }

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Drain any cold-start notification payload once the widget tree is live
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.instance.drainPendingPayload();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeControllerProvider);
    final primaryColor = ref.watch(colorControllerProvider);
    return MaterialApp(
      title: 'Invoicely',
      theme: AppTheme.lightTheme(primaryColor),
      darkTheme: AppTheme.darkTheme(primaryColor),
      themeMode: themeMode,
      home: const MainShell(),
      debugShowCheckedModeBanner: false,
      navigatorKey: NotificationService.instance.navigatorKey,
    );
  }
}
