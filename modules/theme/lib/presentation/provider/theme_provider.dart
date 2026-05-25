import 'package:flutter/material.dart';

/// Manages the application's theme state and provides theme-related functionality
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  /// Gets the current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Checks if dark mode is currently active
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Toggles between light and dark theme modes
  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Sets the theme mode explicitly
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }
}

/// Extension for accessing theme-related properties from BuildContext
extension ThemeUtils on BuildContext {
  /// Gets the current theme's color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Gets the current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Gets the current brightness (light/dark)
  Brightness get brightness => Theme.of(this).brightness;
}
