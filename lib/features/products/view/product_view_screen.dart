import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/utils/fade_through_route.dart';
import 'package:invoicely/features/invoice/providers/invoice_provider.dart';
import 'package:invoicely/features/invoice/widgets/invoice_history.dart';
import 'package:invoicely/features/products/data/product_model.dart';
import 'package:invoicely/features/products/view/product_form_screen.dart';
import 'package:invoicely/features/products/widgets/product_image_qr_widget.dart';

class ProductViewScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductViewScreen({super.key, required this.product});

  @override
  ConsumerState<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends ConsumerState<ProductViewScreen> {
  late ProductModel currentProduct;

  @override
  void initState() {
    super.initState();
    currentProduct = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        actions: [
          IconButton(
            onPressed: () async {
              final updatedProduct = await Navigator.of(context)
                  .push<ProductModel>(
                    FadeThroughRoute(
                      page: ProductFormPage(initialProduct: currentProduct),
                    ),
                  );
              if (updatedProduct != null) {
                setState(() {
                  currentProduct = updatedProduct;
                });
              }
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= HEADER =================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductImageWithQr(
                  imagePath: currentProduct.imagePath,
                  qrData: currentProduct.sku!,
                  heroTag: currentProduct.imagePath ?? currentProduct.remoteId!,
                ),

                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentProduct.name,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        "Price: \$${currentProduct.unitPrice.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Quantity: ${currentProduct.stockQuantity}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ================= DESCRIPTION =================
            if (currentProduct.description != null &&
                currentProduct.description!.isNotEmpty) ...[
              Text(
                "Description",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                currentProduct.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
            ],

            const Divider(),

            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Product created"),
              subtitle: Text(
                currentProduct.createdAt?.toString().substring(0, 10) ??
                    "Unknown",
              ),
            ),

            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Last updated"),
              subtitle: Text(
                currentProduct.lastUpdated.toString().substring(0, 10),
              ),
            ),
            // ================= HISTORY =================
            InvoiceHistorySection(
              provider: productInvoicesProvider(
                widget.product.isarId.toString(),
              ),
              title: 'Used in Invoices',
              seeAllTitle: '${widget.product.name} Invoices',
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
