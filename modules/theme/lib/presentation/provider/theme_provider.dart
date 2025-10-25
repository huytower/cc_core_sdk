import 'package:flutter/material.dart';

/// Manages the application's utils state and provides utils-related functionality
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  /// Gets the current utils mode
  ThemeMode get themeMode => _themeMode;

  /// Checks if dark mode is currently active
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Toggles between light and dark utils
  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Sets the utils mode explicitly
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }
}

/// Extension for accessing utils-related properties from BuildContext
extension ThemeUtils on BuildContext {
  /// Gets the current utils's color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Gets the current text utils
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Gets the current brightness (light/dark)
  Brightness get brightness => Theme.of(this).brightness;
}
