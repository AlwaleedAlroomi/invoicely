import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/theme/theme_controller.dart';
import 'package:invoicely/data/local/isar_business_profile_service.dart';
import 'package:invoicely/data/repositories/business_profile_repository_impl.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:invoicely/features/settings/controller/export_csv_controller.dart';
import 'package:invoicely/features/settings/controller/export_xlsx_controller.dart';
import 'package:invoicely/features/settings/controller/import_controller.dart';
import 'package:invoicely/features/settings/repository/business_profile_repository.dart';
import 'package:invoicely/features/settings/services/csv_export_service.dart';
import 'package:invoicely/features/settings/services/import_service.dart';
import 'package:invoicely/features/settings/services/xlsx_export_service.dart';

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

final exportCsvServiceProvider = Provider<ExportService>((ref) {
  return ExportService();
});

final exportCsvControllerProvider =
    StateNotifierProvider<ExportCsvController, ExportState>((ref) {
      return ExportCsvController(ref.read(exportCsvServiceProvider));
    });

final exportXlsxServiceProvider = Provider<XlsxExportService>((ref) {
  return XlsxExportService();
});

final exportXlsxControllerProvider =
    StateNotifierProvider<ExportXlsxController, ExportXlsxState>((ref) {
      return ExportXlsxController(ref.read(exportXlsxServiceProvider));
    });

final xlsxImportServiceProvider = Provider<XlsxImportService>((ref) {
  return XlsxImportService();
});

final importControllerProvider =
    StateNotifierProvider<ImportController, ImportState>((ref) {
      final xlsxImportService = ref.read(xlsxImportServiceProvider);
      return ImportController(xlsxImportService);
    });
