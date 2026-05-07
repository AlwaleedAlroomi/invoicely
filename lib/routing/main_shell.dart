import 'package:flutter/material.dart';
import 'package:invoicely/features/clients/view/client_list_screen.dart';
import 'package:invoicely/features/dashboard/view/dashboard_screen.dart';
import 'package:invoicely/features/invoice/view/invoice_list_screen.dart';
import 'package:invoicely/features/products/view/product_list_screen.dart';
import 'package:invoicely/features/settings/view/settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final _screens = const [
    DashboardScreen(),
    InvoiceListScreen(),
    ClientListScreen(),
    ProductListScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          setState(() => _selectedIndex = 0);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
            NavigationDestination(icon: Icon(Icons.receipt_rounded), label: 'Invoices'),
            NavigationDestination(icon: Icon(Icons.people_rounded), label: 'Clients'),
            NavigationDestination(icon: Icon(Icons.inventory_2_rounded), label: 'Products'),
            NavigationDestination(icon: Icon(Icons.settings_rounded), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}
