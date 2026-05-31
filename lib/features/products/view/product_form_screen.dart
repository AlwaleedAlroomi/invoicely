import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoicely/core/theme/app_colors.dart';
import 'package:invoicely/features/products/data/product_model.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ProductFormPage extends ConsumerStatefulWidget {
  final ProductModel? initialProduct;

  const ProductFormPage({super.key, this.initialProduct});

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _stockFocusNode = FocusNode();
  File? _pickedImage;
  String? _existingImagePath;
  String? _fullDisplayPath;
  bool _imageRemoved = false;

  Future<String> _getFullImagePath(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    return p.join(directory.path, filename);
  }

  // Controllers for each field
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _skuController;
  late TextEditingController _descController;
  late TextEditingController _stockQuantityController;
  double _sliderValue = 0.0;

  static const int maxSliderValue = 100;

  @override
  void initState() {
    super.initState();
    final timestamp = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(7);

    // Initialize controllers with existing data if editing
    _nameController = TextEditingController(text: widget.initialProduct?.name);
    _priceController = TextEditingController(
      text: widget.initialProduct?.unitPrice.toString() ?? '',
    );
    _skuController = TextEditingController(
      text: widget.initialProduct?.sku ?? 'PRO-$timestamp',
    );
    _descController = TextEditingController(
      text: widget.initialProduct?.description,
    );
    int initialStock = widget.initialProduct?.stockQuantity ?? 0;
    _stockQuantityController = TextEditingController(
      text: initialStock.toString(),
    );
    _sliderValue = initialStock.clamp(0, 100).toDouble();
    _existingImagePath = widget.initialProduct?.imagePath;
    if (_existingImagePath != null) {
      _resolveExistingPath();
    }
  }

  Future<void> _resolveExistingPath() async {
    if (_existingImagePath != null) {
      final path = await _getFullImagePath(_existingImagePath!);
      setState(() {
        _fullDisplayPath = path;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _skuController.dispose();
    _descController.dispose();
    _stockQuantityController.dispose();
    _stockFocusNode.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(productControllerProvider.notifier);

    String? finalImagePath = _existingImagePath;

    if (_imageRemoved && finalImagePath != null) {
      await _deleteOldImage(finalImagePath);
      finalImagePath = null;
    }

    if (_pickedImage != null) {
      finalImagePath = await _saveImageToPermanentStorage(
        _pickedImage!.path,
        _existingImagePath,
      );
    }
    final productData = ProductModel(
      isarId: widget.initialProduct?.isarId,
      remoteId: widget.initialProduct?.remoteId,
      name: _nameController.text.trim(),
      unitPrice: double.tryParse(_priceController.text) ?? 0.0,
      imagePath: finalImagePath,
      sku: _skuController.text.trim(),
      stockQuantity: int.tryParse(_stockQuantityController.text.trim()) ?? 0,
      description: _descController.text.trim(),
      createdAt: widget.initialProduct?.createdAt ?? DateTime.now(),
      lastUpdated: DateTime.now(),
    );

    await controller.saveProduct(productData);

    if (mounted) {
      final state = ref.read(productControllerProvider);
      if (state.failure == null) {
        Navigator.of(context).pop(productData);
      }
    }
  }

  Future<void> _deleteOldImage(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final File imageFile = File(p.join(directory.path, imagePath));

      if (await imageFile.exists()) {
        await imageFile.delete();
      }
    } catch (e) {
      debugPrint('Error deleting old image: $e');
    }
  }

  void _updateStock(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null) {
      setState(() {
        _sliderValue = parsed.clamp(0, 100).toDouble();
      });
    } else {
      setState(() {
        _sliderValue = 0;
      });
    }
  }

  void _incrementStock() {
    final current = int.tryParse(_stockQuantityController.text) ?? 0;
    final newValue = current + 1;
    _stockQuantityController.text = newValue.toString();
    setState(() {
      _sliderValue = newValue.clamp(0, maxSliderValue).toDouble();
    });
  }

  void _decrementStock() {
    final current = int.tryParse(_stockQuantityController.text) ?? 0;
    if (current > 0) {
      final newValue = current - 1;
      _stockQuantityController.text = newValue.toString();
      setState(() {
        _sliderValue = newValue.clamp(0, maxSliderValue).toDouble();
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
        _imageRemoved = false;
      });
    }
  }

  Future<String> _saveImageToPermanentStorage(
    String tempPath,
    String? oldImage,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName =
          'prod_${DateTime.now().millisecondsSinceEpoch}${p.extension(tempPath)}';
      final String permanentPath = p.join(directory.path, fileName);

      await File(tempPath).copy(permanentPath);
      if (oldImage != null) {
        await _deleteOldImage(oldImage);
      }
      return fileName;
    } catch (e) {
      debugPrint('Error saving image: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productControllerProvider);
    final theme = Theme.of(context);
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialProduct == null ? 'Add Product' : 'Edit Product',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImagePicker(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            canRequestFocus: true,
                            decoration: _inputDecoration(theme, label: 'Product Name*'),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Name is required'
                                : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _priceController,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(theme, label: 'Unit Price*', prefix: '\$'),
                            keyboardType: TextInputType.number,
                            validator: (v) => (double.tryParse(v ?? '') == null)
                                ? 'Enter a valid price'
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
                ),
                child: TextFormField(
                  controller: _skuController,
                  readOnly: true,
                  canRequestFocus: false,
                  decoration: _inputDecoration(theme, label: 'SKU (Barcode)', icon: Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
                ),
                child: TextFormField(
                  controller: _descController,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _stockFocusNode.requestFocus();
                  },
                  decoration: _inputDecoration(theme, label: 'Description'),
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: 16),
              _buildStockQuantityInput(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: isKeyboardOpen ? MediaQuery.of(context).viewInsets.bottom + 8 : 16,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.3))),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: state.isLoading ? null : _saveProduct,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: state.isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(
                      widget.initialProduct == null ? 'Save Product' : 'Edit Product',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, {required String label, String? prefix, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixText: prefix,
      prefixIcon: icon != null ? Icon(icon, size: 18) : null,
      filled: true,
      fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      labelStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  Widget _buildImagePicker() {
    final hasImage = _pickedImage != null || _fullDisplayPath != null;
    final imagePath = _pickedImage?.path ?? _fullDisplayPath;
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 100,
            height: 110,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasImage ? theme.colorScheme.primary : theme.dividerColor,
                width: hasImage ? 1.5 : 1,
              ),
              image: hasImage && imagePath != null
                  ? DecorationImage(
                      image: FileImage(File(imagePath)),
                      fit: BoxFit.contain,
                    )
                  : null,
            ),
            child: !hasImage
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 28, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                      const SizedBox(height: 4),
                      Text(
                        'Image',
                        style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.3), fontSize: 12),
                      ),
                    ],
                  )
                : null,
          ),
        ),
        if (hasImage)
          Positioned(
            top: -10,
            right: -10,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _pickedImage = null;
                  _existingImagePath = null;
                  _imageRemoved = true;
                });
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStockQuantityInput() {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stock Quantity',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: theme.colorScheme.error),
                  onPressed: _decrementStock,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _stockQuantityController,
                    focusNode: _stockFocusNode,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                    ),
                    style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w600),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: _updateStock,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: theme.colorScheme.primary),
                  onPressed: _incrementStock,
                ),
              ],
            ),
          ),
          Slider(
            activeColor: theme.colorScheme.primary,
            inactiveColor: theme.colorScheme.surfaceVariant,
            overlayColor: WidgetStatePropertyAll(theme.colorScheme.primary.withValues(alpha: 0.1)),
            divisions: maxSliderValue,
            value: _sliderValue,
            min: 0,
            max: maxSliderValue.toDouble(),
            label: _sliderValue.toInt().toString(),
            onChanged: (double newValue) {
              setState(() {
                _sliderValue = newValue;
                _stockQuantityController.text = newValue.toInt().toString();
              });
            },
          ),
        ],
      ),
    );
  }
}
