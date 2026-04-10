import 'package:flutter/material.dart';
import 'package:invoicely/core/theme/app_colors.dart';

class AppTextStyles {
  // Base Text Colors (for light mode)
  static const Color _titleColor = AppColors.titleText;
  static const Color _subtitleColor = AppColors.subtitleText;

  // H1 (Page Title): 22–24 bold
  static const TextStyle h1 = TextStyle(
    fontSize: 24, // Choosing 24px
    fontWeight: FontWeight.bold,
    color: _titleColor,
  );

  // H2 (Section Title): 18–20 semi-bold
  static const TextStyle h2 = TextStyle(
    fontSize: 20, // Choosing 20px
    fontWeight: FontWeight.w600, // semi-bold
    color: _titleColor,
  );

  // Body 1: 16 regular
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: _titleColor,
  );

  // Body 2: 14 regular
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: _subtitleColor,
  );

  // Caption: 12 regular
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: _subtitleColor,
  );
}
