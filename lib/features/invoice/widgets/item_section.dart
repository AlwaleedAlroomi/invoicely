import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/features/invoice/data/invoice_item_model.dart';
import 'package:invoicely/features/invoice/providers/invoice_provider.dart';
import 'package:invoicely/features/invoice/widgets/product_picker_sheet.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';

class ItemsSection extends ConsumerWidget {
  const ItemsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(
      invoiceFormControllerProvider.select((s) => s.items),
    );
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () => _showProductPicker(context, ref),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Item'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                Icon(Icons.inventory_2_outlined, color: theme.colorScheme.onSurface.withValues(alpha: 0.2), size: 36),
                const SizedBox(height: 8),
                Text(
                  'No items yet',
                  style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                ),
              ],
            ),
          )
        else
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _ItemTile(item: item, index: index);
          }),
      ],
    );
  }

  void _showProductPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return ProductPickerSheet(scrollController: scrollController);
        },
      ),
    );
  }
}

class _ItemTile extends ConsumerWidget {
  final InvoiceItemModel item;
  final int index;
  const _ItemTile({required this.item, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(invoiceFormControllerProvider.notifier);
    final productsAsync = ref.watch(allProductsProvider);
    final theme = Theme.of(context);

    final product = productsAsync
        .whenData(
          (products) => products.firstWhere(
            (p) => p.isarId.toString() == item.productId,
          ),
        )
        .value;

    final atMaxStock =
        product != null && item.quantity >= product.stockQuantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TextStyle(fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${item.unitPrice.toStringAsFixed(2)} × ${item.quantity}',
                  style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.4), fontSize: 12),
                ),
                if (product != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                      const SizedBox(width: 2),
                      Text(
                        '${product.stockQuantity} in stock',
                        style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Text(
            '\$${item.total.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => controller.updateItemQuantity(index, item.quantity - 1),
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.remove, size: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('${item.quantity}', style: TextStyle(color: theme.colorScheme.onSurface)),
                ),
                InkWell(
                  onTap: atMaxStock
                      ? null
                      : () => controller.updateItemQuantity(index, item.quantity + 1),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(Icons.add, size: 16, color: atMaxStock ? Colors.transparent : null),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () => controller.removeItem(index),
            icon: const Icon(Icons.delete_outline, size: 20),
            color: theme.colorScheme.error,
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
