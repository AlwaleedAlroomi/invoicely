import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/theme/theme_controller.dart';
import 'package:invoicely/data/local/isar_business_profile_service.dart';
import 'package:invoicely/data/repositories/business_profile_repository_impl.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:invoicely/features/settings/controller/export_controller.dart';
import 'package:invoicely/features/settings/repository/business_profile_repository.dart';
import 'package:invoicely/features/settings/services/csv_export_service.dart';

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeMode>((ref) {
      return ThemeController(ref.read(sharedPreferencesProvider));
    });

final colorControllerProvider = StateNotifierProvider<ColorController, Color>((
  ref,
) {
  return ColorController(ref.read(sharedPreferencesProvider));
});

final isarBusinessProfileServiceProvider = Provider<IsarBusinessProfileService>(
  (ref) {
    return IsarBusinessProfileService();
  },
);

final businessProfileRepositoryProvider = Provider<BusinessProfileRepository>((
  ref,
) {
  final isarService = ref.watch(isarBusinessProfileServiceProvider);
  return BusinessProfileRepositoryImpl(isarService);
});

final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService();
});

final exportControllerProvider =
    StateNotifierProvider<ExportController, ExportState>((ref) {
      return ExportController(ref.read(exportServiceProvider));
    });
