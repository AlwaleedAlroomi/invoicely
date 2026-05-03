// lib/features/settings/data/business_profile_model.dart
import 'package:isar/isar.dart';
part 'business_profile_model.g.dart';

@collection
class BusinessProfileModel {
  Id isarId = Isar.autoIncrement;

  late String businessName;
  String? logoPath;
  String? taxNumber;
  String? email;
  String? phone;
  String? website;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? zipCode;
  String? country;

  BusinessProfileModel({
    required this.businessName,
    this.logoPath,
    this.taxNumber,
    this.email,
    this.phone,
    this.website,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.zipCode,
    this.country,
  });

  BusinessProfileModel copyWith({
    String? businessName,
    String? logoPath,
    String? taxNumber,
    String? email,
    String? phone,
    String? website,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) {
    return BusinessProfileModel(
      businessName: businessName ?? this.businessName,
      logoPath: logoPath ?? this.logoPath,
      taxNumber: taxNumber ?? this.taxNumber,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
    )..isarId = isarId;
  }

  String get displayName => businessName;
  String? get logo => logoPath;
}
