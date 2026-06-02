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
  await NotificationService().init();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await Workmanager().registerPeriodicTask(
    "invoicely_daily_check_id",
    dailyInvoiceTask,
    frequency: const Duration(hours: 24),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    constraints: Constraints(
      networkType: NetworkType.notRequired,
      requiresBatteryNotLow: true,
    ),
  );
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
    );
  }
}
