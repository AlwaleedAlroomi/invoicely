import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/utils/fade_through_route.dart';
import 'package:invoicely/data/local/isar_service.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:invoicely/features/settings/data/default_settings.dart';
import 'package:invoicely/features/settings/providers/settings_providers.dart';
import 'package:invoicely/features/settings/view/business_profile_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _SectionHeader(title: 'Business'),
          _BusinessProfileTile(),
          _SectionHeader(title: 'Preferences'),
          _DefaultTaxRateTile(),
          _DefaultCurrencyTile(),
          _SectionHeader(title: 'Appearance'),
          _ThemeModeTile(),
          _PrimaryColorTile(),
          _SectionHeader(title: 'Data'),
          _BackupRestoreTile(),
          _ClearDataTile(),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ── BUSINESS PROFILE TILE ─────────────────────
class _BusinessProfileTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.business_outlined),
      title: Text(
        'Business Profile',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text('Name, logo, tax info, address'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(
        context,
      ).push(FadeThroughRoute(page: const BusinessProfileScreen())),
    );
  }
}

// ── DEFAULT TAX RATE ──────────────────────────
class _DefaultTaxRateTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.read(sharedPreferencesProvider);
    final taxRate = DefaultSettings.getTaxRate(prefs);

    return ListTile(
      leading: const Icon(Icons.percent_outlined),
      title: Text(
        'Default Tax Rate',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Text(
        '${taxRate.toStringAsFixed(0)}%',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      onTap: () => _showTaxRateDialog(context, ref, taxRate),
    );
  }

  void _showTaxRateDialog(BuildContext context, WidgetRef ref, double current) {
    final controller = TextEditingController(text: current.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Default Tax Rate',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            suffixText: '%',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final rate = double.tryParse(controller.text) ?? 0;
              DefaultSettings.setTaxRate(
                ref.read(sharedPreferencesProvider),
                rate,
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ── DEFAULT CURRENCY ──────────────────────────
class _DefaultCurrencyTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.read(sharedPreferencesProvider);
    final currency = DefaultSettings.getCurrency(prefs);

    return ListTile(
      leading: const Icon(Icons.currency_exchange_outlined),
      title: Text(
        'Default Currency',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Text(
        currency,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      onTap: () => _showCurrencyPicker(context, ref),
    );
  }

  void _showCurrencyPicker(BuildContext context, WidgetRef ref) {
    const currencies = [
      'USD',
      'EUR',
      'GBP',
      'JPY',
      'CAD',
      'AUD',
      'CHF',
      'CNY',
      'SAR',
      'AED',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Currency',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: currencies.map((c) {
                final isSelected =
                    DefaultSettings.getCurrency(
                      ref.read(sharedPreferencesProvider),
                    ) ==
                    c;
                return ChoiceChip(
                  label: Text(c),
                  selected: isSelected,
                  onSelected: (_) {
                    DefaultSettings.setCurrency(
                      ref.read(sharedPreferencesProvider),
                      c,
                    );
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── THEME MODE ────────────────────────────────
class _ThemeModeTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);

    return ListTile(
      leading: Icon(
        themeMode == ThemeMode.dark
            ? Icons.dark_mode_outlined
            : Icons.light_mode_outlined,
      ),
      title: Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
      trailing: SegmentedButton<ThemeMode>(
        segments: [
          ButtonSegment(
            value: ThemeMode.light,
            icon: Icon(
              Icons.light_mode_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            label: Text("Light"),
          ),
          ButtonSegment(
            value: ThemeMode.system,
            icon: Icon(
              Icons.contrast_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            label: Text("System"),
          ),
          ButtonSegment(
            value: ThemeMode.dark,
            icon: Icon(
              Icons.dark_mode_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            label: Text("Dark"),
          ),
        ],
        selected: {themeMode},
        onSelectionChanged: (value) {
          ref.read(themeControllerProvider.notifier).setTheme(value.first);
        },
      ),
    );
  }
}

// ── PRIMARY COLOR ─────────────────────────────
class _PrimaryColorTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentColor = ref.watch(colorControllerProvider);

    const colors = [
      Color(0xFF4F46E5), // indigo
      Color(0xFF0EA5E9), // sky blue
      Color(0xFF10B981), // emerald
      Color(0xFFF59E0B), // amber
      Color(0xFFEF4444), // red
      Color(0xFF8B5CF6), // violet
      Color(0xFFEC4899), // pink
      Color(0xFF14B8A6), // teal
    ];

    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: const Text('Primary Color'),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Wrap(
          spacing: 8,
          children: colors.map((color) {
            final isSelected = currentColor.value == color.value;
            return GestureDetector(
              onTap: () =>
                  ref.read(colorControllerProvider.notifier).setColor(color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 3,
                        )
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── BACKUP / RESTORE (placeholder) ───────────
class _BackupRestoreTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.backup_outlined),
      title: Text(
        'Backup & Restore',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: const Text('Export or import your data'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Day 2 task
      },
    );
  }
}

// ── CLEAR DATA ────────────────────────────────
class _ClearDataTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
      title: const Text('Clear All Data', style: TextStyle(color: Colors.red)),
      subtitle: const Text('Permanently delete everything'),
      onTap: () => _showConfirmDialog(context, ref),
    );
  }

  void _showConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all invoices, clients, and products. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              // await IsarService.instance.writeTxn(() async {
              //   await IsarService.instance.clear();
              // });
              // if (context.mounted) Navigator.pop(context);
            },
            child: const Text(
              'Delete Everything',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
