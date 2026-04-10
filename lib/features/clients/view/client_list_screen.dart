import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/extensions/sort_type_extension.dart';
import 'package:invoicely/core/theme/app_colors.dart';
import 'package:invoicely/core/utils/fade_through_route.dart';
import 'package:invoicely/features/clients/controller/client_controller.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/clients/providers/client_providers.dart';
import 'package:invoicely/features/clients/view/client_form_screen.dart';
import 'package:invoicely/features/clients/view/client_view_screen.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';

class ClientListScreen extends ConsumerStatefulWidget {
  const ClientListScreen({super.key});

  @override
  ConsumerState<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends ConsumerState<ClientListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref.read(clientControllerProvider.notifier).getAllClients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clientControllerProvider);
    final sortType = ref.watch(clientSortTypeProvider);
    final sortOptions = SortTypeExtension.getOptionsFor(ClientModel);

    ref.listen(clientControllerProvider, (previous, next) {
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
            "Clients",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              tooltip: "Refresh",
              onPressed: () =>
                  ref.read(clientControllerProvider.notifier).getAllClients(),
              icon: Icon(Icons.refresh_rounded),
            ),
            IconButton(
              tooltip: 'View Deleted',
              onPressed: () {
                ref.read(clientControllerProvider.notifier).setShowActiveOnly();
              },
              icon: Icon(Icons.delete_sweep_outlined),
            ),
            // IconButton(), view mode toggle
            PopupMenuButton<SortType>(
              icon: const Icon(Icons.sort_rounded),
              tooltip: 'Sort Clients',
              initialValue: sortType,
              onSelected: (type) {
                print(type);
                ref.read(clientSortTypeProvider.notifier).setSortType(type);
              },
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
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by name/email/phone number',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  ref
                      .read(clientControllerProvider.notifier)
                      .searchClients(value);
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
            ).push(FadeThroughRoute(page: ClientFormScreen()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ClientListState state,
    bool isListView,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.clients.isEmpty) {
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
                ).push(FadeThroughRoute(page: const ClientFormScreen()));
              },
              child: const Text("Add your first product to get started"),
            ),
          ],
        ),
      );
    }
    return isListView
        ? _buildListView(state.clients)
        : _buildGridView(state.clients);
  }

  Widget _buildListView(List<ClientModel> clients) {
    return ListView.builder(
      itemCount: clients.length,
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
          child: _buildCleintListTile(clients[index]),
        );
      },
    );
  }

  Widget _buildCleintListTile(ClientModel client) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: client.isActive
              ? null
              : Border.all(color: Colors.red[200]!, width: 1.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.of(
            context,
          ).push(FadeThroughRoute(page: ClientViewScreen(client: client))),
          onLongPress: () => _showDeleteDialog(client),
          child: Column(
            children: [
              // _buildProductImage(product, height: 120, isGridView: true),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 6),
                      // _buildPriceText(product),
                      const SizedBox(height: 8),
                      // _buildStockInfo(product),
                      // const Spacer(),
                      // Row(
                      //   children: [
                      //     _buildSkuChip(product),
                      //     const Spacer(),
                      //     _buildQrButton(product),
                      //   ],
                      // ),
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

  void _showDeleteDialog(ClientModel client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product?'),
        content: client.isActive
            ? Text('Are you sure you want to delete "${client.name}"?')
            : Text(
                'Are you sure you want to delete "${client.name}" permanent?\nthis is undo action and it will remove the product data from any related invoice and show as unknown',
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // product.isActive
              //     ? ref
              //           .read(productControllerProvider.notifier)
              //           .deleteProduct(product)
              //     : ref
              //           .read(productControllerProvider.notifier)
              //           .forceDeleteProduct(product);
              // Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<ClientModel> clients) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 280,
      ),
      itemCount: clients.length,
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
          child: _buildClientGridCard(clients[index]),
        );
      },
    );
  }

  Widget _buildClientGridCard(ClientModel client) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: client.isActive
              ? null
              : Border.all(color: Colors.red[200]!, width: 1.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.of(
            context,
          ).push(FadeThroughRoute(page: ClientViewScreen(client: client))),
          onLongPress: () => _showDeleteDialog(client),
          child: Column(
            children: [
              // _buildProductImage(product, height: 120, isGridView: true),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 6),
                      // _buildPriceText(product),
                      // const SizedBox(height: 8),
                      // _buildStockInfo(product),
                      // const Spacer(),
                      // Row(
                      //   children: [
                      //     _buildSkuChip(product),
                      //     const Spacer(),
                      //     _buildQrButton(product),
                      //   ],
                      // ),
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
}
