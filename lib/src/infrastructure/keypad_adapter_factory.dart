import '../domain/ports/keypad_port.dart';
import 'adapters/traditional_keypad_adapter.dart';
import 'adapters/compact_keypad_adapter.dart';

/// Layout strategy options for package developers
/// Choose the layout style that best fits your app's design requirements
enum KeypadLayoutStrategy {
  /// Traditional 3x4 digit grid with action keys in a separate bottom row
  /// Best for: Standard numeric input, calculator-style interfaces
  /// Layout: Digits in 4 rows, actions below (backspace, clear, cancel)
  traditional,

  /// Compact layout integrating action keys within/around the digit area
  /// Best for: Space-constrained UIs, mobile-first designs
  /// Layout: Digits with embedded actions, fewer rows, side-mounted buttons
  compact,
}

/// Factory for creating keypad adapters based on layout strategy
/// Package developers use this to select their preferred keypad layout
class KeypadAdapterFactory {
  /// Creates a keypad adapter for the specified layout strategy
  ///
  /// Example usage:
  /// ```dart
  /// // For traditional calculator-style layout
  /// final adapter = KeypadAdapterFactory.createAdapter(KeypadLayoutStrategy.traditional);
  ///
  /// // For compact space-efficient layout
  /// final adapter = KeypadAdapterFactory.createAdapter(KeypadLayoutStrategy.compact);
  /// ```
  static KeypadPort createAdapter(KeypadLayoutStrategy strategy) {
    switch (strategy) {
      case KeypadLayoutStrategy.traditional:
        return TraditionalKeypadAdapter();
      case KeypadLayoutStrategy.compact:
        return CompactKeypadAdapter();
    }
  }

  /// Gets the default adapter (traditional layout)
  static KeypadPort getDefaultAdapter() {
    return createAdapter(KeypadLayoutStrategy.traditional);
  }

  /// Gets all available layout strategies
  static List<KeypadLayoutStrategy> getAllStrategies() {
    return KeypadLayoutStrategy.values;
  }

  /// Gets a human-readable description for each strategy
  static String getStrategyDescription(KeypadLayoutStrategy strategy) {
    switch (strategy) {
      case KeypadLayoutStrategy.traditional:
        return 'Traditional layout with action keys in a separate row at the bottom';
      case KeypadLayoutStrategy.compact:
        return 'Compact layout with action keys integrated around the display area';
    }
  }
}
