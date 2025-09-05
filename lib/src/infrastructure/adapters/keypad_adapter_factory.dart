import '../../domain/ports/keypad_port.dart';
import 'traditional_keypad_adapter.dart';
import 'compact_keypad_adapter.dart';

/// Strategy enumeration for different keypad layout styles
enum KeypadLayoutStrategy {
  /// Traditional layout with action keys in separate bottom row
  traditional,

  /// Compact layout with action keys integrated around the display
  compact,
}

/// Factory for creating keypad adapters based on layout strategy
class KeypadAdapterFactory {
  /// Creates a keypad adapter based on the specified strategy
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
