import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/constants/countries.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/features/settings/data/business_profile_model.dart';
import 'package:invoicely/features/settings/providers/settings_providers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class BusinessProfileScreen extends ConsumerStatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  ConsumerState<BusinessProfileScreen> createState() =>
      _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends ConsumerState<BusinessProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _taxController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _websiteController;
  late TextEditingController _address1Controller;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  String? _logoPath;
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _taxController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _websiteController = TextEditingController();
    _address1Controller = TextEditingController();
    _cityController = TextEditingController();
    _countryController = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _taxController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _address1Controller.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final result = await ref
        .read(businessProfileRepositoryProvider)
        .getBusinessProfile();
    if (result is Success) {
      final profile = (result as Success).data;
      if (profile != null) {
        setState(() {
          _nameController.text = profile.businessName;
          _taxController.text = profile.taxNumber ?? '';
          _emailController.text = profile.email ?? '';
          _phoneController.text = profile.phone ?? '';
          _websiteController.text = profile.website ?? '';
          _address1Controller.text = profile.addressLine1 ?? '';
          _cityController.text = profile.city ?? '';
          _countryController.text = profile.country ?? '';
          _selectedCountry = profile.country;
          _logoPath = profile.logoPath;
        });
      }
    }
  }

  Future<void> _pickLogo() async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result != null) {
      // copy to app documents dir so path is permanent
      final appDir = await getApplicationDocumentsDirectory();
      final file = File(result.files.single.path!);
      final savedFile = await file.copy(
        '${appDir.path}/business_logo${p.extension(file.path)}',
      );
      setState(() => _logoPath = savedFile.path);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final profile = BusinessProfileModel(
      businessName: _nameController.text.trim(),
      logoPath: _logoPath,
      taxNumber: _taxController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      website: _websiteController.text.trim(),
      addressLine1: _address1Controller.text.trim(),
      city: _cityController.text.trim(),
      country: _selectedCountry,
    );

    await ref
        .read(businessProfileRepositoryProvider)
        .saveBusinessProfile(profile);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Profile'),
        actions: [TextButton(onPressed: _save, child: const Text('Save'))],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // logo picker
              Center(
                child: GestureDetector(
                  onTap: _pickLogo,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _logoPath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(_logoPath!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Add Logo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Business Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _taxController,
                decoration: const InputDecoration(
                  labelText: 'Tax Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: 'Website',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _address1Controller,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              // reuse your country picker
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _countryController,
                builder: (context, value, _) {
                  return GestureDetector(
                    onTap: _showCountryPicker,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _countryController,
                        decoration: InputDecoration(
                          labelText: 'Country',
                          border: const OutlineInputBorder(),
                          prefixIcon: value.text.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    getFlagEmoji(value.text),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                )
                              : const Icon(Icons.flag_outlined),
                          suffixIcon: const Icon(Icons.keyboard_arrow_down),
                        ),
                      ),
                    ),
                  );
                },
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
                            title: Text(
                              country,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
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
