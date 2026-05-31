import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/constants/countries.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/clients/providers/client_providers.dart';

class ClientFormScreen extends ConsumerStatefulWidget {
  final ClientModel? initialClient;
  const ClientFormScreen({super.key, this.initialClient});

  @override
  ConsumerState<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends ConsumerState<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  List<String> filtered = List.from(countries);
  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _websiteController;
  late TextEditingController _countryController;
  late TextEditingController _addres1Controller;
  late TextEditingController _addres2Controller;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  late TextEditingController _taxNumberController;
  late TextEditingController _currencyController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialClient?.name);
    _emailController = TextEditingController(text: widget.initialClient?.email);
    _phoneController = TextEditingController(text: widget.initialClient?.phone);
    _websiteController = TextEditingController(
      text: widget.initialClient?.email,
    );
    _countryController = TextEditingController(
      text: widget.initialClient?.country == null
          ? null
          : widget.initialClient!.country,
    );
    _addres1Controller = TextEditingController(
      text: widget.initialClient?.addressLine1,
    );
    _addres2Controller = TextEditingController(
      text: widget.initialClient?.addressLine2,
    );
    _cityController = TextEditingController(text: widget.initialClient?.city);
    _stateController = TextEditingController(text: widget.initialClient?.state);
    _zipCodeController = TextEditingController(
      text: widget.initialClient?.zipCode,
    );
    _taxNumberController = TextEditingController(
      text: widget.initialClient?.taxNumber,
    );
    _currencyController = TextEditingController(
      text: widget.initialClient?.currency,
    );
    _notesController = TextEditingController(text: widget.initialClient?.notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _addres1Controller.dispose();
    _addres2Controller.dispose();
    _zipCodeController.dispose();
    _taxNumberController.dispose();
    _currencyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveClient() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = ref.read(clientControllerProvider.notifier);
    final clientData = ClientModel(
      // remoteId: widget.initialClient?.remoteId,
      name: _nameController.text,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      website: _websiteController.text.trim(),
      country: _countryController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      addressLine1: _addres1Controller.text.trim(),
      addressLine2: _addres2Controller.text.trim(),
      zipCode: _zipCodeController.text.trim(),
      taxNumber: _taxNumberController.text.trim(),
      currency: _currencyController.text.trim(),
      notes: _notesController.text.trim(),
      createdAt: widget.initialClient?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await controller.saveClient(clientData);
    if (mounted) {
      final state = ref.read(clientControllerProvider);
      if (state.failure == null) {
        Navigator.of(context).pop(clientData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clientControllerProvider);
    final theme = Theme.of(context);
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialClient == null ? 'Add Client' : 'Edit Client',
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
              _SectionHeader(theme: theme, icon: Icons.person_outline, title: 'Basic Information'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      canRequestFocus: true,
                      decoration: _inputDecoration(theme, label: 'Name*'),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Name is required'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      canRequestFocus: true,
                      decoration: _inputDecoration(theme, label: 'Email*'),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Email is required'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _phoneController,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(theme, label: 'Phone Number'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _websiteController,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(theme, label: 'Website'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _SectionHeader(theme: theme, icon: Icons.location_on_outlined, title: 'Address'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
                ),
                child: Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _countryController,
                      builder: (context, value, _) {
                        return GestureDetector(
                          onTap: _showCountryPicker,
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _countryController,
                              decoration: InputDecoration(
                                labelText: 'Country',
                                prefixIcon: _countryController.text.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          getFlagEmoji(_countryController.text),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      )
                                    : Icon(Icons.flag_outlined, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                                suffixIcon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                                filled: true,
                                fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                labelStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                              ),
                              style: TextStyle(color: theme.colorScheme.onSurface),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _addres1Controller,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(theme, label: 'Address Line 1'),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _addres2Controller,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(theme, label: 'Address Line 2'),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(theme, label: 'City'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _stateController,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(theme, label: 'State'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _zipCodeController,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(theme, label: 'ZIP Code'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _taxNumberController,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(theme, label: 'Tax Number'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _SectionHeader(theme: theme, icon: Icons.settings_outlined, title: 'Additional'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _currencyController,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(theme, label: 'Currency'),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _notesController,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(theme, label: 'Notes'),
                      maxLines: 2,
                    ),
                  ],
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
              onPressed: state.isLoading ? null : _saveClient,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: state.isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(
                      widget.initialClient == null ? 'Save Client' : 'Edit Client',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, {required String label}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      labelStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  Future<void> _showCountryPicker() async {
    final searchController = TextEditingController();
    List<String> filtered = List.from(countries);
    final theme = Theme.of(context);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
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
                      'Select Country',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search country...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        onChanged: (query) {
                          setState(() {
                            filtered = countries
                                .where(
                                  (c) => c.toLowerCase().contains(
                                    query.toLowerCase(),
                                  ),
                                )
                                .toList();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final country = filtered[index];
                          final isSelected = country == _countryController.text;

                          return ListTile(
                            leading: Text(
                              getFlagEmoji(country),
                              style: const TextStyle(fontSize: 24),
                            ),
                            title: Text(country, style: theme.textTheme.bodyMedium),
                            trailing: isSelected
                                ? Icon(Icons.check, color: theme.colorScheme.primary)
                                : null,
                            selected: isSelected,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            onTap: () {
                              setState(() {
                                _countryController.text = country;
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
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final ThemeData theme;
  final IconData icon;
  final String title;
  const _SectionHeader({required this.theme, required this.icon, required this.title});

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
          child: Icon(icon, size: 16, color: theme.colorScheme.onPrimaryContainer),
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
