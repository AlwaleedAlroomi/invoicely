import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:invoicely/core/utils/fade_through_route.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:invoicely/features/business_expenses/providers/business_expenses_provider.dart';
import 'package:invoicely/features/business_expenses/view/business_expenses_form_screen.dart';
import 'package:invoicely/features/clients/widgets/header_section.dart';

class BusinessExpensesViewScreen extends ConsumerStatefulWidget {
  final BusinessExpense initExpense;
  const BusinessExpensesViewScreen({super.key, required this.initExpense});

  @override
  ConsumerState<BusinessExpensesViewScreen> createState() =>
      _BusinessExpensesViewScreenState();
}

class _BusinessExpensesViewScreenState
    extends ConsumerState<BusinessExpensesViewScreen> {
  late BusinessExpense expense;
  final _currency = NumberFormat.currency(symbol: '\$');
  final _dateFormat = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    expense = widget.initExpense;
  }

  // ---- Category helpers (same mapping as list/form screens) ---------------

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
    final vendor = expense.vendorName;
    final notes = expense.notes;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            InfoSection(
              title: 'Expense Info',
              icon: Icons.receipt_long_outlined,
              tiles: [
                InfoTile(
                  icon: Icons.attach_money_rounded,
                  label: 'Amount',
                  value: _currency.format(expense.amount),
                ),
                InfoTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date',
                  value: _dateFormat.format(expense.date),
                ),
                InfoTile(
                  icon: Icons.category_outlined,
                  label: 'Category',
                  value: expense.category ?? "N/A",
                ),
              ],
            ),
            InfoSection(
              title: 'Vendor',
              icon: Icons.storefront_outlined,
              tiles: [
                InfoTile(
                  icon: Icons.business_outlined,
                  label: 'Vendor / Supplier',
                  value: (vendor == null || vendor.isEmpty) ? '—' : vendor,
                ),
              ],
            ),
            InfoSection(
              title: 'Status',
              icon: Icons.info_outline,
              tiles: [
                InfoTile(
                  icon: expense.isActive
                      ? Icons.check_circle_outline
                      : Icons.archive_outlined,
                  label: 'State',
                  value: expense.isActive ? 'Active' : 'Archived',
                ),
              ],
            ),
            if (notes != null && notes.isNotEmpty)
              InfoSection(
                title: 'Notes',
                icon: Icons.notes_outlined,
                tiles: [
                  InfoTile(
                    icon: Icons.sticky_note_2_outlined,
                    label: '',
                    value: notes,
                  ),
                ],
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---- Header (replaces the client-specific HeaderSection) ---------------

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final color = _categoryColor(expense.category!);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.amber.withValues(alpha: 0.15),
            child: Icon(
              _categoryIcon(expense.category!),
              color: color,
              size: 36,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            expense.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            _currency.format(expense.amount),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              Chip(
                avatar: Icon(
                  _categoryIcon(expense.category!),
                  size: 16,
                  color: Colors.amber,
                ),
                label: Text(expense.category!),
                visualDensity: VisualDensity.compact,
              ),
              if (!expense.isActive)
                Chip(
                  label: const Text(
                    'Archived',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                  side: BorderSide(color: Colors.red[200]!),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- App bar -----------------------------------------------------------

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Expense Details'),
      actions: [
        PopupMenuButton<String>(
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            if (expense.isActive)
              const PopupMenuItem(
                value: 'archive',
                child: Row(
                  children: [
                    Icon(Icons.archive_outlined),
                    SizedBox(width: 8),
                    Text('Archive'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) async {
            final controller = ref.read(businessExpenseController.notifier);
            switch (value) {
              case 'edit':
                final saved = await Navigator.of(context).push<BusinessExpense>(
                  FadeThroughRoute(
                    page: BusinessExpensesFormScreen(initialExpense: expense),
                  ),
                );
                if (mounted && saved != null) {
                  setState(() => expense = saved);
                }
                break;
              case 'archive':
                await controller.archiveExpense(expense);
                if (!context.mounted) return;
                Navigator.pop(context);
                break;
              case 'delete':
                await controller.forceDeleteExpense(expense);
                if (!context.mounted) return;
                Navigator.pop(context);
                break;
            }
          },
        ),
      ],
    );
  }
}
