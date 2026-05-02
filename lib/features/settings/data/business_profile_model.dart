import 'package:isar/isar.dart';

part 'business_profile_model.g.dart';

@collection
class BusinessProfileModel {
  Id isarId = Isar.autoIncrement;

  late String businessName;
  String? logoPath;

  BusinessProfileModel({required this.businessName, this.logoPath});

  BusinessProfileModel copyWith({String? businessName, String? logoPath}) {
    return BusinessProfileModel(
      businessName: businessName ?? this.businessName,
      logoPath: logoPath ?? this.logoPath,
    )..isarId = isarId;
  }

  String get displayName => businessName;
  String? get logo => logoPath;
}
