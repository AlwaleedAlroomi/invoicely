import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/services/business_profile_service.dart';
import 'package:invoicely/features/settings/data/business_profile_model.dart';
import 'package:invoicely/features/settings/repository/business_profile_repository.dart';

class BusinessProfileRepositoryImpl implements BusinessProfileRepository {
  final BusinessProfileService _profileService;

  const BusinessProfileRepositoryImpl(this._profileService);

  @override
  Future<Result<BusinessProfileModel?>> getBusinessProfile() async {
    final result = await _profileService.getBusinessProfile();
    switch (result) {
      case Success():
        return Success(result.data);
      case Error<void> e:
        if (e.failure.message.contains('No Profile')) {
          return const Success(null);
        }
        return Error(e.failure);
    }
  }

  @override
  Future<Result<void>> saveBusinessProfile(BusinessProfileModel profile) async {
    try {
      final existing = await _profileService.getBusinessProfile();
      switch (existing) {
        case Success():
          await _profileService.updateProfile(profile);
          return const Success(null);
        case Error<void> e:
          if (e.failure.message.contains('No Profile')) {
            await _profileService.createProfile(profile);
            return const Success(null);
          }
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
      final result = await _profileService.updateProfile(businessProfile);
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
