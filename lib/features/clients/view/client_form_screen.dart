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
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(horizontal: 8),
        title: Text(
          widget.initialClient == null ? 'Add Client' : 'Edit Client',
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // name
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          canRequestFocus: true,
                          decoration: InputDecoration(
                            labelText: 'Name*',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Name is required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        // email
                        TextFormField(
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          canRequestFocus: true,
                          decoration: InputDecoration(
                            labelText: 'Email*',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Email is required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        // phone
                        TextFormField(
                          controller: _phoneController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
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
                                    prefixIcon:
                                        _countryController.text.isNotEmpty
                                        ? Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Text(
                                              getFlagEmoji(
                                                _countryController.text,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          )
                                        : Icon(Icons.flag_outlined),
                                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _stateController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'State',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _cityController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),

              // website
              TextFormField(
                controller: _websiteController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Website',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // addresline 1
              TextFormField(
                controller: _addres1Controller,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Address 1',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // addresline 2
              TextFormField(
                controller: _addres2Controller,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Address 2',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // zipcode
              TextFormField(
                controller: _zipCodeController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'ZIP Code',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // tax number
              TextFormField(
                controller: _taxNumberController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Tax Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // currency
              TextFormField(
                controller: _currencyController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Currency',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // notes
              TextFormField(
                controller: _notesController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : _saveClient,
                  child: state.isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          widget.initialClient == null
                              ? 'Save Client'
                              : 'Edit Client',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCountryPicker() async {
    final searchController = TextEditingController();
    List<String> filtered = List.from(countries);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                      margin: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const Text(
                      'Select Country',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
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

                    // list
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
                            title: Text(country),
                            trailing: isSelected
                                ? const Icon(Icons.check, color: Colors.blue)
                                : null,
                            selected: isSelected,
                            onTap: () {
                              setState(() {
                                _countryController.text = country;
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
