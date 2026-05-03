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
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(horizontal: 8),
        title: Text(
          widget.initialProduct == null ? 'Add Product' : 'Edit Product',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
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
                          decoration: InputDecoration(
                            labelText: 'Product Name*',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Name is required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _priceController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Unit Price*',
                            border: OutlineInputBorder(),
                            prefixText: '\$',
                          ),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _skuController,
                readOnly: true,
                canRequestFocus: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline, size: 20),
                  labelText: 'SKU (Barcode)',
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  _stockFocusNode.requestFocus();
                },
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              _buildStockQuantityInput(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: isKeyboardOpen
              ? MediaQuery.of(context).viewInsets.bottom + 8
              : 16,
        ),
        child: ElevatedButton(
          onPressed: state.isLoading ? null : _saveProduct,
          child: state.isLoading
              ? const CircularProgressIndicator()
              : Text(
                  widget.initialProduct == null
                      ? 'Save Product'
                      : 'Edit Product',
                  style: TextStyle(fontSize: 16),
                ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    final hasImage = _pickedImage != null || _fullDisplayPath != null;
    final imagePath = _pickedImage?.path ?? _fullDisplayPath;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 100,
            height: 110,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasImage ? AppColors.secondary : Colors.grey.shade400,
              ),
              image: hasImage && imagePath != null
                  ? DecorationImage(
                      image: FileImage(File(imagePath)),
                      fit: BoxFit.contain,
                    )
                  : null,
            ),
            child: !hasImage
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 32, color: Colors.grey),
                      SizedBox(height: 4),
                      Text(
                        'Image',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
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
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  color: AppColors.lightSurface,
                  size: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStockQuantityInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Stock Quantity"),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: AppColors.error),
                onPressed: _decrementStock, // ✅ SIMPLIFIED
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: _updateStock,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                onPressed: _incrementStock, // ✅ SIMPLIFIED
              ),
            ],
          ),
        ),
        Slider(
          activeColor: AppColors.primary,
          inactiveColor: AppColors.lightBackground,
          overlayColor: WidgetStatePropertyAll(
            AppColors.secondary.withAlpha(50),
          ),
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
    );
  }
}
