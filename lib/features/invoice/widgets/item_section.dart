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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Items',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            TextButton.icon(
              onPressed: () => _showProductPicker(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.grey.shade400,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'No items yet',
                  style: TextStyle(color: Colors.grey.shade500),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
    final product = productsAsync
        .whenData(
          (products) => products.firstWhere(
            (p) => p.isarId.toString() == item.productId,
            // orElse: () => null,
          ),
        )
        .value;

    final atMaxStock =
        product != null && item.quantity >= product.stockQuantity;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${item.unitPrice.toStringAsFixed(2)} × ${item.quantity}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(width: 8),
                  if (product != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${product.stockQuantity} in stock',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Text(
              '\$${item.total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            // quantity controls
            Row(
              children: [
                InkWell(
                  onTap: () =>
                      controller.updateItemQuantity(index, item.quantity - 1),
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.remove, size: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text('${item.quantity}'),
                ),
                InkWell(
                  onTap: atMaxStock
                      ? null
                      : () => controller.updateItemQuantity(
                          index,
                          item.quantity + 1,
                        ),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.add,
                      size: 16,
                      color: atMaxStock ? Colors.transparent : null,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () => controller.removeItem(index),
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
