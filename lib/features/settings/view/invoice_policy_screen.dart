import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:invoicely/features/settings/data/default_settings.dart';
import 'package:invoicely/features/settings/providers/settings_providers.dart';

class InvoicePolicyScreen extends ConsumerStatefulWidget {
  const InvoicePolicyScreen({super.key});

  @override
  ConsumerState<InvoicePolicyScreen> createState() => _InvoicePolicyScreenState();
}

class _InvoicePolicyScreenState extends ConsumerState<InvoicePolicyScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(sharedPreferencesProvider);
    _controller = TextEditingController(text: DefaultSettings.getPolicy(prefs));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final prefs = ref.read(sharedPreferencesProvider);
    DefaultSettings.setPolicy(prefs, _controller.text);
    ref.read(invoicePolicyProvider.notifier).state = _controller.text;
    Navigator.pop(context, _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Policy'),
        centerTitle: true,
        actions: [
          TextButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This policy text will appear at the bottom of every generated invoice PDF.',
                      style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller,
              maxLines: 8,
              decoration: InputDecoration(
                labelText: 'Invoice Policy',
                hintText: DefaultSettings.defaultPolicy,
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                alignLabelWithHint: true,
              ),
              style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14, height: 1.5),
              textInputAction: TextInputAction.newline,
            ),
          ],
        ),
      ),
    );
  }
}
