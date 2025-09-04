import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

void main() {
  group('KeypadAction Value Object Tests', () {
    group('Constructor', () {
      test('should create action with required type', () {
        const action = KeypadAction(type: KeypadActionType.clear);

        expect(action.type, equals(KeypadActionType.clear));
        expect(action.value, isNull);
        expect(action.key, isNull);
      });

      test('should create action with all properties', () {
        const action = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '5',
          key: 'digit_5',
        );

        expect(action.type, equals(KeypadActionType.digitInput));
        expect(action.value, equals('5'));
        expect(action.key, equals('digit_5'));
      });

      test('should create action with partial properties', () {
        const action = KeypadAction(
          type: KeypadActionType.custom,
          value: 'customValue',
        );

        expect(action.type, equals(KeypadActionType.custom));
        expect(action.value, equals('customValue'));
        expect(action.key, isNull);
      });
    });

    group('Action Types', () {
      test('should handle digit input action', () {
        const action = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '7',
        );

        expect(action.type, equals(KeypadActionType.digitInput));
        expect(action.value, equals('7'));
      });

      test('should handle decimal input action', () {
        const action = KeypadAction(type: KeypadActionType.decimalInput);

        expect(action.type, equals(KeypadActionType.decimalInput));
      });

      test('should handle backspace action', () {
        const action = KeypadAction(type: KeypadActionType.backspace);

        expect(action.type, equals(KeypadActionType.backspace));
      });

      test('should handle clear action', () {
        const action = KeypadAction(type: KeypadActionType.clear);

        expect(action.type, equals(KeypadActionType.clear));
      });

      test('should handle sign toggle action', () {
        const action = KeypadAction(type: KeypadActionType.toggleSign);

        expect(action.type, equals(KeypadActionType.toggleSign));
      });

      test('should handle confirm action', () {
        const action = KeypadAction(type: KeypadActionType.confirm);

        expect(action.type, equals(KeypadActionType.confirm));
      });

      test('should handle cancel action', () {
        const action = KeypadAction(type: KeypadActionType.cancel);

        expect(action.type, equals(KeypadActionType.cancel));
      });

      test('should handle custom action', () {
        const action = KeypadAction(
          type: KeypadActionType.custom,
          value: 'customCommand',
          key: 'special_key',
        );

        expect(action.type, equals(KeypadActionType.custom));
        expect(action.value, equals('customCommand'));
        expect(action.key, equals('special_key'));
      });
    });

    group('Equality and Hash Code', () {
      test('should be equal when all properties match', () {
        const action1 = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '5',
          key: 'digit_5',
        );
        const action2 = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '5',
          key: 'digit_5',
        );

        expect(action1, equals(action2));
        expect(action1.hashCode, equals(action2.hashCode));
      });

      test('should not be equal when type differs', () {
        const action1 = KeypadAction(type: KeypadActionType.clear);
        const action2 = KeypadAction(type: KeypadActionType.backspace);

        expect(action1, isNot(equals(action2)));
      });

      test('should not be equal when value differs', () {
        const action1 = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '5',
        );
        const action2 = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '6',
        );

        expect(action1, isNot(equals(action2)));
      });

      test('should not be equal when key differs', () {
        const action1 = KeypadAction(
          type: KeypadActionType.custom,
          key: 'key1',
        );
        const action2 = KeypadAction(
          type: KeypadActionType.custom,
          key: 'key2',
        );

        expect(action1, isNot(equals(action2)));
      });

      test('should be equal to itself', () {
        const action = KeypadAction(type: KeypadActionType.clear);
        expect(action, equals(action));
        expect(identical(action, action), isTrue);
      });

      test('should not be equal to different types', () {
        const action = KeypadAction(type: KeypadActionType.clear);
        expect(action, isNot(equals('string')));
        expect(action, isNot(equals(123)));
        expect(action, isNot(equals(null)));
      });
    });

    group('String Representation', () {
      test('should have meaningful toString', () {
        const action = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '5',
          key: 'digit_5',
        );

        final result = action.toString();

        expect(result, contains('KeypadAction'));
        expect(result, contains('digitInput'));
        expect(result, contains('5'));
        expect(result, contains('digit_5'));
      });

      test('should include null values in toString', () {
        const action = KeypadAction(type: KeypadActionType.clear);
        final result = action.toString();

        expect(result, contains('KeypadAction'));
        expect(result, contains('clear'));
        expect(result, contains('null'));
      });
    });

    group('Common Action Patterns', () {
      test('should create digit input actions for all digits', () {
        for (int i = 0; i <= 9; i++) {
          final action = KeypadAction(
            type: KeypadActionType.digitInput,
            value: i.toString(),
          );

          expect(action.type, equals(KeypadActionType.digitInput));
          expect(action.value, equals(i.toString()));
        }
      });

      test('should create navigation actions without values', () {
        const navigationActions = [
          KeypadAction(type: KeypadActionType.backspace),
          KeypadAction(type: KeypadActionType.clear),
          KeypadAction(type: KeypadActionType.confirm),
          KeypadAction(type: KeypadActionType.cancel),
        ];

        for (final action in navigationActions) {
          expect(action.value, isNull);
          expect(action.key, isNull);
        }
      });

      test('should create decimal action', () {
        const action = KeypadAction(
          type: KeypadActionType.decimalInput,
          value: '.',
        );

        expect(action.type, equals(KeypadActionType.decimalInput));
        expect(action.value, equals('.'));
      });

      test('should create sign toggle action', () {
        const action = KeypadAction(type: KeypadActionType.toggleSign);

        expect(action.type, equals(KeypadActionType.toggleSign));
      });
    });

    group('Edge Cases', () {
      test('should handle empty string values', () {
        const action = KeypadAction(
          type: KeypadActionType.custom,
          value: '',
          key: '',
        );

        expect(action.value, equals(''));
        expect(action.key, equals(''));
      });

      test('should handle very long string values', () {
        final longValue = 'a' * 1000;
        final longKey = 'b' * 1000;

        final action = KeypadAction(
          type: KeypadActionType.custom,
          value: longValue,
          key: longKey,
        );

        expect(action.value, equals(longValue));
        expect(action.key, equals(longKey));
      });

      test('should handle special characters in values', () {
        const action = KeypadAction(
          type: KeypadActionType.custom,
          value: '!@#\$%^&*()',
          key: 'special_chars',
        );

        expect(action.value, equals('!@#\$%^&*()'));
        expect(action.key, equals('special_chars'));
      });

      test('should handle Unicode characters', () {
        const action = KeypadAction(
          type: KeypadActionType.custom,
          value: '∑∏∆∇',
          key: 'math_symbols',
        );

        expect(action.value, equals('∑∏∆∇'));
        expect(action.key, equals('math_symbols'));
      });
    });

    group('Immutability', () {
      test('should be immutable after creation', () {
        const action = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '5',
        );

        // All properties are final, ensuring compile-time immutability
        expect(action.type, equals(KeypadActionType.digitInput));
        expect(action.value, equals('5'));
        // Cannot modify: action.type = KeypadActionType.clear; // Would cause compile error
      });

      test('should be usable as const values', () {
        const action1 = KeypadAction(type: KeypadActionType.clear);
        const action2 = KeypadAction(type: KeypadActionType.clear);

        expect(identical(action1, action2), isTrue);
      });
    });

    group('Action Type Enum Coverage', () {
      test('should cover all action types', () {
        final allActionTypes = [
          KeypadActionType.digitInput,
          KeypadActionType.decimalInput,
          KeypadActionType.backspace,
          KeypadActionType.clear,
          KeypadActionType.toggleSign,
          KeypadActionType.confirm,
          KeypadActionType.cancel,
          KeypadActionType.custom,
        ];

        for (final actionType in allActionTypes) {
          final action = KeypadAction(type: actionType);
          expect(action.type, equals(actionType));
        }
      });
    });
  });
}
