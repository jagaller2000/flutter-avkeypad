import '../value_objects/keypad_config.dart';
import '../value_objects/keypad_key.dart';
import '../ports/keypad_port.dart';

/// Use case for generating the keypad layout based on configuration
class GenerateKeypadLayoutUseCase {
  const GenerateKeypadLayoutUseCase(this._port);

  final KeypadPort _port;

  /// Generate the keypad layout based on configuration
  List<List<KeypadKey>> call(KeypadConfig config) {
    return _port.getKeypadLayout(config);
  }

  /// Generate the default standard numeric keypad layout
  List<List<KeypadKey>> generateStandardLayout(KeypadConfig config) {
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

    // Add sign key if enabled
    if (config.showSignKey) {
      bottomRow.add(
        const KeypadKey(value: '±', type: KeypadKeyType.sign, displayText: '±'),
      );
    }

    // Always add zero
    bottomRow.add(const KeypadKey(value: '0', type: KeypadKeyType.digit));

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

    // Add action row if any action keys are enabled
    final actionRow = <KeypadKey>[];

    if (config.showBackspaceKey) {
      actionRow.add(
        const KeypadKey(
          value: 'backspace',
          type: KeypadKeyType.backspace,
          displayText: '⌫',
        ),
      );
    }

    if (config.showClearKey) {
      actionRow.add(
        const KeypadKey(
          value: 'clear',
          type: KeypadKeyType.clear,
          displayText: 'C',
        ),
      );
    }

    if (config.showCancelKey) {
      actionRow.add(
        const KeypadKey(
          value: 'cancel',
          type: KeypadKeyType.cancel,
          displayText: '✕',
        ),
      );
    }

    // Add custom keys
    actionRow.addAll(config.customKeys);

    if (actionRow.isNotEmpty) {
      layout.add(actionRow);
    }

    return layout;
  }
}
