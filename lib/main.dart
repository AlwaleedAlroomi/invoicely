import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/theme/app_theme.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:invoicely/features/settings/providers/settings_providers.dart';
import 'package:invoicely/routing/main_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
