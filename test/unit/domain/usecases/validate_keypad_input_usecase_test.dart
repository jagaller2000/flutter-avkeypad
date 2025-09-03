import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

void main() {
  group('ValidateKeypadInputUseCase Tests', () {
    late ValidateKeypadInputUseCase useCase;

    setUp(() {
      useCase = const ValidateKeypadInputUseCase();
    });

    group('Empty Input Validation', () {
      test('should validate empty input as valid', () {
        const state = KeypadState(input: '');
        const config = KeypadConfig();

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
        expect(result.input, isEmpty);
      });

      test('should clear previous errors for empty input', () {
        const state = KeypadState(
          input: '',
          isValid: false,
          error: MaxDigitsExceededError(5),
        );
        const config = KeypadConfig();

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
        expect(result.input, isEmpty);
      });
    });

    group('Number Format Validation', () {
      test('should validate valid integer input', () {
        const state = KeypadState(input: '123');
        const config = KeypadConfig();

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should validate valid decimal input', () {
        const state = KeypadState(input: '123.45', hasDecimal: true);
        const config = KeypadConfig();

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should validate valid negative input', () {
        const state = KeypadState(input: '-123', isNegative: true);
        const config = KeypadConfig(allowNegative: true);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should invalidate non-numeric input', () {
        const state = KeypadState(input: 'abc');
        const config = KeypadConfig();

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isFalse);
        expect(result.error, isA<InvalidNumberFormatError>());
      });

      test('should invalidate mixed alphanumeric input', () {
        const state = KeypadState(input: '123abc');
        const config = KeypadConfig();

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isFalse);
        expect(result.error, isA<InvalidNumberFormatError>());
      });

      test('should validate zero', () {
        const state = KeypadState(input: '0');
        const config = KeypadConfig(allowZero: true);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });
    });

    group('Zero Validation', () {
      test('should allow zero when config permits', () {
        const state = KeypadState(input: '0');
        const config = KeypadConfig(allowZero: true);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should reject zero when config prohibits', () {
        const state = KeypadState(input: '0');
        const config = KeypadConfig(allowZero: false);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isFalse);
        expect(result.error, isA<ZeroNotAllowedError>());
      });

      test('should reject zero in decimal form when prohibited', () {
        const state = KeypadState(input: '0.0', hasDecimal: true);
        const config = KeypadConfig(allowZero: false);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isFalse);
        expect(result.error, isA<ZeroNotAllowedError>());
      });

      test('should reject negative zero when zero prohibited', () {
        const state = KeypadState(input: '-0', isNegative: true);
        const config = KeypadConfig(allowZero: false, allowNegative: true);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isFalse);
        expect(result.error, isA<ZeroNotAllowedError>());
      });
    });

    group('Negative Number Validation', () {
      test('should allow negative when config permits', () {
        const state = KeypadState(input: '-123', isNegative: true);
        const config = KeypadConfig(allowNegative: true);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should reject negative when config prohibits', () {
        const state = KeypadState(input: '-123', isNegative: true);
        const config = KeypadConfig(allowNegative: false);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isFalse);
        expect(result.error, isA<NegativeNotAllowedError>());
      });

      test('should reject negative decimal when prohibited', () {
        const state = KeypadState(
          input: '-123.45',
          isNegative: true,
          hasDecimal: true,
        );
        const config = KeypadConfig(allowNegative: false);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isFalse);
        expect(result.error, isA<NegativeNotAllowedError>());
      });
    });

    group('Decimal Places Validation', () {
      test('should allow decimals within limit', () {
        const state = KeypadState(input: '123.45', hasDecimal: true);
        const config = KeypadConfig(maxDecimalPlaces: 2);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should reject decimals exceeding limit', () {
        const state = KeypadState(input: '123.456', hasDecimal: true);
        const config = KeypadConfig(maxDecimalPlaces: 2);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isFalse);
        expect(result.error, isA<MaxDecimalPlacesExceededError>());
        expect((result.error as MaxDecimalPlacesExceededError).maxDecimalPlaces, equals(2));
      });

      test('should allow zero decimal places', () {
        const state = KeypadState(input: '123', hasDecimal: false);
        const config = KeypadConfig(maxDecimalPlaces: 0);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should handle custom decimal separator', () {
        const state = KeypadState(input: '123,45', hasDecimal: true);
        const config = KeypadConfig(
          maxDecimalPlaces: 2,
          decimalSeparator: ',',
        );

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should reject too many decimal places with custom separator', () {
        const state = KeypadState(input: '123,456', hasDecimal: true);
        const config = KeypadConfig(
          maxDecimalPlaces: 2,
          decimalSeparator: ',',
        );

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isFalse);
        expect(result.error, isA<MaxDecimalPlacesExceededError>());
      });
    });

    group('Max Digits Validation', () {
      test('should allow digits within limit', () {
        const state = KeypadState(input: '12345');
        const config = KeypadConfig(maxDigits: 5);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should reject digits exceeding limit', () {
        const state = KeypadState(input: '123456');
        const config = KeypadConfig(maxDigits: 5);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isFalse);
        expect(result.error, isA<MaxDigitsExceededError>());
        expect((result.error as MaxDigitsExceededError).maxDigits, equals(5));
      });

      test('should count only digits for max limit', () {
        const state = KeypadState(input: '-123.45', isNegative: true, hasDecimal: true);
        const config = KeypadConfig(maxDigits: 5, allowNegative: true);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should reject when digits exceed limit in complex number', () {
        const state = KeypadState(input: '-123456.78', isNegative: true, hasDecimal: true);
        const config = KeypadConfig(maxDigits: 5, allowNegative: true);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isFalse);
        expect(result.error, isA<MaxDigitsExceededError>());
      });

      test('should handle null maxDigits as unlimited', () {
        const state = KeypadState(input: '123456789012345');
        const config = KeypadConfig(maxDigits: null);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });
    });

    group('Step Size Validation', () {
      test('should allow values that are valid multiples of step size', () {
        const state = KeypadState(input: '2.0');
        const config = KeypadConfig(stepSize: 0.5);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should reject values that violate step size', () {
        const state = KeypadState(input: '1.3');
        const config = KeypadConfig(stepSize: 0.5);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isFalse);
        expect(result.error, isA<StepSizeViolationError>());
        final error = result.error as StepSizeViolationError;
        expect(error.stepSize, equals(0.5));
        expect(error.value, equals(1.3));
      });

      test('should handle integer step sizes', () {
        const state = KeypadState(input: '4');
        const config = KeypadConfig(stepSize: 2.0);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should reject values not matching integer step', () {
        const state = KeypadState(input: '3');
        const config = KeypadConfig(stepSize: 2.0);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isFalse);
        expect(result.error, isA<StepSizeViolationError>());
      });

      test('should handle very small step sizes', () {
        const state = KeypadState(input: '0.001');
        const config = KeypadConfig(stepSize: 0.001);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should handle null stepSize as no constraint', () {
        const state = KeypadState(input: '1.23456789');
        const config = KeypadConfig(stepSize: null);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should handle negative step size as no constraint', () {
        const state = KeypadState(input: '1.5');
        const config = KeypadConfig(stepSize: -0.5);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should handle zero step size as no constraint', () {
        const state = KeypadState(input: '1.23456');
        const config = KeypadConfig(stepSize: 0.0);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });
    });

    group('Combined Validation Rules', () {
      test('should apply all validation rules together', () {
        const state = KeypadState(
          input: '123.45',
          hasDecimal: true,
        );
        const config = KeypadConfig(
          allowNegative: false,
          allowZero: true,
          maxDigits: 6,
          maxDecimalPlaces: 2,
          stepSize: 0.01,
        );

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should fail on first violated rule', () {
        const state = KeypadState(
          input: '-123.456',
          isNegative: true,
          hasDecimal: true,
        );
        const config = KeypadConfig(
          allowNegative: false,
          maxDecimalPlaces: 2,
        );

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isFalse);
        expect(result.error, isA<NegativeNotAllowedError>());
      });

      test('should validate complex valid input', () {
        const state = KeypadState(
          input: '-99.75',
          isNegative: true,
          hasDecimal: true,
        );
        const config = KeypadConfig(
          allowNegative: true,
          allowZero: true,
          maxDigits: 4,
          maxDecimalPlaces: 2,
          stepSize: 0.25,
        );

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });
    });

    group('Edge Cases', () {
      test('should handle floating point precision issues', () {
        const state = KeypadState(input: '0.1');
        const config = KeypadConfig(stepSize: 0.1);

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should handle very large numbers', () {
        const state = KeypadState(input: '999999999999999');
        const config = KeypadConfig();

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should handle very small numbers', () {
        const state = KeypadState(input: '0.00000001');
        const config = KeypadConfig();

        final result = useCase(currentState: state, config: config);

        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should preserve original state properties', () {
        const originalState = KeypadState(
          input: '123',
          isValid: false,
          hasDecimal: false,
          isNegative: false,
          error: MaxDigitsExceededError(2),
        );
        const config = KeypadConfig();

        final result = useCase(currentState: originalState, config: config);

        expect(result.input, equals(originalState.input));
        expect(result.hasDecimal, equals(originalState.hasDecimal));
        expect(result.isNegative, equals(originalState.isNegative));
        expect(result.isValid, isTrue); // Updated
        expect(result.error, isNull); // Updated
      });
    });

    group('Use Case Behavior', () {
      test('should be pure and stateless', () {
        const state = KeypadState(input: '123');
        const config = KeypadConfig();

        final result1 = useCase(currentState: state, config: config);
        final result2 = useCase(currentState: state, config: config);

        expect(result1, equals(result2));
        expect(result1.isValid, equals(result2.isValid));
        expect(result1.error, equals(result2.error));
      });

      test('should not modify input state', () {
        const originalState = KeypadState(input: '123', isValid: false);
        const config = KeypadConfig();

        useCase(currentState: originalState, config: config);

        // Original state should remain unchanged
        expect(originalState.input, equals('123'));
        expect(originalState.isValid, isFalse);
      });

      test('should not modify input config', () {
        const state = KeypadState(input: '123');
        const originalConfig = KeypadConfig(maxDigits: 5);

        useCase(currentState: state, config: originalConfig);

        // Original config should remain unchanged
        expect(originalConfig.maxDigits, equals(5));
      });
    });
  });
}
