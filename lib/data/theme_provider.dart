import 'package:flutter/material.dart';

/// Provides global theme mode state for Light / Dark mode toggling.
/// Used by [MainLayoutScreen]'s swipe gesture and consumed at the
/// app root to switch [MaterialApp.themeMode].
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  /// Directly set a specific [ThemeMode] (light / dark / system).
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  /// Convenience toggle between light and dark (ignores system).
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}
