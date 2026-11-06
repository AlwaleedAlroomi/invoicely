import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:invoicely/features/business_expenses/providers/business_expenses_provider.dart';
import 'package:uuid/uuid.dart';

class _ExpenseCategory {
  final String name;
  final IconData icon;
  final Color color;
  const _ExpenseCategory(this.name, this.icon, this.color);
}

const List<_ExpenseCategory> _categories = [
  _ExpenseCategory('Travel', Icons.flight_takeoff_rounded, Colors.blue),
  _ExpenseCategory('Meals', Icons.restaurant_rounded, Colors.orange),
  _ExpenseCategory('Office', Icons.business_center_outlined, Colors.teal),
  _ExpenseCategory('Software', Icons.laptop_mac_rounded, Colors.indigo),
  _ExpenseCategory('Marketing', Icons.campaign_outlined, Colors.pink),
  _ExpenseCategory('Utilities', Icons.bolt_rounded, Color(0xFFFF8F00)),
  _ExpenseCategory('Rent', Icons.home_work_outlined, Colors.brown),
  _ExpenseCategory('Salary', Icons.groups_outlined, Colors.green),
  _ExpenseCategory('Other', Icons.receipt_long_outlined, Colors.blueGrey),
];

class BusinessExpensesFormScreen extends ConsumerStatefulWidget {
  final BusinessExpense? initialExpense;
  const BusinessExpensesFormScreen({super.key, this.initialExpense});

  @override
  ConsumerState<BusinessExpensesFormScreen> createState() =>
      _BusinessExpensesFormScreenState();
}

class _BusinessExpensesFormScreenState
    extends ConsumerState<BusinessExpensesFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('dd MMM yyyy');

  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late TextEditingController _categoryController;
  late TextEditingController _vendorController;
  late TextEditingController _notesController;

  late DateTime _selectedDate;

  bool get _isEditing => widget.initialExpense != null;

  @override
  void initState() {
    super.initState();
    final e = widget.initialExpense;
    _selectedDate = e?.date ?? DateTime.now();

    _titleController = TextEditingController(text: e?.title);
    _amountController = TextEditingController(text: e?.amount.toString());
    _dateController = TextEditingController(
      text: _dateFormat.format(_selectedDate),
    );
    _categoryController = TextEditingController(text: e?.category);
    _vendorController = TextEditingController(text: e?.vendorName);
    // NOTE: assumes a nullable `notes` column. Remove if you don't have it.
    _notesController = TextEditingController(text: e?.notes);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _categoryController.dispose();
    _vendorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ---- Save --------------------------------------------------------------

  void _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = ref.read(businessExpenseController.notifier);

    // NOTE: adjust to match your Drift table / controller API.
    final expenseData = BusinessExpense(
      id: _isEditing ? widget.initialExpense!.id : 0,
      remoteId: _isEditing ? (widget.initialExpense!.remoteId) : Uuid().v4(),
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      isActive: true,
      date: _selectedDate,
      category: _categoryController.text.trim(),
      vendorName: _vendorController.text.trim(),
      notes: _notesController.text.trim(),
      createdAt: DateTime.now(),
      lastUpdated: _isEditing ? DateTime.now() : null,
    );
    await controller.saveExpense(expenseData);

    if (mounted) {
      final state = ref.read(businessExpenseController);
      if (state.failure == null) {
        Navigator.of(context).pop(expenseData);
      }
    }
  }

  // ---- Build -------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(businessExpenseController);
    final theme = Theme.of(context);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Expense' : 'Add Expense'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(
                theme: theme,
                icon: Icons.receipt_long_outlined,
                title: 'Expense Details',
              ),
              const SizedBox(height: 10),
              _SectionCard(
                theme: theme,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: _inputDecoration(theme, label: 'Title*'),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Title is required'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _amountController,
                      textInputAction: TextInputAction.next,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      decoration: _inputDecoration(
                        theme,
                        label: 'Amount*',
                        prefixText: '\$ ',
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Amount is required';
                        }
                        final parsed = double.tryParse(v.trim());
                        if (parsed == null || parsed <= 0) {
                          return 'Enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    // Date picker (tap to open)
                    GestureDetector(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _dateController,
                          decoration: _inputDecoration(
                            theme,
                            label: 'Date*',
                            prefixIcon: Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _SectionHeader(
                theme: theme,
                icon: Icons.category_outlined,
                title: 'Category & Vendor',
              ),
              const SizedBox(height: 10),
              _SectionCard(
                theme: theme,
                child: Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _categoryController,
                      builder: (context, value, _) {
                        final selected = _findCategory(
                          _categoryController.text,
                        );
                        return GestureDetector(
                          onTap: _showCategoryPicker,
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _categoryController,
                              decoration: _inputDecoration(
                                theme,
                                label: 'Category*',
                                prefixIcon: Icon(
                                  selected?.icon ?? Icons.category_outlined,
                                  color:
                                      selected?.color ??
                                      theme.colorScheme.onSurface.withValues(
                                        alpha: 0.5,
                                      ),
                                ),
                                suffixIcon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Category is required'
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _vendorController,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: _inputDecoration(
                        theme,
                        label: 'Vendor / Supplier',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _SectionHeader(
                theme: theme,
                icon: Icons.settings_outlined,
                title: 'Additional',
              ),
              const SizedBox(height: 10),
              _SectionCard(
                theme: theme,
                child: TextFormField(
                  controller: _notesController,
                  textInputAction: TextInputAction.newline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _inputDecoration(theme, label: 'Notes'),
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: isKeyboardOpen
              ? MediaQuery.of(context).viewInsets.bottom + 8
              : 16,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.3)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: state.isLoading ? null : _saveExpense,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _isEditing ? 'Update Expense' : 'Save Expense',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // ---- Helpers -----------------------------------------------------------

  _ExpenseCategory? _findCategory(String name) {
    for (final c in _categories) {
      if (c.name.toLowerCase() == name.toLowerCase()) return c;
    }
    return null;
  }

  InputDecoration _inputDecoration(
    ThemeData theme, {
    required String label,
    String? prefixText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixText: prefixText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.3,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      labelStyle: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _dateFormat.format(picked);
      });
    }
  }

  Future<void> _showCategoryPicker() async {
    final theme = Theme.of(context);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected =
                          category.name.toLowerCase() ==
                          _categoryController.text.toLowerCase();

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: category.color.withValues(
                            alpha: 0.15,
                          ),
                          child: Icon(category.icon, color: category.color),
                        ),
                        title: Text(
                          category.name,
                          style: theme.textTheme.bodyMedium,
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check,
                                color: theme.colorScheme.primary,
                              )
                            : null,
                        selected: isSelected,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onTap: () {
                          setState(() {
                            _categoryController.text = category.name;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final ThemeData theme;
  final Widget child;
  const _SectionCard({required this.theme, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final ThemeData theme;
  final IconData icon;
  final String title;
  const _SectionHeader({
    required this.theme,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
