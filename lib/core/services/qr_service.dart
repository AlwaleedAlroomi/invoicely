import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:invoicely/features/products/data/product_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Result type for better error handling
class QrCaptureResult {
  final bool success;
  final String? errorMessage;

  const QrCaptureResult.success() : success = true, errorMessage = null;

  const QrCaptureResult.failure(this.errorMessage) : success = false;
}

// Constants
class QrConstants {
  static const double defaultQrSize = 200.0;
  static const double qrContainerPadding = 12.0;
  static const double qrContainerBorderRadius = 12.0;
  static const double imagePixelRatio = 3.0;
}

// QR Data Formatter
class QrDataFormatter {
  String formatProductData(ProductModel product) {
    return product.sku!;
  }
}

// Gallery Service
class GalleryService {
  Future<bool> ensureAccess() async {
    final hasAccess = await Gal.hasAccess();
    if (!hasAccess) {
      return await Gal.requestAccess();
    }
    return true;
  }

  Future<void> saveImage(Uint8List imageBytes, String imageName) async {
    await Gal.putImageBytes(imageBytes, name: '$imageName-Prod-QR');
  }
}

// Image Capture Service
class ImageCaptureService {
  Future<Uint8List?> captureWidget(
    GlobalKey key, {
    double pixelRatio = QrConstants.imagePixelRatio,
  }) async {
    try {
      final RenderRepaintBoundary? boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('Unable to find render object');
      }

      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('Failed to convert image to bytes');
      }

      return byteData.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing widget: $e');
      return null;
    }
  }
}

// Main QR Service
class QrService {
  final QrDataFormatter _dataFormatter;
  final GalleryService _galleryService;
  final ImageCaptureService _imageCaptureService;

  QrService({
    QrDataFormatter? dataFormatter,
    GalleryService? galleryService,
    ImageCaptureService? imageCaptureService,
  }) : _dataFormatter = dataFormatter ?? QrDataFormatter(),
       _galleryService = galleryService ?? GalleryService(),
       _imageCaptureService = imageCaptureService ?? ImageCaptureService();

  /// Builds a QR code widget for the given product
  Widget buildQrView(
    BuildContext context,
    ProductModel product, {
    double size = QrConstants.defaultQrSize,
  }) {
    return Container(
      padding: const EdgeInsets.all(QrConstants.qrContainerPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(
          QrConstants.qrContainerBorderRadius,
        ),
      ),
      child: QrImageView(
        data: _dataFormatter.formatProductData(product),
        version: QrVersions.auto,
        size: size,
        gapless: false,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Colors.black,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Colors.black,
        ),
      ),
    );
  }

  /// Captures QR code as image and saves to gallery
  Future<QrCaptureResult> captureAndSaveQr(
    GlobalKey key,
    String productName,
  ) async {
    try {
      final hasAccess = await _galleryService.ensureAccess();
      if (!hasAccess) {
        return const QrCaptureResult.failure('Gallery access denied');
      }

      final imageBytes = await _imageCaptureService.captureWidget(key);
      if (imageBytes == null) {
        return const QrCaptureResult.failure('Failed to capture QR code image');
      }

      // Save to gallery
      await _galleryService.saveImage(imageBytes, productName);
      return const QrCaptureResult.success();
    } catch (e) {
      debugPrint('Error in captureAndSaveQr: $e');
      return QrCaptureResult.failure(e.toString());
    }
  }
}
