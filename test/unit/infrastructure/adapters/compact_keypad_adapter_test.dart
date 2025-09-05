import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/src/domain/ports/keypad_port.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_config.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_key.dart';
import 'package:avkeypad/src/infrastructure/adapters/compact_keypad_adapter.dart';

void main() {
  group('CompactKeypadAdapter', () {
    late CompactKeypadAdapter adapter;

    setUp(() {
      adapter = CompactKeypadAdapter();
    });

    test('implements KeypadPort interface', () {
      expect(adapter, isA<KeypadPort>());
    });

    test('getDefaultConfig returns valid configuration', () {
      // Act
      final config = adapter.getDefaultConfig();

      // Assert
      expect(config, isA<KeypadConfig>());
      expect(config.showDecimalKey, isTrue);
      expect(config.showClearKey, isTrue);
      expect(config.showBackspaceKey, isTrue);
    });

    test('getKeypadLayout returns compact layout structure', () {
      // Arrange
      final config = KeypadConfig(
        showDecimalKey: true,
        showSignKey: true,
        showClearKey: true,
      );

      // Act
      final layout = adapter.getKeypadLayout(config);

      // Assert
      expect(
        layout.length,
        equals(4),
      ); // 3 digit rows + 1 bottom row (action buttons now in getDisplayActionKeys)

      // First row: 1, 2, 3
      expect(layout[0].length, equals(3));
      expect(layout[0][0].value, equals('1'));
      expect(layout[0][1].value, equals('2'));
      expect(layout[0][2].value, equals('3'));

      // Second row: 4, 5, 6
      expect(layout[1].length, equals(3));
      expect(layout[1][0].value, equals('4'));
      expect(layout[1][1].value, equals('5'));
      expect(layout[1][2].value, equals('6'));

      // Third row: 7, 8, 9
      expect(layout[2].length, equals(3));
      expect(layout[2][0].value, equals('7'));
      expect(layout[2][1].value, equals('8'));
      expect(layout[2][2].value, equals('9'));

      // Fourth row: sign, 0, decimal (clear is now in display area)
      expect(layout[3].length, equals(3));
      expect(layout[3][0].type, equals(KeypadKeyType.sign));
      expect(layout[3][1].value, equals('0'));
      expect(layout[3][2].type, equals(KeypadKeyType.decimal));
    });

    test('getKeypadLayout without clear key puts sign on left', () {
      // Arrange
      final config = KeypadConfig(
        showSignKey: true,
        showClearKey: false,
        showDecimalKey: true,
      );

      // Act
      final layout = adapter.getKeypadLayout(config);

      // Assert
      expect(layout[3].length, equals(3));
      expect(layout[3][0].type, equals(KeypadKeyType.sign));
      expect(layout[3][1].value, equals('0'));
      expect(layout[3][2].type, equals(KeypadKeyType.decimal));
    });

    test('getKeypadLayout with clear and sign puts sign on left of zero', () {
      // Arrange
      final config = KeypadConfig(
        showSignKey: true,
        showClearKey: true,
        showDecimalKey: true,
      );

      // Act
      final layout = adapter.getKeypadLayout(config);

      // Assert - clear is now in display area, so bottom row has sign, 0, decimal
      expect(layout[3].length, equals(3));
      expect(layout[3][0].type, equals(KeypadKeyType.sign)); // Sign on left
      expect(layout[3][1].value, equals('0')); // Zero in center
      expect(
        layout[3][2].type,
        equals(KeypadKeyType.decimal),
      ); // Decimal on right
    });

    test('getDisplayActionKeys returns confirm and backspace when enabled', () {
      // Arrange
      final config = KeypadConfig(showBackspaceKey: true);

      // Act
      final actionKeys = adapter.getDisplayActionKeys(config);

      // Assert
      expect(actionKeys.length, equals(1));
      expect(
        actionKeys.any((key) => key.type == KeypadKeyType.backspace),
        isTrue,
      );
    });

    test(
      'getDisplayActionKeys returns only confirm when backspace disabled',
      () {
        // Arrange
        final config = KeypadConfig(showBackspaceKey: false);

        // Act
        final actionKeys = adapter.getDisplayActionKeys(config);

        // Assert
        expect(actionKeys.length, equals(0));
      },
    );

    test(
      'getDisplayActionKeys returns only backspace when confirm disabled',
      () {
        // Arrange
        final config = KeypadConfig(showBackspaceKey: true);

        // Act
        final actionKeys = adapter.getDisplayActionKeys(config);

        // Assert
        expect(actionKeys.length, equals(1));
        expect(actionKeys[0].type, equals(KeypadKeyType.backspace));
      },
    );

    test('getDisplayActionKeys returns empty when both disabled', () {
      // Arrange
      final config = KeypadConfig(showBackspaceKey: false);

      // Act
      final actionKeys = adapter.getDisplayActionKeys(config);

      // Assert
      expect(actionKeys.isEmpty, isTrue);
    });

    test('getKeypadLayout with custom decimal separator', () {
      // Arrange
      final config = KeypadConfig(decimalSeparator: ',', showDecimalKey: true);

      // Act
      final layout = adapter.getKeypadLayout(config);

      // Assert
      final decimalKey = layout[3].firstWhere(
        (key) => key.type == KeypadKeyType.decimal,
      );
      expect(decimalKey.value, equals(','));
      expect(decimalKey.displayText, equals(','));
    });

    test('getLocalizedKeyText returns correct text for each key type', () {
      // Act & Assert
      expect(adapter.getLocalizedKeyText(KeypadKeyType.digit), equals('Digit'));
      expect(
        adapter.getLocalizedKeyText(KeypadKeyType.decimal),
        equals('Decimal'),
      );
      expect(
        adapter.getLocalizedKeyText(KeypadKeyType.backspace),
        equals('Delete'),
      );
      expect(adapter.getLocalizedKeyText(KeypadKeyType.clear), equals('Clear'));
      expect(
        adapter.getLocalizedKeyText(KeypadKeyType.cancel),
        equals('Cancel'),
      );
      expect(adapter.getLocalizedKeyText(KeypadKeyType.sign), equals('Sign'));
      expect(
        adapter.getLocalizedKeyText(KeypadKeyType.custom),
        equals('Custom'),
      );
    });

    test('getKeypadLayout excludes action buttons from grid layout', () {
      // Arrange
      final config = KeypadConfig(showDecimalKey: true, showBackspaceKey: true);

      // Act
      final layout = adapter.getKeypadLayout(config);

      // Assert
      expect(
        layout.length,
        equals(4),
      ); // 3 digit rows + 1 bottom row (action buttons now separate)

      // Action buttons should NOT be in the layout grid
      final allKeys = layout.expand((row) => row).toList();
      expect(allKeys.any((key) => key.type == KeypadKeyType.custom), isFalse);
      expect(
        allKeys.any((key) => key.type == KeypadKeyType.backspace),
        isFalse,
      );
    });

    test('getDisplayActionKeys returns action buttons when enabled', () {
      // Arrange
      final config = KeypadConfig(showDecimalKey: true, showBackspaceKey: true);

      // Act
      final actionKeys = adapter.getDisplayActionKeys(config);

      // Assert
      expect(actionKeys.length, equals(1));

      // Should have backspace button
      final backspaceButton = actionKeys.firstWhere(
        (key) => key.type == KeypadKeyType.backspace,
      );
      expect(backspaceButton.value, equals('backspace'));
      expect(backspaceButton.displayText, equals('⌫'));
    });

    test(
      'getDisplayActionKeys includes no buttons when backspace disabled',
      () {
        // Arrange
        final config = KeypadConfig(
          showDecimalKey: true,

          showBackspaceKey: false,
        );

        // Act
        final actionKeys = adapter.getDisplayActionKeys(config);

        // Assert
        expect(actionKeys.length, equals(0));
      },
    );
  });
}
