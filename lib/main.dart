import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/services/background_worker.dart';
import 'package:invoicely/core/services/notification_service.dart';
import 'package:invoicely/core/theme/app_theme.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:invoicely/features/settings/providers/settings_providers.dart';
import 'package:invoicely/routing/main_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await NotificationService().init();
    await Workmanager().initialize(callbackDispatcher);

    final now = DateTime.now();
    var firstTarget = DateTime(now.year, now.month, now.day, 9, 0, 0);

    if (now.isAfter(firstTarget)) {
      firstTarget = firstTarget.add(const Duration(days: 1));
      await Workmanager().registerOneOffTask(
        dailyInvoiceTask,
        dailyInvoiceTask,
        initialDelay: firstTarget.difference(now),
        existingWorkPolicy: ExistingWorkPolicy.keep,
      );
      await Workmanager().registerOneOffTask(
        'immediate_first_run_check',
        dailyInvoiceTask,
        initialDelay: Duration.zero,
        existingWorkPolicy: ExistingWorkPolicy.replace,
        constraints: Constraints(
          networkType: NetworkType.notRequired,
          requiresBatteryNotLow: true,
        ),
      );
    } else {
      await Workmanager().registerOneOffTask(
        dailyInvoiceTask,
        dailyInvoiceTask,
        initialDelay: firstTarget.difference(now),
        existingWorkPolicy: ExistingWorkPolicy.keep,
      );
    }
  }

  final sharedPrefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final primaryColor = ref.watch(colorControllerProvider);

    return MaterialApp(
      title: 'Invoicely',
      theme: AppTheme.lightTheme(primaryColor),
      darkTheme: AppTheme.darkTheme(primaryColor),
      themeMode: themeMode,
      home: const MainShell(),
      debugShowCheckedModeBanner: false,
      navigatorKey: NotificationService().navigatorKey,
    );
  }
}
