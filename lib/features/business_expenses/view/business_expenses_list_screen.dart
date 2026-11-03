import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/extensions/sort_type_extension.dart';
import 'package:invoicely/core/theme/app_colors.dart';
import 'package:invoicely/core/utils/fade_through_route.dart';
import 'package:invoicely/core/widgets/slidable_action.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:invoicely/features/business_expenses/controller/business_expenses_controller.dart';
import 'package:invoicely/features/business_expenses/providers/business_expenses_provider.dart';
import 'package:invoicely/features/business_expenses/view/business_expenses_form_screen.dart';
import 'package:invoicely/features/business_expenses/view/business_expenses_view_screen.dart';

class BusinessExpensesListScreen extends ConsumerStatefulWidget {
  const BusinessExpensesListScreen({super.key});

  @override
  ConsumerState<BusinessExpensesListScreen> createState() =>
      _BusinessExpensesListScreen();
}

class _BusinessExpensesListScreen
    extends ConsumerState<BusinessExpensesListScreen> {
  final _currency = NumberFormat.currency(symbol: '\$');
  final _dateFormat = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(businessExpenseController.notifier).fetchExpenses();
    });
  }

  // ---- Category helpers -------------------------------------------------

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'travel':
        return Icons.flight_takeoff_rounded;
      case 'food':
      case 'meals':
        return Icons.restaurant_rounded;
      case 'office':
      case 'supplies':
        return Icons.business_center_outlined;
      case 'software':
        return Icons.laptop_mac_rounded;
      case 'marketing':
        return Icons.campaign_outlined;
      case 'utilities':
        return Icons.bolt_rounded;
      case 'rent':
        return Icons.home_work_outlined;
      case 'salary':
        return Icons.groups_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'travel':
        return Colors.blue;
      case 'food':
      case 'meals':
        return Colors.orange;
      case 'office':
      case 'supplies':
        return Colors.teal;
      case 'software':
        return Colors.indigo;
      case 'marketing':
        return Colors.pink;
      case 'utilities':
        return Colors.amber[800]!;
      case 'rent':
        return Colors.brown;
      case 'salary':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  // ---- Build ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(businessExpenseController);
    final sortType = ref.watch(sortTypeProvider);
    final isListView = ref.watch(isListViewModeProvider);
    final sortOptions = SortTypeExtension.getOptionsFor(BusinessExpenses);

    ref.listen(businessExpenseController, (previous, next) {
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
            "Expenses",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              tooltip: "Refresh",
              onPressed: () =>
                  ref.read(businessExpenseController.notifier).fetchExpenses(),
              icon: const Icon(Icons.refresh_rounded),
            ),
            IconButton(
              tooltip: 'View Deleted',
              onPressed: () {
                ref
                    .read(businessExpenseController.notifier)
                    .setShowActiveOnly();
              },
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
            IconButton(
              tooltip: 'View Mode',
              onPressed: () {
                final prefs = ref.read(sharedPreferencesProvider);
                prefs.setBool('is_expense_list_view', !isListView);
                ref.read(isListViewModeProvider.notifier).state = !isListView;
              },
              icon: Icon(
                isListView ? Icons.grid_view_rounded : Icons.view_list_rounded,
              ),
            ),
            PopupMenuButton<SortType>(
              icon: const Icon(Icons.sort_rounded),
              tooltip: 'Sort Expenses',
              initialValue: sortType,
              onSelected: (type) {
                ref.read(sortTypeProvider.notifier).setSortType(type);
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
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search by title/vendor/category',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  ref
                      .read(businessExpenseController.notifier)
                      .searchExpenses(value);
                },
              ),
            ),
            if (!state.isLoading && state.businessExpenses.isNotEmpty)
              _buildSummaryBanner(state.businessExpenses),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _buildBody(context, state, isListView),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'expense_form_fab',
          onPressed: () {
            Navigator.of(
              context,
            ).push(FadeThroughRoute(page: const BusinessExpensesFormScreen()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildSummaryBanner(List<BusinessExpense> expenses) {
    final total = expenses
        .where((e) => e.isActive)
        .fold<double>(0, (sum, e) => sum + e.amount);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.account_balance_wallet_outlined, color: scheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total expenses',
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    _currency.format(total),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${expenses.length} item${expenses.length == 1 ? '' : 's'}',
              style: TextStyle(
                fontSize: 12,
                color: scheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    BusinessExpensesListState state,
    bool isListView,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.businessExpenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              "No expenses yet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  FadeThroughRoute(page: const BusinessExpensesFormScreen()),
                );
              },
              child: const Text("Add your first expense to get started"),
            ),
          ],
        ),
      );
    }
    return isListView
        ? _buildListView(state.businessExpenses)
        : _buildGridView(state.businessExpenses);
  }

  // ---- Shared animation wrapper -----------------------------------------

  Widget _animatedItem(int index, Widget child) {
    return TweenAnimationBuilder<double>(
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
      child: child,
    );
  }

  // ---- List view ---------------------------------------------------------

  Widget _buildListView(List<BusinessExpense> expenses) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) =>
          _animatedItem(index, _buildExpenseListTile(expenses[index])),
    );
  }

  void _openExpense(BusinessExpense expense) {
    Navigator.of(context).push(
      FadeThroughRoute(
        page: BusinessExpensesViewScreen(
          // initExpense: expense
        ),
      ),
    );
  }

  void _editExpense(BusinessExpense expense) {
    Navigator.of(context).push(
      FadeThroughRoute(
        page: BusinessExpensesFormScreen(
          //initialExpense: expense
        ),
      ),
    );
  }

  Widget _buildExpenseListTile(BusinessExpense expense) {
    // final color = _categoryColor(expense.category);

    return Slidable(
      key: ValueKey(expense.remoteId),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          buildCircularAction(
            context: context,
            onTap: () => _editExpense(expense),
            icon: Icons.edit_outlined,
            label: 'Edit',
            color: Colors.blue,
          ),
          buildCircularAction(
            context: context,
            onTap: () => _showDeleteDialog(expense),
            icon: Icons.delete_outline,
            label: 'Delete',
            color: Colors.red,
          ),
        ],
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: expense.isActive
                ? null
                : Border.all(color: Colors.red[200]!, width: 1.5),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _openExpense(expense),
            onLongPress: () => _showDeleteDialog(expense),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Colors.amber, //color.withValues(alpha: 0.15),
                  child: Icon(
                    Icons.home, //_categoryIcon(expense.category)
                    color: Colors.amber,
                  ),
                ),
                title: Text(
                  expense.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      [expense.category, expense.vendorName]
                          .whereType<String>()
                          .where((s) => s.isNotEmpty)
                          .join(' • '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _dateFormat.format(expense.date),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _currency.format(expense.amount),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // if (expense.paymentMethod != null)
                    //   Text(
                    //     expense.paymentMethod!,
                    //     style: const TextStyle(
                    //       fontSize: 11,
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    if (!expense.isActive)
                      const Text(
                        'Archived',
                        style: TextStyle(fontSize: 10, color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---- Delete dialog -----------------------------------------------------

  void _showDeleteDialog(BusinessExpense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Expense?',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        content: expense.isActive
            ? Text('Are you sure you want to delete "${expense.title}"?')
            : Text(
                'Are you sure you want to permanently delete "${expense.title}"?\nThis action cannot be undone.',
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final controller = ref.read(businessExpenseController.notifier);
              expense.isActive
                  ? controller.archiveExpense(expense)
                  : controller.forceDeleteExpense(expense);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ---- Grid view ---------------------------------------------------------

  Widget _buildGridView(List<BusinessExpense> expenses) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 200,
      ),
      itemCount: expenses.length,
      itemBuilder: (context, index) =>
          _animatedItem(index, _buildExpenseGridCard(expenses[index])),
    );
  }

  Widget _buildExpenseGridCard(BusinessExpense expense) {
    // final color = _categoryColor(expense.category);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: expense.isActive
              ? null
              : Border.all(color: Colors.red[200]!, width: 1.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openExpense(expense),
          onLongPress: () => _showDeleteDialog(expense),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      Colors.amber, //color.withValues(alpha: 0.15),
                  child: Icon(
                    Icons.home, //_categoryIcon(expense.category),
                    color: Colors.amber,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  expense.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _currency.format(expense.amount),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Text(
                //   expense.category,
                //   style: const TextStyle(fontSize: 12, color: Colors.grey),
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                // ),
                Text(
                  _dateFormat.format(expense.date),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!expense.isActive)
                  const Text(
                    'Archived',
                    style: TextStyle(fontSize: 10, color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
