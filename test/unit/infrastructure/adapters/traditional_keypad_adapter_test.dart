import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/src/domain/ports/keypad_port.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_config.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_key.dart';
import 'package:avkeypad/src/infrastructure/adapters/traditional_keypad_adapter.dart';

void main() {
  group('TraditionalKeypadAdapter', () {
    late KeypadPort adapter;

    setUp(() {
      adapter = TraditionalKeypadAdapter();
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

    test('getKeypadLayout returns traditional layout structure', () {
      // Arrange
      final config = KeypadConfig(
        showDecimalKey: true,
        showSignKey: true,
        showClearKey: true,
        showBackspaceKey: true,
        
        showCancelKey: true,
      );

      // Act
      final layout = adapter.getKeypadLayout(config);

      // Assert
      expect(
        layout.length,
        equals(5),
      ); // 3 digit rows + 1 bottom row + 1 action row

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

      // Fourth row: sign, 0, decimal
      expect(layout[3].length, equals(3));
      expect(layout[3][0].type, equals(KeypadKeyType.sign));
      expect(layout[3][1].value, equals('0'));
      expect(layout[3][2].type, equals(KeypadKeyType.decimal));

      // Fifth row: action keys
      expect(layout[4].length, equals(4)); // backspace, clear, confirm, cancel
      expect(
        layout[4].any((key) => key.type == KeypadKeyType.backspace),
        isTrue,
      );
      expect(layout[4].any((key) => key.type == KeypadKeyType.clear), isTrue);
      expect(layout[4].any((key) => key.type == KeypadKeyType.custom), isTrue);
      expect(layout[4].any((key) => key.type == KeypadKeyType.cancel), isTrue);
    });

    test('getKeypadLayout without sign key adjusts bottom row', () {
      // Arrange
      final config = KeypadConfig(showSignKey: false, showDecimalKey: true);

      // Act
      final layout = adapter.getKeypadLayout(config);

      // Assert
      expect(layout[3].length, equals(2)); // 0, decimal
      expect(layout[3][0].value, equals('0'));
      expect(layout[3][1].type, equals(KeypadKeyType.decimal));
    });

    test('getKeypadLayout without decimal key adjusts bottom row', () {
      // Arrange
      final config = KeypadConfig(showSignKey: true, showDecimalKey: false);

      // Act
      final layout = adapter.getKeypadLayout(config);

      // Assert
      expect(layout[3].length, equals(2)); // sign, 0
      expect(layout[3][0].type, equals(KeypadKeyType.sign));
      expect(layout[3][1].value, equals('0'));
    });

    test('getKeypadLayout without action keys has no action row', () {
      // Arrange
      final config = KeypadConfig(
        showBackspaceKey: false,
        showClearKey: false,
        
        showCancelKey: false,
      );

      // Act
      final layout = adapter.getKeypadLayout(config);

      // Assert
      expect(layout.length, equals(4)); // Only digit rows + bottom row
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
        adapter.getLocalizedKeyText(KeypadKeyType.custom),
        equals('Confirm'),
      );
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
  });
}
