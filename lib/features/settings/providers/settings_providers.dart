import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/theme/theme_controller.dart';
import 'package:invoicely/data/database/providers.dart';
import 'package:invoicely/data/repositories/business_profile_repository_impl.dart';
import 'package:invoicely/data/services/business_profile_service.dart';
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

final businessProfileServiceProvider = Provider<BusinessProfileService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BusinessProfileService(db);
});

final businessProfileRepositoryProvider = Provider<BusinessProfileRepository>((
  ref,
) {
  final service = ref.watch(businessProfileServiceProvider);
  return BusinessProfileRepositoryImpl(service);
});

final exportCsvServiceProvider = Provider<ExportService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ExportService(db);
});

final exportXlsxServiceProvider = Provider<XlsxExportService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return XlsxExportService(db);
});

final xlsxImportServiceProvider = Provider<XlsxImportService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return XlsxImportService(db);
});

final exportCsvControllerProvider =
    StateNotifierProvider<ExportCsvController, ExportState>((ref) {
      return ExportCsvController(ref.read(exportCsvServiceProvider));
    });

final exportXlsxControllerProvider =
    StateNotifierProvider<ExportXlsxController, ExportXlsxState>((ref) {
      return ExportXlsxController(ref.read(exportXlsxServiceProvider));
    });

final importControllerProvider =
    StateNotifierProvider<ImportController, ImportState>((ref) {
      final xlsxImportService = ref.read(xlsxImportServiceProvider);
      return ImportController(xlsxImportService);
    });
