import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/features/invoice/providers/invoice_provider.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';

class ProductPickerSheet extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const ProductPickerSheet({super.key, required this.scrollController});

  @override
  ConsumerState<ProductPickerSheet> createState() => _ProductPickerSheetState();
}

class _ProductPickerSheetState extends ConsumerState<ProductPickerSheet> {
  String _query = '';
  final int _selectedQty = 1;

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(allProductsProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Add Item',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (q) => setState(() => _query = q),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: productsAsync.when(
              data: (products) {
                final filtered = products
                    .where(
                      (p) =>
                          p.name.toLowerCase().contains(_query.toLowerCase()),
                    )
                    .toList();

                return ListView.builder(
                  controller: widget.scrollController,
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    return ListTile(
                      title: Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        '\$${product.unitPrice.toStringAsFixed(2)}',
                      ),
                      onTap: () {
                        ref
                            .read(invoiceFormControllerProvider.notifier)
                            .addItem(product, _selectedQty);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
