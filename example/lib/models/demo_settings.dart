import 'package:flutter/material.dart';

/// Settings model for the demo application
class DemoSettings extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  VisualDensity _visualDensity = VisualDensity.standard;
  double _textScaleFactor = 1.0;

  /// Current theme mode (light, dark, or system)
  ThemeMode get themeMode => _themeMode;

  /// Current visual density
  VisualDensity get visualDensity => _visualDensity;

  /// Current text scale factor
  double get textScaleFactor => _textScaleFactor;

  /// Set theme mode
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  /// Set visual density
  void setVisualDensity(VisualDensity density) {
    if (_visualDensity != density) {
      _visualDensity = density;
      notifyListeners();
    }
  }

  /// Set text scale factor
  void setTextScaleFactor(double factor) {
    if (_textScaleFactor != factor) {
      _textScaleFactor = factor.clamp(0.5, 3.0); // Reasonable limits
      notifyListeners();
    }
  }

  /// Get display name for theme mode
  String getThemeModeDisplayName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Get display name for visual density
  String getVisualDensityDisplayName(VisualDensity density) {
    if (density == VisualDensity.compact) return 'Compact';
    if (density == VisualDensity.comfortable) return 'Comfortable';
    if (density == VisualDensity.standard) return 'Standard';
    if (density == relaxedVisualDensity) return 'Relaxed';
    return 'Custom';
  }

  /// Available theme modes
  static const List<ThemeMode> availableThemeModes = [
    ThemeMode.system,
    ThemeMode.light,
    ThemeMode.dark,
  ];

  /// Available visual densities
  static final List<VisualDensity> availableVisualDensities = [
    VisualDensity.standard,
    VisualDensity.comfortable,
    VisualDensity.compact,
    relaxedVisualDensity,
  ];

  /// Relaxed visual density with extra spacing
  static const VisualDensity relaxedVisualDensity = VisualDensity(
    horizontal: 2.0,
    vertical: 2.0,
  );

  /// Available text scale factors
  static const List<double> availableTextScaleFactors = [
    0.8,
    0.9,
    1.0,
    1.1,
    1.2,
    1.3,
    1.5,
    2.0,
  ];
}
