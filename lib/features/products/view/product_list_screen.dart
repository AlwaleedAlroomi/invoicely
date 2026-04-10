import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/extensions/sort_type_extension.dart';
import 'package:invoicely/core/theme/app_colors.dart';
import 'package:invoicely/core/utils/fade_through_route.dart';
import 'package:invoicely/core/widgets/product_qr_dialog.dart';
import 'package:invoicely/core/widgets/product_scanner_screen.dart';
import 'package:invoicely/features/products/controller/product_controller.dart';
import 'package:invoicely/features/products/data/product_model.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:invoicely/features/products/view/product_form_screen.dart';
import 'package:invoicely/features/products/view/product_view_screen.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(productControllerProvider.notifier).fetchProducts();
    });
  }

  // ✅ ADDED: Helper to get full image path
  Future<String> _getFullImagePath(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    return p.join(directory.path, filename);
  }

  Future<void> _handleScannerResult() async {
    final sku = await Navigator.of(context).push<String>(
      FadeThroughRoute(page: const ProductScannerScreen(title: "Search By QR")),
    );

    if (sku == null || !mounted) return;

    await _searchAndNavigateToProduct(sku);
  }

  Future<void> _searchAndNavigateToProduct(String sku) async {
    await ref.read(productControllerProvider.notifier).getProductBySku(sku);

    if (!mounted) return;

    final state = ref.read(productControllerProvider);

    if (state.selectedProduct != null) {
      Navigator.of(context).push(
        FadeThroughRoute(
          page: ProductViewScreen(product: state.selectedProduct!),
        ),
      );
    } else {
      _showProductNotFoundDialog(sku);
    }
  }

  void _showProductNotFoundDialog(String sku) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Product Not Found'),
        content: Text('No product found with SKU: $sku'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleManualSkuEntry();
            },
            child: const Text('Enter SKU Manually'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleManualSkuEntry() async {
    final sku = await _showManualSkuDialog(context);

    if (sku != null && sku.isNotEmpty && mounted) {
      await _searchAndNavigateToProduct(sku.toUpperCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productControllerProvider);
    final sortType = ref.watch(sortTypeProvider);
    final sortOptions = SortTypeExtension.getOptionsFor(ProductModel);

    ref.listen(productControllerProvider, (previous, next) {
      if (next.failure != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.failure!.message),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Inventory",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          elevation: 0,
          actions: [
            // 1. Refresh Button
            IconButton(
              tooltip: 'Refresh',
              onPressed: () =>
                  ref.read(productControllerProvider.notifier).fetchProducts(),
              icon: const Icon(Icons.refresh_rounded),
            ),

            // 2. Toggle Active/Deleted Products
            IconButton(
              tooltip: 'View Deleted',
              onPressed: () {
                ref
                    .read(productControllerProvider.notifier)
                    .setShowActiveOnly();
              },
              icon: const Icon(Icons.delete_sweep_outlined),
            ),

            // 3. View Mode Toggle (List/Grid)
            IconButton(
              tooltip: 'View Mode',
              onPressed: () {
                final prefs = ref.read(sharedPreferencesProvider);
                final currentViewMode = ref.read(isListViewModeProvider);
                prefs.setBool('is_list_view', !currentViewMode);
                ref.read(isListViewModeProvider.notifier).state =
                    !currentViewMode;
              },
              icon: Icon(
                ref.watch(isListViewModeProvider)
                    ? Icons.grid_view_rounded
                    : Icons.view_list_rounded,
              ),
            ),

            // 4. Sort Menu
            PopupMenuButton<SortType>(
              icon: const Icon(Icons.sort_rounded),
              tooltip: 'Sort Products',
              initialValue: sortType,
              onSelected: (type) =>
                  ref.read(sortTypeProvider.notifier).setSortType(type),
              itemBuilder: (context) => sortOptions.map((type) {
                return PopupMenuItem(
                  value: type,
                  child: Text(
                    type.label,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppColors.subtitleText
                          : AppColors.darkSubtitleText,
                    ),
                  ),
                );
              }).toList(),
            ),

            // 5. Scanner Button
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton.filled(
                tooltip: 'Scan SKU',
                onPressed: _handleScannerResult,
                icon: const Icon(Icons.qr_code_scanner_rounded),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search by name or SKU',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  ref
                      .read(productControllerProvider.notifier)
                      .searchProducts(value);
                },
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 400),
                child: _buildBody(
                  context,
                  ref,
                  state,
                  ref.read(isListViewModeProvider),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(FadeThroughRoute<void>(page: const ProductFormPage()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ProductListState state,
    bool isListView,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              "No products yet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(FadeThroughRoute(page: const ProductFormPage()));
              },
              child: const Text("Add your first product to get started"),
            ),
          ],
        ),
      );
    }

    return isListView
        ? _buildListView(state.products)
        : _buildGridView(state.products);
  }

  Widget _buildGridView(List<ProductModel> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 280,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 50).clamp(0, 300)),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: _buildProductGridCard(products[index]),
        );
      },
    );
  }

  Widget _buildListView(List<ProductModel> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 50).clamp(0, 300)),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: _buildProductListTile(products[index]),
        );
      },
    );
  }

  Widget _buildProductGridCard(ProductModel product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: product.isActive
              ? null
              : Border.all(color: Colors.red[200]!, width: 1.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _navigateToProductDetails(product),
          onLongPress: () => _showDeleteDialog(product),
          child: Column(
            children: [
              _buildProductImage(product, height: 120, isGridView: true),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 6),
                      _buildPriceText(product),
                      const SizedBox(height: 8),
                      _buildStockInfo(product),
                      const Spacer(),
                      Row(
                        children: [
                          _buildSkuChip(product),
                          const Spacer(),
                          _buildQrButton(product),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductListTile(ProductModel product) {
    const double cardRadius = 12.0;

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(cardRadius),
        onTap: () => _navigateToProductDetails(product),
        onLongPress: () => _showDeleteDialog(product),
        child: Ink(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(cardRadius),
            border: product.isActive
                ? null
                : Border.all(color: Colors.red[200]!, width: 1.5),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            leading: _buildProductImage(product, height: 50, width: 50),
            title: Text(
              product.name,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                _buildPriceText(product),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildSkuChip(product),
                    const SizedBox(width: 8),
                    _buildStockInfo(product),
                  ],
                ),
              ],
            ),
            trailing: _buildQrButton(product, size: 50),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(
    ProductModel product, {
    double? height,
    double? width,
    bool isGridView = false,
  }) {
    final hasImage = product.imagePath != null && product.imagePath!.isNotEmpty;
    final heroTag =
        product.imagePath ??
        product.remoteId ??
        product.sku ??
        'product_${product.isarId}';

    return Container(
      height: height,
      width: width ?? (isGridView ? double.infinity : null),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: isGridView
            ? const BorderRadius.vertical(top: Radius.circular(12))
            : BorderRadius.circular(8),
        border: !isGridView
            ? Border(right: BorderSide(width: 1.5, color: AppColors.primary))
            : null,
      ),
      child: ClipRRect(
        borderRadius: isGridView
            ? const BorderRadius.vertical(top: Radius.circular(12))
            : BorderRadius.circular(8),
        child: hasImage
            ? Hero(
                tag: heroTag,
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
                  future: _getFullImagePath(product.imagePath!),
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
                tag: heroTag,
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
                  size: isGridView ? 40 : 24,
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }

  Widget _buildPriceText(ProductModel product) {
    return Text(
      "\$${product.unitPrice.toStringAsFixed(2)}",
      style: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  Widget _buildStockInfo(ProductModel product) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.inventory_2_outlined,
          size: 14,
          color: AppColors.secondary,
        ),
        const SizedBox(width: 4),
        Text(
          "${product.stockQuantity}",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: product.stockQuantity < 5
                ? Colors.red
                : Theme.of(context).brightness == Brightness.light
                ? AppColors.subtitleText
                : AppColors.darkSubtitleText,
          ),
        ),
      ],
    );
  }

  Widget _buildSkuChip(ProductModel product) {
    return GestureDetector(
      onTap: () => _copySkuToClipboard(product.sku ?? ''),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          "SKU: ${product.sku ?? 'N/A'}",
          style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
        ),
      ),
    );
  }

  Widget _buildQrButton(ProductModel product, {double size = 40}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppColors.secondary.withAlpha(150),
        borderRadius: BorderRadius.circular(12),
        onTap: () => showProductQrDialog(context, product),
        child: Icon(
          Icons.qr_code_2_rounded,
          color: AppColors.primary,
          size: size,
        ),
      ),
    );
  }

  void _navigateToProductDetails(ProductModel product) {
    Navigator.of(
      context,
    ).push(FadeThroughRoute(page: ProductViewScreen(product: product)));
  }

  void _copySkuToClipboard(String sku) {
    Clipboard.setData(ClipboardData(text: sku)).then((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("SKU copied to clipboard"),
          action: SnackBarAction(
            label: 'CLOSE',
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
    });
  }

  void _showDeleteDialog(ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product?'),
        content: product.isActive
            ? Text('Are you sure you want to delete "${product.name}"?')
            : Text(
                'Are you sure you want to delete "${product.name}" permanent?\nthis is undo action and it will remove the product data from any related invoice and show as unknown',
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              product.isActive
                  ? ref
                        .read(productControllerProvider.notifier)
                        .deleteProduct(product)
                  : ref
                        .read(productControllerProvider.notifier)
                        .forceDeleteProduct(product);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

Future<String?> _showManualSkuDialog(BuildContext context) async {
  final controller = TextEditingController();

  try {
    return await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Enter SKU Manually'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "e.g. PROD-123",
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final sku = controller.text.trim();
              Navigator.pop(dialogContext, sku);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  } finally {
    controller.dispose();
  }
}
