import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/utils/fade_through_route.dart';
import 'package:invoicely/core/widgets/product_scanner_screen.dart';
import 'package:invoicely/features/invoice/providers/invoice_provider.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:invoicely/features/products/view/product_form_screen.dart';

class ProductPickerSheet extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const ProductPickerSheet({super.key, required this.scrollController});

  @override
  ConsumerState<ProductPickerSheet> createState() => _ProductPickerSheetState();
}

class _ProductPickerSheetState extends ConsumerState<ProductPickerSheet> {
  String _query = '';

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
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () async {
                  await Navigator.of(
                    context,
                  ).push(FadeThroughRoute(page: ProductFormPage()));
                  ref.invalidate(allProductsProvider);
                },
                label: Text('Add Product'),
                icon: Icon(Icons.add),
              ),
              TextButton.icon(
                onPressed: () async {
                  await Navigator.of(context).push(
                    FadeThroughRoute(
                      page: ProductScannerScreen(
                        title: "Scan Products QR",
                        isMultiScan: true,
                        onScan: (sku) async {
                          await ref
                              .read(productControllerProvider.notifier)
                              .getProductBySku(sku);
                          final productState = ref.read(
                            productControllerProvider,
                          );
                          if (productState.failure != null ||
                              productState.selectedProduct == null) {
                            return ScanResultType.notFound;
                          }

                          final product = productState.selectedProduct!;
                          final invoiceNotifier = ref.read(
                            invoiceFormControllerProvider.notifier,
                          );
                          final currentItems = ref
                              .read(invoiceFormControllerProvider)
                              .items;

                          final existingIndex = currentItems.indexWhere(
                            (item) =>
                                item.productId == product.isarId.toString(),
                          );

                          if (existingIndex != -1) {
                            final existingItem = currentItems[existingIndex];
                            if (existingItem.quantity >=
                                product.stockQuantity) {
                              return ScanResultType.maxStockReached;
                            }
                            invoiceNotifier.updateItemQuantity(
                              existingIndex,
                              existingItem.quantity++,
                            );
                          } else {
                            if (product.stockQuantity <= 0) {
                              return ScanResultType.maxStockReached;
                            }
                            invoiceNotifier.addItem(product, 1);
                          }
                          return ScanResultType.found;
                        },
                      ),
                    ),
                  );
                },
                label: Text("Scan Product"),
                icon: Icon(Icons.qr_code_2),
              ),
            ],
          ),
          const SizedBox(height: 2),
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
                      trailing: SizedBox(
                        width: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            Text(
                              product.stockQuantity.toString(),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(
                        '\$${product.unitPrice.toStringAsFixed(2)}',
                      ),
                      onTap: () {
                        ref
                            .read(invoiceFormControllerProvider.notifier)
                            .addItem(product, 1);
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
