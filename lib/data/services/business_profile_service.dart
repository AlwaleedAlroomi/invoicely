import 'package:drift/drift.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:invoicely/features/settings/data/business_profile_model.dart';

class BusinessProfileService {
  final AppDatabase _db;
  BusinessProfileService(this._db);

  static BusinessProfileModel fromRow(BusinessProfile row) {
    return BusinessProfileModel(
      isarId: row.id,
      businessName: row.businessName,
      logoPath: row.logoPath,
      taxNumber: row.taxNumber,
      email: row.email,
      phone: row.phone,
      website: row.website,
      addressLine1: row.addressLine1,
      addressLine2: row.addressLine2,
      city: row.city,
      state: row.state,
      zipCode: row.zipCode,
      country: row.country,
    );
  }

  Future<Result<BusinessProfileModel>> getBusinessProfile() async {
    try {
      final row = await _db.select(_db.businessProfiles).getSingleOrNull();
      if (row == null) {
        return Error(AppFailure.database('No Profile yet create one'));
      }
      return Success(fromRow(row));
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred fetching profile: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<Result<BusinessProfileModel>> createProfile(
    BusinessProfileModel profile,
  ) async {
    try {
      final id =
          await _db.into(_db.businessProfiles).insert(BusinessProfilesCompanion(
                businessName: Value(profile.businessName),
                logoPath: Value(profile.logoPath),
                taxNumber: Value(profile.taxNumber),
                email: Value(profile.email),
                phone: Value(profile.phone),
                website: Value(profile.website),
                addressLine1: Value(profile.addressLine1),
                addressLine2: Value(profile.addressLine2),
                city: Value(profile.city),
                state: Value(profile.state),
                zipCode: Value(profile.zipCode),
                country: Value(profile.country),
              ));
      profile.isarId = id;
      return Success(profile);
    } catch (e) {
      return Error(
        AppFailure.database('An error occurred saving profile: $e'),
      );
    }
  }

  Future<Result<BusinessProfileModel>> updateProfile(
    BusinessProfileModel profile,
  ) async {
    try {
      await _db.update(_db.businessProfiles).write(BusinessProfilesCompanion(
            businessName: Value(profile.businessName),
            logoPath: Value(profile.logoPath),
            taxNumber: Value(profile.taxNumber),
            email: Value(profile.email),
            phone: Value(profile.phone),
            website: Value(profile.website),
            addressLine1: Value(profile.addressLine1),
            addressLine2: Value(profile.addressLine2),
            city: Value(profile.city),
            state: Value(profile.state),
            zipCode: Value(profile.zipCode),
            country: Value(profile.country),
          ));
      return Success(profile);
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred updating profile: $e',
          type: FailureType.database,
        ),
      );
    }
  }
}
