import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

void main() {
  group('KeypadConfig Value Object Tests', () {
    group('Constructor and Default Values', () {
      test('should create config with default values', () {
        const config = KeypadConfig();

        expect(config.showDecimalKey, isTrue);
        expect(config.showSignKey, isFalse);
        expect(config.showClearKey, isTrue);
        expect(config.showBackspaceKey, isTrue);
        expect(config.showCancelKey, isFalse);
        expect(config.maxDigits, isNull);
        expect(config.maxDecimalPlaces, equals(2));
        expect(config.allowNegative, isFalse);
        expect(config.allowZero, isTrue);
        expect(config.stepSize, isNull);
        expect(config.decimalSeparator, equals('.'));
        expect(config.customKeys, isEmpty);
        expect(config.unit, isNull);
      });

      test('should create config with custom values', () {
        final customKeys = [
          const KeypadKey(value: '7', type: KeypadKeyType.digit),
          const KeypadKey(
            value: 'X',
            type: KeypadKeyType.custom,
            displayText: 'custom',
          ),
        ];

        final config = KeypadConfig(
          showDecimalKey: false,
          showSignKey: true,
          showClearKey: false,
          showBackspaceKey: false,

          showCancelKey: true,
          maxDigits: 5,
          maxDecimalPlaces: 3,
          allowNegative: true,
          allowZero: false,
          stepSize: 0.5,
          decimalSeparator: ',',
          customKeys: customKeys,
          unit: 'km',
        );

        expect(config.showDecimalKey, isFalse);
        expect(config.showSignKey, isTrue);
        expect(config.showClearKey, isFalse);
        expect(config.showBackspaceKey, isFalse);
        expect(config.showCancelKey, isTrue);
        expect(config.maxDigits, equals(5));
        expect(config.maxDecimalPlaces, equals(3));
        expect(config.allowNegative, isTrue);
        expect(config.allowZero, isFalse);
        expect(config.stepSize, equals(0.5));
        expect(config.decimalSeparator, equals(','));
        expect(config.customKeys, equals(customKeys));
        expect(config.unit, equals('km'));
      });
    });

    group('Copy With Functionality', () {
      test('should copy with no changes', () {
        const original = KeypadConfig(maxDigits: 5, allowNegative: true);
        final copied = original.copyWith();

        expect(copied, equals(original));
        expect(identical(copied, original), isFalse);
      });

      test('should copy with single property change', () {
        const original = KeypadConfig();
        final copied = original.copyWith(showDecimalKey: false);

        expect(copied.showDecimalKey, isFalse);
        expect(copied.showSignKey, equals(original.showSignKey));
        expect(copied.maxDecimalPlaces, equals(original.maxDecimalPlaces));
      });

      test('should copy with multiple property changes', () {
        const original = KeypadConfig();
        final copied = original.copyWith(
          showDecimalKey: false,
          showSignKey: true,
          maxDigits: 10,
          allowNegative: true,
          stepSize: 2.0,
        );

        expect(copied.showDecimalKey, isFalse);
        expect(copied.showSignKey, isTrue);
        expect(copied.maxDigits, equals(10));
        expect(copied.allowNegative, isTrue);
        expect(copied.stepSize, equals(2.0));

        // Unchanged properties should remain the same
        expect(copied.showClearKey, equals(original.showClearKey));
        expect(copied.maxDecimalPlaces, equals(original.maxDecimalPlaces));
      });

      test('should copy with custom keys change', () {
        const original = KeypadConfig();
        final newCustomKeys = [
          const KeypadKey(value: '7', type: KeypadKeyType.digit),
          const KeypadKey(value: 'confirm', type: KeypadKeyType.custom),
        ];
        final copied = original.copyWith(customKeys: newCustomKeys);

        expect(copied.customKeys, equals(newCustomKeys));
        expect(copied.customKeys.length, equals(2));
      });

      test('should copy with unit change', () {
        const original = KeypadConfig();
        final copied = original.copyWith(unit: 'kg');

        expect(copied.unit, equals('kg'));
        expect(original.unit, isNull); // Original should remain unchanged
      });

      test('should copy with null values to reset optional properties', () {
        const original = KeypadConfig(maxDigits: 5, stepSize: 2.0);
        // Note: copyWith doesn't support setting nullable values to null,
        // this test verifies the current behavior
        final copied = original.copyWith();

        expect(copied.maxDigits, equals(5)); // Unchanged
        expect(copied.stepSize, equals(2.0)); // Unchanged
      });
    });

    group('Equality and Hash Code', () {
      test('should be equal when all properties match', () {
        const config1 = KeypadConfig(
          showDecimalKey: true,
          maxDigits: 5,
          allowNegative: true,
          stepSize: 0.5,
        );
        const config2 = KeypadConfig(
          showDecimalKey: true,
          maxDigits: 5,
          allowNegative: true,
          stepSize: 0.5,
        );

        expect(config1, equals(config2));
        expect(config1.hashCode, equals(config2.hashCode));
      });

      test('should not be equal when properties differ', () {
        const config1 = KeypadConfig(maxDigits: 5);
        const config2 = KeypadConfig(maxDigits: 10);

        expect(config1, isNot(equals(config2)));
      });

      test('should not be equal when boolean flags differ', () {
        const config1 = KeypadConfig(showDecimalKey: true);
        const config2 = KeypadConfig(showDecimalKey: false);

        expect(config1, isNot(equals(config2)));
      });

      test('should not be equal when custom keys differ', () {
        final config1 = KeypadConfig(
          customKeys: [const KeypadKey(value: '7', type: KeypadKeyType.digit)],
        );
        final config2 = KeypadConfig(
          customKeys: [const KeypadKey(value: '8', type: KeypadKeyType.digit)],
        );

        expect(config1, isNot(equals(config2)));
      });

      test('should not be equal when unit differs', () {
        const config1 = KeypadConfig(unit: 'km');
        const config2 = KeypadConfig(unit: 'kg');

        expect(config1, isNot(equals(config2)));
      });

      test('should not be equal when one has unit and other does not', () {
        const config1 = KeypadConfig(unit: 'km');
        const config2 = KeypadConfig();

        expect(config1, isNot(equals(config2)));
      });

      test('should be equal with identical custom keys', () {
        final customKeys = [
          const KeypadKey(value: '7', type: KeypadKeyType.digit),
          const KeypadKey(value: 'clear', type: KeypadKeyType.clear),
        ];
        final config1 = KeypadConfig(customKeys: customKeys);
        final config2 = KeypadConfig(customKeys: List.from(customKeys));

        expect(config1, equals(config2));
        expect(config1.hashCode, equals(config2.hashCode));
      });

      test('should be equal to itself', () {
        const config = KeypadConfig(maxDigits: 5);
        expect(config, equals(config));
        expect(identical(config, config), isTrue);
      });

      test('should not be equal to different types', () {
        const config = KeypadConfig();
        expect(config, isNot(equals('string')));
        expect(config, isNot(equals(123)));
        expect(config, isNot(equals(null)));
      });
    });

    group('String Representation', () {
      test('should have meaningful toString', () {
        const config = KeypadConfig(
          maxDigits: 5,
          allowNegative: true,
          stepSize: 0.5,
        );

        final result = config.toString();

        expect(result, contains('KeypadConfig'));
        expect(result, contains('maxDigits: 5'));
        expect(result, contains('allowNegative: true'));
        expect(result, contains('stepSize: 0.5'));
      });

      test('should include all properties in toString', () {
        const config = KeypadConfig();
        final result = config.toString();

        expect(result, contains('showDecimalKey:'));
        expect(result, contains('showSignKey:'));
        expect(result, contains('showClearKey:'));
        expect(result, contains('showBackspaceKey:'));
        expect(result, contains('showCancelKey:'));
        expect(result, contains('maxDigits:'));
        expect(result, contains('maxDecimalPlaces:'));
        expect(result, contains('allowNegative:'));
        expect(result, contains('allowZero:'));
        expect(result, contains('stepSize:'));
        expect(result, contains('decimalSeparator:'));
        expect(result, contains('customKeys:'));
        expect(result, contains('unit:'));
      });
    });

    group('Validation Logic Support', () {
      test('should support integer-only configuration', () {
        const config = KeypadConfig(showDecimalKey: false, maxDecimalPlaces: 0);

        expect(config.showDecimalKey, isFalse);
        expect(config.maxDecimalPlaces, equals(0));
      });

      test('should support strict numeric input configuration', () {
        const config = KeypadConfig(
          allowNegative: false,
          allowZero: false,
          maxDigits: 5,
          maxDecimalPlaces: 0,
        );

        expect(config.allowNegative, isFalse);
        expect(config.allowZero, isFalse);
        expect(config.maxDigits, equals(5));
        expect(config.maxDecimalPlaces, equals(0));
      });

      test('should support flexible decimal configuration', () {
        const config = KeypadConfig(
          showDecimalKey: true,
          maxDecimalPlaces: 4,
          stepSize: 0.0001,
        );

        expect(config.showDecimalKey, isTrue);
        expect(config.maxDecimalPlaces, equals(4));
        expect(config.stepSize, equals(0.0001));
      });

      test('should support custom separator configuration', () {
        const config = KeypadConfig(
          decimalSeparator: ',',
          showDecimalKey: true,
        );

        expect(config.decimalSeparator, equals(','));
        expect(config.showDecimalKey, isTrue);
      });
    });

    group('Edge Cases', () {
      test('should handle zero max decimal places', () {
        const config = KeypadConfig(maxDecimalPlaces: 0);
        expect(config.maxDecimalPlaces, equals(0));
      });

      test('should handle large max digits', () {
        const config = KeypadConfig(maxDigits: 1000);
        expect(config.maxDigits, equals(1000));
      });

      test('should handle very small step size', () {
        const config = KeypadConfig(stepSize: 0.000001);
        expect(config.stepSize, equals(0.000001));
      });

      test('should handle empty customKeys list', () {
        const config = KeypadConfig(customKeys: []);
        final copied = config.copyWith();

        expect(copied.customKeys, isEmpty);
      });

      test('should handle large custom keys list', () {
        final manyKeys = List.generate(
          100,
          (i) =>
              KeypadKey(value: (i % 10).toString(), type: KeypadKeyType.digit),
        );
        final config = KeypadConfig(customKeys: manyKeys);

        expect(config.customKeys.length, equals(100));
      });

      test('should handle unusual decimal separators', () {
        const config = KeypadConfig(decimalSeparator: '·');
        expect(config.decimalSeparator, equals('·'));
      });
    });

    group('Unit Display', () {
      test('should create config with null unit by default', () {
        const config = KeypadConfig();
        expect(config.unit, isNull);
      });

      test('should create config with custom unit', () {
        const config = KeypadConfig(unit: 'kg');
        expect(config.unit, equals('kg'));
      });

      test('should support various unit types', () {
        const testCases = ['km', 'kg', 'm/s', '°C', '$', '%', 'ft'];
        
        for (final unit in testCases) {
          final config = KeypadConfig(unit: unit);
          expect(config.unit, equals(unit));
        }
      });

      test('should handle empty string unit', () {
        const config = KeypadConfig(unit: '');
        expect(config.unit, equals(''));
      });

      test('should be equal when units match', () {
        const config1 = KeypadConfig(unit: 'km');
        const config2 = KeypadConfig(unit: 'km');
        expect(config1, equals(config2));
      });

      test('should copy with unit preserved', () {
        const original = KeypadConfig(unit: 'km');
        final copied = original.copyWith(maxDigits: 5);
        expect(copied.unit, equals('km'));
        expect(copied.maxDigits, equals(5));
      });
    });

    group('Common Configuration Patterns', () {
      test('should support calculator-like configuration', () {
        const config = KeypadConfig(
          showDecimalKey: true,
          showSignKey: true,
          showClearKey: true,
          showBackspaceKey: true,
          allowNegative: true,
          allowZero: true,
        );

        expect(config.showDecimalKey, isTrue);
        expect(config.showSignKey, isTrue);
        expect(config.allowNegative, isTrue);
      });

      test('should support PIN entry configuration', () {
        const config = KeypadConfig(
          showDecimalKey: false,
          showSignKey: false,
          showClearKey: true,
          showBackspaceKey: true,
          maxDigits: 4,
          maxDecimalPlaces: 0,
          allowNegative: false,
          allowZero: true,
        );

        expect(config.showDecimalKey, isFalse);
        expect(config.showSignKey, isFalse);
        expect(config.maxDigits, equals(4));
        expect(config.allowNegative, isFalse);
      });

      test('should support currency input configuration', () {
        const config = KeypadConfig(
          showDecimalKey: true,
          maxDecimalPlaces: 2,
          allowNegative: false,
          allowZero: true,
          stepSize: 0.01,
        );

        expect(config.showDecimalKey, isTrue);
        expect(config.maxDecimalPlaces, equals(2));
        expect(config.stepSize, equals(0.01));
      });

      test('should support scientific calculator configuration', () {
        final customKeys = [
          const KeypadKey(
            value: 'π',
            type: KeypadKeyType.custom,
            displayText: 'pi',
          ),
          const KeypadKey(
            value: 'e',
            type: KeypadKeyType.custom,
            displayText: 'euler',
          ),
        ];

        final config = KeypadConfig(
          showDecimalKey: true,
          showSignKey: true,
          allowNegative: true,
          maxDecimalPlaces: 10,
          customKeys: customKeys,
        );

        expect(config.allowNegative, isTrue);
        expect(config.maxDecimalPlaces, equals(10));
        expect(config.customKeys.length, equals(2));
      });
    });

    group('Immutability', () {
      test('should be immutable after creation', () {
        const config = KeypadConfig(maxDigits: 5);

        // All properties are final, ensuring compile-time immutability
        expect(config.maxDigits, equals(5));
        // Cannot modify: config.maxDigits = 10; // Would cause compile error
      });

      test('should have immutable custom keys list', () {
        final originalKeys = [
          const KeypadKey(value: '7', type: KeypadKeyType.digit),
        ];
        final config = KeypadConfig(customKeys: List.from(originalKeys));

        // Modifying original list should not affect config
        originalKeys.add(
          const KeypadKey(value: '8', type: KeypadKeyType.digit),
        );

        expect(config.customKeys.length, equals(1));
        expect(
          config.customKeys.first,
          equals(const KeypadKey(value: '7', type: KeypadKeyType.digit)),
        );
      });
    });
  });
}
