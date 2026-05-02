import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/local/isar_business_profile_service.dart';
import 'package:invoicely/features/settings/data/business_profile_model.dart';
import 'package:invoicely/features/settings/repository/business_profile_repository.dart';

class BusinessProfileRepositoryImpl implements BusinessProfileRepository {
  final IsarBusinessProfileService _profileService;

  const BusinessProfileRepositoryImpl(this._profileService);

  @override
  Future<Result<BusinessProfileModel>> getBusinessProfile() async {
    return await _profileService.getBusinessProfile();
  }

  @override
  Future<Result<void>> saveBusinessProfile(BusinessProfileModel profile) async {
    try {
      final result = await _profileService.createProfile(profile);
      switch (result) {
        case Success():
          return Success(null);
        case Error<void> e:
          return Error(e.failure);
      }
    } catch (e) {
      return Error(AppFailure('Unexpected error creating profile: $e'));
    }
  }

  @override
  Future<Result<BusinessProfileModel>> updateBusinessProfile(
    BusinessProfileModel businessProfile,
  ) async {
    try {
      final result = await _profileService.updateClient(businessProfile);
      switch (result) {
        case Success():
          return Success(result.data);
        case Error<void> e:
          return Error(e.failure);
      }
    } catch (e) {
      return Error(AppFailure('Unexpected error updating profile: $e'));
    }
  }
}
