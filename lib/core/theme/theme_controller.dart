import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends StateNotifier<ThemeMode> {
  static const _key = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeController(this._prefs) : super(_loadTheme(_prefs));

  static ThemeMode _loadTheme(SharedPreferences prefs) {
    final saved = prefs.getString(_key);
    switch (saved) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    _prefs.setString(_key, mode.name);
  }
}

class ColorController extends StateNotifier<Color> {
  static const _key = 'primary_color';
  final SharedPreferences _prefs;

  ColorController(this._prefs)
    : super(Color(_prefs.getInt(_key) ?? 0xFF4F46E5));

  void setColor(Color color) {
    state = color;
    _prefs.setInt(_key, color.value);
  }
}
