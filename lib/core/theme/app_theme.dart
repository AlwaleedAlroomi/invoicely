import 'package:flutter/material.dart';
import 'package:invoicely/core/theme/app_colors.dart';
import 'package:invoicely/core/theme/app_text_styles.dart';

class AppTheme {
  // ===================================================================
  // ☀️ LIGHT MODE THEME
  // ===================================================================

  static ThemeData lightTheme(Color primaryColor) {
    final ColorScheme lightColorScheme =
        ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ).copyWith(
          onPrimary: AppColors.lightSurface,
          secondary: AppColors.secondary,
          onSecondary: AppColors.lightSurface,
          surface: AppColors.lightSurface,
          onSurface: AppColors.titleText,
          error: AppColors.error,
          onError: AppColors.lightSurface,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      dividerColor: AppColors.divider,

      // ── TYPOGRAPHY ──────────────────────────────
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.h1.copyWith(color: AppColors.titleText),
        headlineMedium: AppTextStyles.h2.copyWith(color: AppColors.titleText),
        bodyLarge: AppTextStyles.body1.copyWith(color: AppColors.titleText),
        bodyMedium: AppTextStyles.body2.copyWith(color: AppColors.subtitleText),
        bodySmall: AppTextStyles.caption.copyWith(
          color: AppColors.subtitleText,
        ),
        titleLarge: AppTextStyles.h2.copyWith(color: AppColors.titleText),
        titleMedium: AppTextStyles.body1.copyWith(color: AppColors.titleText),
      ),

      // ── APP BAR ─────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.titleText,
        surfaceTintColor: AppColors.lightSurface,
        elevation: 0.1,
        titleTextStyle: AppTextStyles.h2,
        centerTitle: true,
        shadowColor: AppColors.secondary,
      ),

      // ── ELEVATED BUTTON ─────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
          textStyle: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),

      // ── TEXT BUTTON ─────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightColorScheme.primary,
          textStyle: AppTextStyles.body1,
        ),
      ),

      // ── OUTLINED BUTTON ─────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightColorScheme.primary,
          side: BorderSide(color: lightColorScheme.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),

      // ── INPUT FIELDS ────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.body2,
        hintStyle: AppTextStyles.body2.copyWith(
          color: AppColors.subtitleText.withValues(alpha: 0.6),
        ),
        prefixIconColor: AppColors.subtitleText,
        suffixIconColor: AppColors.subtitleText,
      ),

      // ── CARD ────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ── FAB ─────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: const CircleBorder(),
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
      ),

      // ── ICON BUTTON ─────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: AppColors.titleText),
      ),

      // ── CHIP ────────────────────────────────────
      chipTheme: ChipThemeData(
        selectedColor: lightColorScheme.primary,
        labelStyle: AppTextStyles.body2,
        side: BorderSide(color: AppColors.divider),
      ),

      // ── BOTTOM SHEET ────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),

      // ── DIALOG ──────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: AppTextStyles.h2.copyWith(color: AppColors.titleText),
        contentTextStyle: AppTextStyles.body1.copyWith(
          color: AppColors.subtitleText,
        ),
      ),

      // ── LIST TILE ───────────────────────────────
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.subtitleText,
        titleTextStyle: AppTextStyles.body1.copyWith(
          color: AppColors.titleText,
        ),
        subtitleTextStyle: AppTextStyles.body2.copyWith(
          color: AppColors.subtitleText,
        ),
      ),

      // ── POPUP MENU ──────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: AppTextStyles.body2.copyWith(color: AppColors.titleText),
      ),

      // ── SNACKBAR ────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.titleText,
        contentTextStyle: AppTextStyles.body2.copyWith(
          color: AppColors.lightSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),

      // ── DIVIDER ─────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
    );
  }

  // ===================================================================
  // 🌙 DARK MODE THEME
  // ===================================================================

  static ThemeData darkTheme(Color primaryColor) {
    final ColorScheme darkColorScheme =
        ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
          primary: primaryColor,
        ).copyWith(
          onPrimary: AppColors.darkTitleText,
          secondary: AppColors.secondary,
          onSecondary: AppColors.darkTitleText,
          surface: AppColors.darkSurface,
          error: AppColors.error,
          onError: AppColors.darkTitleText,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      dividerColor: AppColors.darkSurface,

      // ── TYPOGRAPHY ──────────────────────────────
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.h1.copyWith(
          color: AppColors.darkTitleText,
        ),
        headlineMedium: AppTextStyles.h2.copyWith(
          color: AppColors.darkTitleText,
        ),
        bodyLarge: AppTextStyles.body1.copyWith(color: AppColors.darkTitleText),
        bodyMedium: AppTextStyles.body2.copyWith(
          color: AppColors.darkSubtitleText,
        ),
        bodySmall: AppTextStyles.caption.copyWith(
          color: AppColors.darkSubtitleText,
        ),
        titleLarge: AppTextStyles.h2.copyWith(color: AppColors.darkTitleText),
        titleMedium: AppTextStyles.body1.copyWith(
          color: AppColors.darkTitleText,
        ),
      ),

      // ── APP BAR ─────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTitleText,
        surfaceTintColor: AppColors.darkSurface,
        elevation: 1,
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: AppColors.darkTitleText,
        ),
        centerTitle: true,
      ),

      // ── ELEVATED BUTTON ─────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          textStyle: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),

      // ── TEXT BUTTON ─────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
          textStyle: AppTextStyles.body1,
        ),
      ),

      // ── OUTLINED BUTTON ─────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
          side: BorderSide(color: darkColorScheme.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),

      // ── INPUT FIELDS ────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkSubtitleText),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkSubtitleText),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.body2.copyWith(
          color: AppColors.darkSubtitleText,
        ),
        hintStyle: AppTextStyles.body2.copyWith(
          color: AppColors.darkSubtitleText.withValues(alpha: 0.6),
        ),
        prefixIconColor: AppColors.darkSubtitleText,
        suffixIconColor: AppColors.darkSubtitleText,
      ),

      // ── CARD ────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // ── FAB ─────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: const CircleBorder(),
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
      ),

      // ── ICON BUTTON ─────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: AppColors.darkTitleText),
      ),

      // ── CHIP ────────────────────────────────────
      chipTheme: ChipThemeData(
        selectedColor: darkColorScheme.primary,
        labelStyle: AppTextStyles.body2.copyWith(
          color: AppColors.darkTitleText,
        ),
        side: const BorderSide(color: AppColors.darkSubtitleText),
      ),

      // ── BOTTOM SHEET ────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),

      // ── DIALOG ──────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: AppColors.darkTitleText,
        ),
        contentTextStyle: AppTextStyles.body1.copyWith(
          color: AppColors.darkSubtitleText,
        ),
      ),

      // ── LIST TILE ───────────────────────────────
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.darkSubtitleText,
        titleTextStyle: AppTextStyles.body1.copyWith(
          color: AppColors.darkTitleText,
        ),
        subtitleTextStyle: AppTextStyles.body2.copyWith(
          color: AppColors.darkSubtitleText,
        ),
      ),

      // ── POPUP MENU ──────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: AppTextStyles.body2.copyWith(color: AppColors.darkTitleText),
      ),

      // ── SNACKBAR ────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurface,
        contentTextStyle: AppTextStyles.body2.copyWith(
          color: AppColors.darkTitleText,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),

      // ── DIVIDER ─────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.darkSubtitleText,
        thickness: 1,
      ),
    );
  }
}
