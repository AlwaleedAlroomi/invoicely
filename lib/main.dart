import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/theme/app_theme.dart';
import 'package:invoicely/data/local/isar_service.dart';
import 'package:invoicely/features/clients/view/client_list_screen.dart';
import 'package:invoicely/features/invoice/view/invoice_list_screen.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:invoicely/features/products/view/product_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarService.initialize();
  final sharedPrefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoicely',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      home: const InvoiceListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
