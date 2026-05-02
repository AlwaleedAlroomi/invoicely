import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/local/isar_service.dart';
import 'package:invoicely/features/settings/data/business_profile_model.dart';
import 'package:isar/isar.dart';

class IsarBusinessProfileService {
  final Isar _isar;

  IsarBusinessProfileService([Isar? isar])
    : _isar = isar ?? IsarService.instance;

  Future<Result<BusinessProfileModel>> getBusinessProfile() async {
    try {
      final profile = await _isar.businessProfileModels.where().findFirst();
      if (profile == null) {
        return Error(AppFailure.database('No Profile yet create one'));
      }
      return Success(profile);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar error fetching profile: ${e.message}'),
      );
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
      await _isar.writeTxn(() async {
        await _isar.businessProfileModels.put(profile);
      });
      return Success(profile);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar error saving profle: ${e.message}'),
      );
    }
  }

  Future<Result<BusinessProfileModel>> updateClient(
    BusinessProfileModel profile,
  ) async {
    try {
      final updatedProfile = await _isar.writeTxn(() async {
        await _isar.businessProfileModels.put(profile);
      });
      return Success(updatedProfile);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar error updating profile: ${e.message}'),
      );
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
