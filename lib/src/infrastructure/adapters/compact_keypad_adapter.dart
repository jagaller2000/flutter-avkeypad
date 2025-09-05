import '../../domain/ports/keypad_port.dart';
import '../../domain/value_objects/keypad_config.dart';
import '../../domain/value_objects/keypad_key.dart';

/// Compact keypad adapter that integrates action buttons within the digit grid
/// This layout strategy embeds action keys alongside digits for space efficiency
class CompactKeypadAdapter implements KeypadPort {
  @override
  KeypadConfig getDefaultConfig() {
    return const KeypadConfig();
  }

  @override
  List<List<KeypadKey>> getKeypadLayout(KeypadConfig config) {
    final layout = <List<KeypadKey>>[];

    // First row: 1, 2, 3
    layout.add([
      const KeypadKey(value: '1', type: KeypadKeyType.digit),
      const KeypadKey(value: '2', type: KeypadKeyType.digit),
      const KeypadKey(value: '3', type: KeypadKeyType.digit),
    ]);

    // Second row: 4, 5, 6
    layout.add([
      const KeypadKey(value: '4', type: KeypadKeyType.digit),
      const KeypadKey(value: '5', type: KeypadKeyType.digit),
      const KeypadKey(value: '6', type: KeypadKeyType.digit),
    ]);

    // Third row: 7, 8, 9
    layout.add([
      const KeypadKey(value: '7', type: KeypadKeyType.digit),
      const KeypadKey(value: '8', type: KeypadKeyType.digit),
      const KeypadKey(value: '9', type: KeypadKeyType.digit),
    ]);

    // Fourth row: varies based on configuration
    final bottomRow = <KeypadKey>[];

    // Add clear key to left if enabled
    if (config.showClearKey) {
      bottomRow.add(
        const KeypadKey(
          value: 'clear',
          type: KeypadKeyType.clear,
          displayText: 'C',
        ),
      );
    }

    // Add sign key if enabled (when clear is disabled, it can go left)
    if (config.showSignKey && !config.showClearKey) {
      bottomRow.add(
        const KeypadKey(value: '±', type: KeypadKeyType.sign, displayText: '±'),
      );
    }

    // Always add zero
    bottomRow.add(const KeypadKey(value: '0', type: KeypadKeyType.digit));

    // Add sign key to right of zero if clear key took the left spot
    if (config.showSignKey && config.showClearKey) {
      bottomRow.add(
        const KeypadKey(value: '±', type: KeypadKeyType.sign, displayText: '±'),
      );
    }

    // Add decimal key if enabled
    if (config.showDecimalKey) {
      bottomRow.add(
        KeypadKey(
          value: config.decimalSeparator,
          type: KeypadKeyType.decimal,
          displayText: config.decimalSeparator,
        ),
      );
    }

    layout.add(bottomRow);

    return layout;
  }

  /// Get action keys that should be displayed around the display area
  List<KeypadKey> getDisplayActionKeys(KeypadConfig config) {
    final actionKeys = <KeypadKey>[];

    if (config.showConfirmKey) {
      actionKeys.add(
        const KeypadKey(
          value: 'confirm',
          type: KeypadKeyType.confirm,
          displayText: '✓',
        ),
      );
    }

    if (config.showBackspaceKey) {
      actionKeys.add(
        const KeypadKey(
          value: 'backspace',
          type: KeypadKeyType.backspace,
          displayText: '⌫',
        ),
      );
    }

    return actionKeys;
  }

  @override
  String getLocalizedKeyText(KeypadKeyType keyType) {
    switch (keyType) {
      case KeypadKeyType.digit:
        return 'Digit';
      case KeypadKeyType.decimal:
        return 'Decimal';
      case KeypadKeyType.backspace:
        return 'Delete';
      case KeypadKeyType.clear:
        return 'Clear';
      case KeypadKeyType.confirm:
        return 'Confirm';
      case KeypadKeyType.cancel:
        return 'Cancel';
      case KeypadKeyType.sign:
        return 'Sign';
      case KeypadKeyType.custom:
        return 'Custom';
    }
  }
}
