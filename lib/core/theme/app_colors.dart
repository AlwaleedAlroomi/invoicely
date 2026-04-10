import 'package:flutter/material.dart';

class AppColors {
  // main colors
  static const Color primary = Color(0xFF4A90E2);
  static const Color secondary = Color(0xFF2D9CDB);

  // Status Colors
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF2C94C);
  static const Color error = Color(0xFFEB5757);

  // Light Mode Palette
  static const Color lightBackground = Color(0xFFF7F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF); // Cards, List Items

  // Neutral Text
  static const Color titleText = Color(0xFF1A1A1A);
  static const Color subtitleText = Color(0xFF4F4F4F);
  static const Color divider = Color(0xFFE0E0E0);

  // Dark Mode Palette (Extrapolated)
  static const Color darkBackground = Color(0xFF121212); // Deep dark gray
  static const Color darkSurface = Color(
    0xFF1E1E1E,
  ); // Slightly lighter for cards
  static const Color darkTitleText = Color(0xFFFFFFFF);
  static const Color darkSubtitleText = Color(
    0xFFB0B0B0,
  ); // Light grey subtitle
}
