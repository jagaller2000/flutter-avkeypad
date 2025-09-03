import 'package:flutter/material.dart';

/// Extension on TextTheme to provide custom font configurations
extension CustomFontTextTheme on TextTheme {
  /// Returns a TextTheme with B612 as the default font family
  TextTheme get withB612Font {
    return copyWith(
      displayLarge: displayLarge?.copyWith(fontFamily: 'B612'),
      displayMedium: displayMedium?.copyWith(fontFamily: 'B612'),
      displaySmall: displaySmall?.copyWith(fontFamily: 'B612'),
      headlineLarge: headlineLarge?.copyWith(fontFamily: 'B612'),
      headlineMedium: headlineMedium?.copyWith(fontFamily: 'B612'),
      headlineSmall: headlineSmall?.copyWith(fontFamily: 'B612'),
      titleLarge: titleLarge?.copyWith(fontFamily: 'B612'),
      titleMedium: titleMedium?.copyWith(fontFamily: 'B612'),
      titleSmall: titleSmall?.copyWith(fontFamily: 'B612'),
      bodyLarge: bodyLarge?.copyWith(fontFamily: 'B612'),
      bodyMedium: bodyMedium?.copyWith(fontFamily: 'B612'),
      bodySmall: bodySmall?.copyWith(fontFamily: 'B612'),
      labelLarge: labelLarge?.copyWith(fontFamily: 'B612'),
      labelMedium: labelMedium?.copyWith(fontFamily: 'B612'),
      labelSmall: labelSmall?.copyWith(fontFamily: 'B612'),
    );
  }

  /// Returns a TextTheme with B612 Mono for numeric content (used in keypad)
  TextTheme get withB612MonoForNumbers {
    return copyWith(
      // Use titleMedium for keypad keys (numbers)
      titleMedium: titleMedium?.copyWith(
        fontFamily: 'B612 Mono',
        fontFeatures: [
          const FontFeature.tabularFigures(), // Monospaced digits
        ],
      ),
      // Use headlineMedium for keypad display (main number display)
      headlineMedium: headlineMedium?.copyWith(
        fontFamily: 'B612 Mono',
        fontFeatures: [
          const FontFeature.tabularFigures(), // Monospaced digits
        ],
      ),
      // Use bodyLarge for other numeric content
      bodyLarge: bodyLarge?.copyWith(
        fontFamily: 'B612 Mono',
        fontFeatures: [
          const FontFeature.tabularFigures(), // Monospaced digits
        ],
      ),
    );
  }

  /// Returns a complete TextTheme with B612 as default and B612 Mono for numbers
  TextTheme get withCustomFonts {
    return withB612Font.withB612MonoForNumbers;
  }
}
