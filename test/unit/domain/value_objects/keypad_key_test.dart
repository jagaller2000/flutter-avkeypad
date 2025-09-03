import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

void main() {
  group('KeypadKey Value Object Tests', () {
    group('Constructor', () {
      test('should create key with required properties', () {
        const key = KeypadKey(
          value: '5',
          type: KeypadKeyType.digit,
        );

        expect(key.value, equals('5'));
        expect(key.type, equals(KeypadKeyType.digit));
        expect(key.displayText, isNull);
        expect(key.isEnabled, isTrue);
      });

      test('should create key with all properties', () {
        const key = KeypadKey(
          value: 'clear',
          type: KeypadKeyType.clear,
          displayText: 'C',
          isEnabled: false,
        );

        expect(key.value, equals('clear'));
        expect(key.type, equals(KeypadKeyType.clear));
        expect(key.displayText, equals('C'));
        expect(key.isEnabled, isFalse);
      });

      test('should default isEnabled to true', () {
        const key = KeypadKey(
          value: '0',
          type: KeypadKeyType.digit,
        );

        expect(key.isEnabled, isTrue);
      });
    });

    group('Display Property', () {
      test('should return value when displayText is null', () {
        const key = KeypadKey(
          value: '7',
          type: KeypadKeyType.digit,
        );

        expect(key.display, equals('7'));
      });

      test('should return displayText when provided', () {
        const key = KeypadKey(
          value: 'backspace',
          type: KeypadKeyType.backspace,
          displayText: '⌫',
        );

        expect(key.display, equals('⌫'));
      });

      test('should prefer displayText over value', () {
        const key = KeypadKey(
          value: 'long_internal_value',
          type: KeypadKeyType.custom,
          displayText: 'X',
        );

        expect(key.display, equals('X'));
        expect(key.value, equals('long_internal_value'));
      });
    });

    group('Key Types', () {
      test('should handle digit keys', () {
        for (int i = 0; i <= 9; i++) {
          final key = KeypadKey(
            value: i.toString(),
            type: KeypadKeyType.digit,
          );

          expect(key.type, equals(KeypadKeyType.digit));
          expect(key.value, equals(i.toString()));
        }
      });

      test('should handle decimal key', () {
        const key = KeypadKey(
          value: '.',
          type: KeypadKeyType.decimal,
          displayText: '.',
        );

        expect(key.type, equals(KeypadKeyType.decimal));
        expect(key.value, equals('.'));
        expect(key.display, equals('.'));
      });

      test('should handle backspace key', () {
        const key = KeypadKey(
          value: 'backspace',
          type: KeypadKeyType.backspace,
          displayText: '⌫',
        );

        expect(key.type, equals(KeypadKeyType.backspace));
        expect(key.display, equals('⌫'));
      });

      test('should handle clear key', () {
        const key = KeypadKey(
          value: 'clear',
          type: KeypadKeyType.clear,
          displayText: 'C',
        );

        expect(key.type, equals(KeypadKeyType.clear));
        expect(key.display, equals('C'));
      });

      test('should handle confirm key', () {
        const key = KeypadKey(
          value: 'confirm',
          type: KeypadKeyType.confirm,
          displayText: '✓',
        );

        expect(key.type, equals(KeypadKeyType.confirm));
        expect(key.display, equals('✓'));
      });

      test('should handle cancel key', () {
        const key = KeypadKey(
          value: 'cancel',
          type: KeypadKeyType.cancel,
          displayText: '✗',
        );

        expect(key.type, equals(KeypadKeyType.cancel));
        expect(key.display, equals('✗'));
      });

      test('should handle sign key', () {
        const key = KeypadKey(
          value: 'sign',
          type: KeypadKeyType.sign,
          displayText: '±',
        );

        expect(key.type, equals(KeypadKeyType.sign));
        expect(key.display, equals('±'));
      });

      test('should handle custom key', () {
        const key = KeypadKey(
          value: 'custom_action',
          type: KeypadKeyType.custom,
          displayText: 'Custom',
        );

        expect(key.type, equals(KeypadKeyType.custom));
        expect(key.display, equals('Custom'));
      });
    });

    group('Copy With Functionality', () {
      test('should copy with no changes', () {
        const original = KeypadKey(
          value: '5',
          type: KeypadKeyType.digit,
          displayText: 'Five',
          isEnabled: false,
        );
        final copied = original.copyWith();

        expect(copied, equals(original));
        expect(identical(copied, original), isFalse);
      });

      test('should copy with value change', () {
        const original = KeypadKey(
          value: '5',
          type: KeypadKeyType.digit,
        );
        final copied = original.copyWith(value: '6');

        expect(copied.value, equals('6'));
        expect(copied.type, equals(original.type));
        expect(copied.displayText, equals(original.displayText));
        expect(copied.isEnabled, equals(original.isEnabled));
      });

      test('should copy with type change', () {
        const original = KeypadKey(
          value: 'action',
          type: KeypadKeyType.custom,
        );
        final copied = original.copyWith(type: KeypadKeyType.clear);

        expect(copied.type, equals(KeypadKeyType.clear));
        expect(copied.value, equals(original.value));
      });

      test('should copy with displayText change', () {
        const original = KeypadKey(
          value: 'clear',
          type: KeypadKeyType.clear,
        );
        final copied = original.copyWith(displayText: 'CLEAR');

        expect(copied.displayText, equals('CLEAR'));
        expect(copied.display, equals('CLEAR'));
      });

      test('should copy with isEnabled change', () {
        const original = KeypadKey(
          value: '5',
          type: KeypadKeyType.digit,
          isEnabled: true,
        );
        final copied = original.copyWith(isEnabled: false);

        expect(copied.isEnabled, isFalse);
        expect(copied.value, equals(original.value));
      });

      test('should copy with multiple changes', () {
        const original = KeypadKey(
          value: '1',
          type: KeypadKeyType.digit,
        );
        final copied = original.copyWith(
          value: 'custom',
          type: KeypadKeyType.custom,
          displayText: 'Custom Action',
          isEnabled: false,
        );

        expect(copied.value, equals('custom'));
        expect(copied.type, equals(KeypadKeyType.custom));
        expect(copied.displayText, equals('Custom Action'));
        expect(copied.isEnabled, isFalse);
      });
    });

    group('Equality and Hash Code', () {
      test('should be equal when all properties match', () {
        const key1 = KeypadKey(
          value: '5',
          type: KeypadKeyType.digit,
          displayText: 'Five',
          isEnabled: true,
        );
        const key2 = KeypadKey(
          value: '5',
          type: KeypadKeyType.digit,
          displayText: 'Five',
          isEnabled: true,
        );

        expect(key1, equals(key2));
        expect(key1.hashCode, equals(key2.hashCode));
      });

      test('should not be equal when value differs', () {
        const key1 = KeypadKey(value: '5', type: KeypadKeyType.digit);
        const key2 = KeypadKey(value: '6', type: KeypadKeyType.digit);

        expect(key1, isNot(equals(key2)));
      });

      test('should not be equal when type differs', () {
        const key1 = KeypadKey(value: 'action', type: KeypadKeyType.clear);
        const key2 = KeypadKey(value: 'action', type: KeypadKeyType.custom);

        expect(key1, isNot(equals(key2)));
      });

      test('should not be equal when displayText differs', () {
        const key1 = KeypadKey(
          value: 'clear',
          type: KeypadKeyType.clear,
          displayText: 'C',
        );
        const key2 = KeypadKey(
          value: 'clear',
          type: KeypadKeyType.clear,
          displayText: 'Clear',
        );

        expect(key1, isNot(equals(key2)));
      });

      test('should not be equal when isEnabled differs', () {
        const key1 = KeypadKey(
          value: '5',
          type: KeypadKeyType.digit,
          isEnabled: true,
        );
        const key2 = KeypadKey(
          value: '5',
          type: KeypadKeyType.digit,
          isEnabled: false,
        );

        expect(key1, isNot(equals(key2)));
      });

      test('should be equal to itself', () {
        const key = KeypadKey(value: '5', type: KeypadKeyType.digit);
        expect(key, equals(key));
        expect(identical(key, key), isTrue);
      });

      test('should not be equal to different types', () {
        const key = KeypadKey(value: '5', type: KeypadKeyType.digit);
        expect(key, isNot(equals('string')));
        expect(key, isNot(equals(123)));
        expect(key, isNot(equals(null)));
      });
    });

    group('String Representation', () {
      test('should have meaningful toString', () {
        const key = KeypadKey(
          value: '5',
          type: KeypadKeyType.digit,
          displayText: 'Five',
          isEnabled: false,
        );

        final result = key.toString();

        expect(result, contains('KeypadKey'));
        expect(result, contains('5'));
        expect(result, contains('digit'));
        expect(result, contains('Five'));
        expect(result, contains('false'));
      });

      test('should include all properties in toString', () {
        const key = KeypadKey(
          value: 'clear',
          type: KeypadKeyType.clear,
        );

        final result = key.toString();

        expect(result, contains('value: clear'));
        expect(result, contains('type: KeypadKeyType.clear'));
        expect(result, contains('displayText: null'));
        expect(result, contains('isEnabled: true'));
      });
    });

    group('Common Key Patterns', () {
      test('should create standard number pad keys', () {
        final numberKeys = List.generate(10, (i) => 
          KeypadKey(value: i.toString(), type: KeypadKeyType.digit)
        );

        expect(numberKeys.length, equals(10));
        for (int i = 0; i < 10; i++) {
          expect(numberKeys[i].value, equals(i.toString()));
          expect(numberKeys[i].type, equals(KeypadKeyType.digit));
          expect(numberKeys[i].display, equals(i.toString()));
        }
      });

      test('should create action keys with symbols', () {
        const actionKeys = [
          KeypadKey(
            value: 'decimal',
            type: KeypadKeyType.decimal,
            displayText: '.',
          ),
          KeypadKey(
            value: 'backspace',
            type: KeypadKeyType.backspace,
            displayText: '⌫',
          ),
          KeypadKey(
            value: 'clear',
            type: KeypadKeyType.clear,
            displayText: 'C',
          ),
        ];

        expect(actionKeys[0].display, equals('.'));
        expect(actionKeys[1].display, equals('⌫'));
        expect(actionKeys[2].display, equals('C'));
      });

      test('should create disabled keys', () {
        const disabledKey = KeypadKey(
          value: '5',
          type: KeypadKeyType.digit,
          isEnabled: false,
        );

        expect(disabledKey.isEnabled, isFalse);
      });

      test('should create custom keys with special functionality', () {
        const customKeys = [
          KeypadKey(
            value: 'pi',
            type: KeypadKeyType.custom,
            displayText: 'π',
          ),
          KeypadKey(
            value: 'euler',
            type: KeypadKeyType.custom,
            displayText: 'e',
          ),
        ];

        expect(customKeys[0].display, equals('π'));
        expect(customKeys[1].display, equals('e'));
        expect(customKeys[0].type, equals(KeypadKeyType.custom));
        expect(customKeys[1].type, equals(KeypadKeyType.custom));
      });
    });

    group('Edge Cases', () {
      test('should handle empty string values', () {
        const key = KeypadKey(
          value: '',
          type: KeypadKeyType.custom,
          displayText: '',
        );

        expect(key.value, equals(''));
        expect(key.display, equals(''));
      });

      test('should handle very long string values', () {
        final longValue = 'a' * 1000;
        final longDisplay = 'b' * 1000;
        
        final key = KeypadKey(
          value: longValue,
          type: KeypadKeyType.custom,
          displayText: longDisplay,
        );

        expect(key.value, equals(longValue));
        expect(key.display, equals(longDisplay));
      });

      test('should handle Unicode characters', () {
        const key = KeypadKey(
          value: 'math_symbol',
          type: KeypadKeyType.custom,
          displayText: '∑',
        );

        expect(key.value, equals('math_symbol'));
        expect(key.display, equals('∑'));
      });

      test('should handle whitespace in values', () {
        const key = KeypadKey(
          value: '  space  ',
          type: KeypadKeyType.custom,
          displayText: ' ',
        );

        expect(key.value, equals('  space  '));
        expect(key.display, equals(' '));
      });
    });

    group('Immutability', () {
      test('should be immutable after creation', () {
        const key = KeypadKey(
          value: '5',
          type: KeypadKeyType.digit,
          isEnabled: true,
        );

        // All properties are final, ensuring compile-time immutability
        expect(key.value, equals('5'));
        expect(key.type, equals(KeypadKeyType.digit));
        expect(key.isEnabled, isTrue);
        // Cannot modify: key.value = '6'; // Would cause compile error
      });

      test('should be usable as const values', () {
        const key1 = KeypadKey(value: '5', type: KeypadKeyType.digit);
        const key2 = KeypadKey(value: '5', type: KeypadKeyType.digit);

        expect(identical(key1, key2), isTrue);
      });
    });

    group('Key Type Enum Coverage', () {
      test('should cover all key types', () {
        final allKeyTypes = [
          KeypadKeyType.digit,
          KeypadKeyType.decimal,
          KeypadKeyType.backspace,
          KeypadKeyType.clear,
          KeypadKeyType.confirm,
          KeypadKeyType.cancel,
          KeypadKeyType.sign,
          KeypadKeyType.custom,
        ];

        for (final keyType in allKeyTypes) {
          final key = KeypadKey(
            value: 'test',
            type: keyType,
          );
          expect(key.type, equals(keyType));
        }
      });
    });
  });
}
