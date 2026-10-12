import 'package:flutter/material.dart';
import 'package:invoicely/core/services/qr_service.dart';
import 'package:invoicely/core/theme/app_colors.dart';
import 'package:invoicely/features/products/data/product_model.dart';

void showProductQrDialog(BuildContext context, ProductModel product) {
  final GlobalKey qrKey = GlobalKey();
  final QrService qrService = QrService();
  showDialog(
    context: context,
    builder: (context) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Product QR",
          textAlign: TextAlign.center,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        // title: Column(
        //   children: [
        //     Text(
        //       product.name,
        //       textAlign: TextAlign.center,
        //       style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        //     ),
        //     Text(
        //       "SKU: ${product.sku}",
        //       style: const TextStyle(fontSize: 12, color: Colors.grey),
        //     ),
        //   ],
        // ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key: qrKey,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .black, // Dark text ensures visibility on white background
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "SKU: ${product.sku ?? 'N/A'}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: qrService.buildQrView(context, product),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Scan to view product details",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final qrSaved = await qrService.captureAndSaveQr(
                qrKey,
                product.name,
              );

              if (!context.mounted) return;
              if (qrSaved.success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("QR Image saved successfully!"),
                    backgroundColor: AppColors.success,
                  ),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(qrSaved.errorMessage ?? "Unkown Error"),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: Text("Export Image"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),

          // Pro tip: You could add a 'Share' or 'Print' button here later
        ],
      );
    },
  );
}
