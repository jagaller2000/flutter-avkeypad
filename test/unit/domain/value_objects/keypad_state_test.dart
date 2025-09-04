import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

void main() {
  group('KeypadState Value Object Tests', () {
    group('Constructor and Default Values', () {
      test('should create default empty state', () {
        const state = KeypadState();

        expect(state.input, equals(''));
        expect(state.isValid, isTrue);
        expect(state.hasDecimal, isFalse);
        expect(state.isNegative, isFalse);
        expect(state.error, isNull);
      });

      test('should create state with custom values', () {
        const error = ZeroNotAllowedError();
        const state = KeypadState(
          input: '123.45',
          isValid: false,
          hasDecimal: true,
          isNegative: true,
          error: error,
        );

        expect(state.input, equals('123.45'));
        expect(state.isValid, isFalse);
        expect(state.hasDecimal, isTrue);
        expect(state.isNegative, isTrue);
        expect(state.error, equals(error));
      });
    });

    group('Numeric Value Conversion', () {
      test('should return null for empty input', () {
        const state = KeypadState();
        expect(state.numericValue, isNull);
      });

      test('should return null for invalid state', () {
        const state = KeypadState(input: '123', isValid: false);
        expect(state.numericValue, isNull);
      });

      test('should parse valid positive integer', () {
        const state = KeypadState(input: '123', isValid: true);
        expect(state.numericValue, equals(123.0));
      });

      test('should parse valid positive decimal', () {
        const state = KeypadState(input: '123.45', isValid: true);
        expect(state.numericValue, equals(123.45));
      });

      test('should parse valid negative number', () {
        const state = KeypadState(input: '-123.45', isValid: true);
        expect(state.numericValue, equals(-123.45));
      });

      test('should parse zero', () {
        const state = KeypadState(input: '0', isValid: true);
        expect(state.numericValue, equals(0.0));
      });

      test('should handle decimal point only', () {
        const state = KeypadState(input: '.5', isValid: true);
        expect(state.numericValue, equals(0.5));
      });

      test('should return null for invalid number format', () {
        const state = KeypadState(input: 'abc', isValid: true);
        expect(state.numericValue, isNull);
      });
    });

    group('Empty State Checks', () {
      test('should correctly identify empty state', () {
        const state = KeypadState();
        expect(state.isEmpty, isTrue);
        expect(state.isNotEmpty, isFalse);
      });

      test('should correctly identify non-empty state', () {
        const state = KeypadState(input: '1');
        expect(state.isEmpty, isFalse);
        expect(state.isNotEmpty, isTrue);
      });

      test('should handle whitespace-only input', () {
        const state = KeypadState(input: '   ');
        expect(state.isEmpty, isFalse);
        expect(state.isNotEmpty, isTrue);
      });
    });

    group('Display Text', () {
      test('should display "0" for empty input', () {
        const state = KeypadState();
        expect(state.displayText, equals('0'));
      });

      test('should display actual input when not empty', () {
        const state = KeypadState(input: '123.45');
        expect(state.displayText, equals('123.45'));
      });

      test('should display negative numbers correctly', () {
        const state = KeypadState(input: '-123');
        expect(state.displayText, equals('-123'));
      });

      test('should display decimal point only', () {
        const state = KeypadState(input: '.');
        expect(state.displayText, equals('.'));
      });
    });

    group('Copy With Functionality', () {
      test('should copy with no changes', () {
        const original = KeypadState(input: '123', isValid: true);
        final copied = original.copyWith();

        expect(copied, equals(original));
        expect(identical(copied, original), isFalse);
      });

      test('should copy with input change', () {
        const original = KeypadState(input: '123');
        final copied = original.copyWith(input: '456');

        expect(copied.input, equals('456'));
        expect(copied.isValid, equals(original.isValid));
        expect(copied.hasDecimal, equals(original.hasDecimal));
        expect(copied.isNegative, equals(original.isNegative));
        expect(copied.error, equals(original.error));
      });

      test('should copy with validity change', () {
        const original = KeypadState(input: '123', isValid: true);
        final copied = original.copyWith(isValid: false);

        expect(copied.isValid, isFalse);
        expect(copied.input, equals(original.input));
      });

      test('should copy with decimal flag change', () {
        const original = KeypadState(hasDecimal: false);
        final copied = original.copyWith(hasDecimal: true);

        expect(copied.hasDecimal, isTrue);
        expect(copied.input, equals(original.input));
      });

      test('should copy with negative flag change', () {
        const original = KeypadState(isNegative: false);
        final copied = original.copyWith(isNegative: true);

        expect(copied.isNegative, isTrue);
        expect(copied.input, equals(original.input));
      });

      test('should copy with error change', () {
        const original = KeypadState();
        const error = MaxDigitsExceededError(5);
        final copied = original.copyWith(error: () => error);

        expect(copied.error, equals(error));
        expect(copied.input, equals(original.input));
      });

      test('should copy with multiple changes', () {
        const original = KeypadState();
        const error = InvalidNumberFormatError();
        final copied = original.copyWith(
          input: '123.45',
          isValid: false,
          hasDecimal: true,
          isNegative: true,
          error: () => error,
        );

        expect(copied.input, equals('123.45'));
        expect(copied.isValid, isFalse);
        expect(copied.hasDecimal, isTrue);
        expect(copied.isNegative, isTrue);
        expect(copied.error, equals(error));
      });
    });

    group('Clear Functionality', () {
      test('should clear to default state', () {
        const state = KeypadState(
          input: '123.45',
          isValid: false,
          hasDecimal: true,
          isNegative: true,
          error: MaxDigitsExceededError(5),
        );

        final cleared = state.clear();

        expect(cleared.input, equals(''));
        expect(cleared.isValid, isTrue);
        expect(cleared.hasDecimal, isFalse);
        expect(cleared.isNegative, isFalse);
        expect(cleared.error, isNull);
      });

      test('should return equivalent to default constructor', () {
        const state = KeypadState(input: '123');
        final cleared = state.clear();
        const defaultState = KeypadState();

        expect(cleared, equals(defaultState));
      });
    });

    group('Equality and Hash Code', () {
      test('should be equal when all properties match', () {
        const state1 = KeypadState(
          input: '123',
          isValid: true,
          hasDecimal: false,
          isNegative: false,
        );
        const state2 = KeypadState(
          input: '123',
          isValid: true,
          hasDecimal: false,
          isNegative: false,
        );

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when input differs', () {
        const state1 = KeypadState(input: '123');
        const state2 = KeypadState(input: '456');

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when validity differs', () {
        const state1 = KeypadState(input: '123', isValid: true);
        const state2 = KeypadState(input: '123', isValid: false);

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when decimal flag differs', () {
        const state1 = KeypadState(hasDecimal: true);
        const state2 = KeypadState(hasDecimal: false);

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when negative flag differs', () {
        const state1 = KeypadState(isNegative: true);
        const state2 = KeypadState(isNegative: false);

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when error differs', () {
        const state1 = KeypadState(error: ZeroNotAllowedError());
        const state2 = KeypadState(error: MaxDigitsExceededError(5));

        expect(state1, isNot(equals(state2)));
      });

      test('should be equal to itself', () {
        const state = KeypadState(input: '123');
        expect(state, equals(state));
        expect(identical(state, state), isTrue);
      });

      test('should not be equal to different types', () {
        const state = KeypadState();
        expect(state, isNot(equals('string')));
        expect(state, isNot(equals(123)));
        expect(state, isNot(equals(null)));
      });
    });

    group('String Representation', () {
      test('should have meaningful toString', () {
        const state = KeypadState(
          input: '123.45',
          isValid: false,
          hasDecimal: true,
          isNegative: true,
        );

        final result = state.toString();

        expect(result, contains('KeypadState'));
        expect(result, contains('123.45'));
        expect(result, contains('false'));
        expect(result, contains('true'));
      });

      test('should include all properties in toString', () {
        const error = MaxDigitsExceededError(5);
        const state = KeypadState(
          input: '123',
          isValid: true,
          hasDecimal: false,
          isNegative: false,
          error: error,
        );

        final result = state.toString();

        expect(result, contains('input: 123'));
        expect(result, contains('isValid: true'));
        expect(result, contains('hasDecimal: false'));
        expect(result, contains('isNegative: false'));
        expect(result, contains('error:'));
      });
    });

    group('Edge Cases', () {
      test('should handle very long input strings', () {
        final longInput = '1' * 1000;
        final state = KeypadState(input: longInput);

        expect(state.input, equals(longInput));
        expect(state.input.length, equals(1000));
      });

      test('should handle special numeric formats', () {
        const cases = ['0.0', '000', '.0', '0.', '-0', '1e10', '1.23e-4'];

        for (final input in cases) {
          final state = KeypadState(input: input, isValid: true);
          expect(state.input, equals(input));
        }
      });

      test('should handle Unicode characters', () {
        const state = KeypadState(input: '123①②③');
        expect(state.input, equals('123①②③'));
        expect(state.numericValue, isNull); // Invalid number format
      });

      test('should maintain immutability', () {
        const state = KeypadState(input: '123');

        // All properties are final, so this ensures compile-time immutability
        expect(state.input, equals('123'));
        // Cannot modify: state.input = '456'; // Would cause compile error
      });
    });

    group('State Flags Consistency', () {
      test('should maintain flag consistency with input', () {
        // Test various combinations to ensure flags make sense
        const testCases = [
          (input: '123.45', hasDecimal: true, isNegative: false),
          (input: '-123', hasDecimal: false, isNegative: true),
          (input: '-123.45', hasDecimal: true, isNegative: true),
          (input: '123', hasDecimal: false, isNegative: false),
          (input: '0', hasDecimal: false, isNegative: false),
        ];

        for (final testCase in testCases) {
          final state = KeypadState(
            input: testCase.input,
            hasDecimal: testCase.hasDecimal,
            isNegative: testCase.isNegative,
          );

          expect(state.hasDecimal, equals(testCase.hasDecimal));
          expect(state.isNegative, equals(testCase.isNegative));
        }
      });
    });
  });
}
