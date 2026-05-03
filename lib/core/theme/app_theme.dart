import 'package:flutter/material.dart';
import 'package:invoicely/core/theme/app_colors.dart';
import 'package:invoicely/core/theme/app_text_styles.dart';

class AppTheme {
  // ===================================================================
  // ☀️ LIGHT MODE THEME
  // ===================================================================

  static ThemeData lightTheme() {
    // 1. Define the ColorScheme based on the provided palette
    final ColorScheme lightColorScheme = const ColorScheme.light().copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.lightSurface, // Text on primary background
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

      // 2. Typography
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.h1.copyWith(color: AppColors.titleText),
        headlineMedium: AppTextStyles.h2.copyWith(color: AppColors.titleText),
        bodyLarge: AppTextStyles.body1.copyWith(color: AppColors.titleText),
        bodyMedium: AppTextStyles.body2.copyWith(color: AppColors.subtitleText),
        bodySmall: AppTextStyles.caption.copyWith(
          color: AppColors.subtitleText,
        ),
        // Map remaining styles to ensure all widgets use custom themes
        titleLarge: AppTextStyles.h2.copyWith(color: AppColors.titleText),
        titleMedium: AppTextStyles.body1.copyWith(color: AppColors.titleText),
      ),

      // 3. App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.titleText,
        surfaceTintColor: AppColors.lightSurface,
        elevation: 0.1,
        titleTextStyle: AppTextStyles.h2,
        centerTitle: true,
        shadowColor: AppColors.secondary,
      ),

      // 4. Elevated Button Theme (Primary Action Button)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.lightSurface, // White text
          textStyle: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          minimumSize: const Size(
            double.infinity,
            50,
          ), // Full width minimum height
        ),
      ),

      // 5. Input Field Theme (Critical for forms)
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
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.body2,
        hintStyle: AppTextStyles.body2.copyWith(
          color: AppColors.subtitleText.withValues(alpha: 0.6),
        ),
      ),

      // 6. Card Theme (Uses Surface color)
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: CircleBorder(),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  // ===================================================================
  // 🌙 DARK MODE THEME (Extrapolated)
  // ===================================================================

  static ThemeData darkTheme() {
    // 1. Define the ColorScheme (Inverted background/surface, same brand colors)
    final ColorScheme darkColorScheme = const ColorScheme.dark().copyWith(
      primary: AppColors.primary, // Keep brand color consistent
      onPrimary: AppColors.darkTitleText,
      secondary: AppColors.secondary, // Keep brand color consistent
      onSecondary: AppColors.darkTitleText,
      surface: AppColors.darkSurface, // Very dark background
      error: AppColors.error, // Keep error color consistent
      onError: AppColors.darkTitleText,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      dividerColor: AppColors.darkSurface, // Darker divider
      // 2. Typography (Text colors are inverted for visibility)
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

      // 3. App Bar Theme
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

      // 4. Elevated Button Theme (Keep the same styling/colors)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.darkTitleText,
          textStyle: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),

      // 5. Input Field Theme (Adjusted for dark background)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.darkSubtitleText,
          ), // Use light gray for border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkSubtitleText),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.secondary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.body2.copyWith(
          color: AppColors.darkSubtitleText,
        ),
        hintStyle: AppTextStyles.body2.copyWith(
          color: AppColors.darkSubtitleText.withValues(alpha: 0.6),
        ),
      ),

      // 6. Card Theme
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: CircleBorder(),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
