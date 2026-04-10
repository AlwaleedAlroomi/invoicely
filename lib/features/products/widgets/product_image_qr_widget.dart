import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:invoicely/core/theme/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path/path.dart' as p;

class ProductImageWithQr extends StatefulWidget {
  final String? imagePath;
  final String qrData;
  final String heroTag;

  const ProductImageWithQr({
    super.key,
    required this.imagePath,
    required this.qrData,
    required this.heroTag,
  });

  @override
  State<ProductImageWithQr> createState() => _ProductImageWithQrState();
}

class _ProductImageWithQrState extends State<ProductImageWithQr>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _showQr = false;

  Future<String> _getFullImagePath(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    return p.join(directory.path, filename);
  }

  /// +1 → swipe right, -1 → swipe left
  int _direction = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  void _onSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    if (velocity == 0) return;

    _direction = velocity > 0 ? 1 : -1;

    if (_showQr) {
      _controller.reverse();
    } else {
      _controller.forward();
    }

    _showQr = !_showQr;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 12;

    return GestureDetector(
      onHorizontalDragEnd: _onSwipe,
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.grey.shade100,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final angle = _direction * _controller.value * pi;

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                child: angle.abs() <= pi / 2
                    ? _buildFront()
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi),
                        child: _buildBack(),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFront() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: widget.imagePath != null
          ? Hero(
              tag: widget.heroTag,
              flightShuttleBuilder:
                  (
                    flightContext,
                    animation,
                    flightDirection,
                    fromHeroContext,
                    toHeroContext,
                  ) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: toHeroContext.widget,
                        );
                      },
                    );
                  },
              child: FutureBuilder(
                future: _getFullImagePath(widget.imagePath!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image.file(
                      File(snapshot.data!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image,
                        color: AppColors.error,
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            )
          : Hero(
              tag: widget.heroTag,
              flightShuttleBuilder:
                  (
                    flightContext,
                    animation,
                    flightDirection,
                    fromHeroContext,
                    toHeroContext,
                  ) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: toHeroContext.widget,
                        );
                      },
                    );
                  },
              child: Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: Colors.grey,
              ),
            ),
    );
    // return Hero(
    //   tag: widget.heroTag,
    //   child: widget.imagePath != null
    //       ? FutureBuilder(
    //           future: _getFullImagePath(widget.imagePath!),
    //           builder: (context, snapshot) {
    //             if (snapshot.hasData) {
    //               return Image.file(
    //                 File(snapshot.data!),
    //                 fit: BoxFit.cover,
    //                 errorBuilder: (_, __, ___) =>
    //                     const Icon(Icons.broken_image, color: AppColors.error),
    //               );
    //             }
    //             return Center(child: CircularProgressIndicator());
    //           },
    //         )
    //       : const Center(
    //           child: Icon(
    //             Icons.inventory_2_outlined,
    //             size: 48,
    //             color: Colors.grey,
    //           ),
    //         ),
    // );
  }

  Widget _buildBack() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: QrImageView(
        data: widget.qrData,
        version: QrVersions.auto,
        size: 90,
      ),
    );
  }
}
