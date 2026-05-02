import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/features/settings/data/business_profile_model.dart';

abstract class BusinessProfileRepository {
  Future<Result<BusinessProfileModel>> getBusinessProfile();
  Future<Result<void>> saveBusinessProfile(BusinessProfileModel profile);

  Future<Result<BusinessProfileModel>> updateBusinessProfile(
    BusinessProfileModel businessProfile,
  );
}
