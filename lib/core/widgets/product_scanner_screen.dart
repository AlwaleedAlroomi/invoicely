import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoicely/core/services/scan_from_image.dart';
import 'package:invoicely/core/utils/fade_through_route.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:invoicely/features/products/view/product_view_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';

enum ScanResultType { found, notFound, manual }

class ScanResult {
  final ScanResultType type;
  final String? sku;
  ScanResult(this.type, {this.sku});
}

class ProductScannerScreen extends ConsumerStatefulWidget {
  final Function(String sku)? onScan;
  final String title;

  const ProductScannerScreen({
    super.key,
    this.onScan,
    this.title = "Scan Product QR",
  });

  @override
  ConsumerState<ProductScannerScreen> createState() =>
      _ProductScannerScreenState();
}

class _ProductScannerScreenState extends ConsumerState<ProductScannerScreen>
    with TickerProviderStateMixin {
  late AnimationController _zoomAnimationController;
  double _currentScale = 0.0;
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  @override
  void initState() {
    super.initState();
    _zoomAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _zoomAnimationController.addListener(() {
      controller.setZoomScale(_zoomAnimationController.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _zoomAnimationController.dispose();
    super.dispose();
  }

  Future<void> _handleGalleryScan(BuildContext context) async {
    final scanner = ScanFromImage();
    controller.stop();

    final XFile? image = await scanner.pickImage();
    if (image == null) return;

    final String? sku = await scanner.scanBarcodeFromImage(image);

    if (sku != null) {
      print('SKU found: $sku');
      if (!context.mounted) return;
      Navigator.pop(context, sku);
    } else {
      print('no barcode detected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onDoubleTap: () {
              if (_currentScale > 0.0) {
                _currentScale = 0.0;
                _zoomAnimationController.animateTo(
                  0.0,
                  curve: Curves.easeInOut,
                );
              } else {
                _currentScale = 0.5;
                _zoomAnimationController.animateTo(
                  0.5,
                  curve: Curves.easeInOut,
                );
              }
            },
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) async {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isEmpty) return;

                final String? rawValue = barcodes.first.rawValue;
                if (rawValue == null) return;

                await controller.stop();

                await HapticFeedback.mediumImpact();
                if (!context.mounted) return;
                Navigator.pop(context, rawValue);
              },
              errorBuilder: (context, error) {
                return Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.camera_enhance_outlined,
                          color: Colors.white,
                          size: 50,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Camera unavailable",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _showManualEntryDialog(context, ref),
                          icon: const Icon(Icons.keyboard),
                          label: const Text("Enter SKU Manually!!!!"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _ScannerOverlay(),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop(ScanResult(ScanResultType.manual));
            },
            icon: const Icon(Icons.keyboard),
            label: const Text("Enter SKU Manually"),
          ),
          IconButton(
            onPressed: () async {
              _handleGalleryScan(context);
            },
            icon: Icon(Icons.browse_gallery),
          ),
        ],
      ),
    );
  }

  void _showManualEntryDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController skuController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manual SKU Entry'),
        content: TextField(
          controller: skuController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Enter Product SKU',
            hintText: 'e.g. PROD-12345',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) => _processManualSku(context, ref, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () =>
                _processManualSku(context, ref, skuController.text),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _processManualSku(
    BuildContext context,
    WidgetRef ref,
    String sku,
  ) async {
    if (sku.isEmpty) return;

    // Close the dialog first
    // Navigator.pop(context);

    // Use the same logic we built for the scanner
    await ref.read(productControllerProvider.notifier).getProductBySku(sku);
    final state = ref.read(productControllerProvider);

    if (state.products.isNotEmpty) {
      if (!context.mounted) return;
      // Close scanner and go to product view
      Navigator.of(context).pushReplacement(
        FadeThroughRoute(
          page: ProductViewScreen(product: state.products.first),
        ),
      );
    } else {
      // Show error snackbar
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("SKU $sku not found")));
    }
  }
}

class _ScannerOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(decoration: ShapeDecoration(shape: _ScannerBorder())),
    );
  }
}

class _ScannerBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    const double scanSize = 260;
    final Offset center = rect.center;

    final Rect scanRect = Rect.fromCenter(
      center: center,
      width: scanSize,
      height: scanSize,
    );

    return Path()
      ..addRect(rect)
      ..addRect(scanRect)
      ..fillType = PathFillType.evenOdd;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    double scanSize = 260;
    final Offset center = rect.center;
    final Rect scanRect = Rect.fromCenter(
      center: center,
      width: scanSize,
      height: scanSize,
    );

    final Paint backgroundPaint = Paint()
      ..color = Colors.black
          .withValues(alpha: 0.5) // Change 0.5 to adjust darkness
      ..style = PaintingStyle.fill;

    // We create a path for the whole screen, then subtract the scan area
    final Path backgroundPath = Path()
      ..addRect(rect)
      ..addRect(scanRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(backgroundPath, backgroundPaint);

    // 2. Draw the Blue Border (The "Frame")
    final Paint borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRect(scanRect, borderPaint);
  }

  @override
  ShapeBorder scale(double t) => this;
}
