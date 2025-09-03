import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

void main() {
  group('Step Size Validation Tests', () {
    late ValidateKeypadInputUseCase validateUseCase;

    setUp(() {
      validateUseCase = const ValidateKeypadInputUseCase();
    });

    group('Step Size 2.0 (Even Numbers)', () {
      const config = KeypadConfig(stepSize: 2.0, showDecimalKey: false);

      test('should accept even integers', () {
        for (final value in ['2', '4', '6', '8', '10', '100']) {
          final state = KeypadState(input: value);
          final result = validateUseCase(currentState: state, config: config);

          expect(result.isValid, true, reason: 'Value $value should be valid');
          expect(result.error, null);
        }
      });

      test('should reject odd integers', () {
        for (final value in ['1', '3', '5', '7', '9', '101']) {
          final state = KeypadState(input: value);
          final result = validateUseCase(currentState: state, config: config);

          expect(
            result.isValid,
            false,
            reason: 'Value $value should be invalid',
          );
          expect(result.error, isA<StepSizeViolationError>());
        }
      });

      test('should accept zero', () {
        final state = KeypadState(input: '0');
        final result = validateUseCase(currentState: state, config: config);

        expect(result.isValid, true);
        expect(result.error, null);
      });
    });

    group('Step Size 0.1 (Decimal Tenths)', () {
      const config = KeypadConfig(
        stepSize: 0.1,
        showDecimalKey: true,
        maxDecimalPlaces: 1,
      );

      test('should accept valid decimal tenths', () {
        for (final value in [
          '0.1',
          '0.2',
          '0.5',
          '1.0',
          '1.3',
          '2.7',
          '10.9',
        ]) {
          final state = KeypadState(input: value);
          final result = validateUseCase(currentState: state, config: config);

          expect(result.isValid, true, reason: 'Value $value should be valid');
          expect(result.error, null);
        }
      });

      test('should reject invalid decimal values', () {
        for (final value in ['0.15', '0.25', '1.23', '2.77']) {
          final state = KeypadState(input: value);
          final result = validateUseCase(currentState: state, config: config);

          expect(
            result.isValid,
            false,
            reason: 'Value $value should be invalid',
          );
          expect(result.error, isA<StepSizeViolationError>());
        }
      });

      test('should accept whole numbers that are multiples of 0.1', () {
        for (final value in ['1', '2', '5', '10']) {
          final state = KeypadState(input: value);
          final result = validateUseCase(currentState: state, config: config);

          expect(result.isValid, true, reason: 'Value $value should be valid');
          expect(result.error, null);
        }
      });
    });

    group('Step Size 0.25 (Quarter Increments)', () {
      const config = KeypadConfig(
        stepSize: 0.25,
        showDecimalKey: true,
        maxDecimalPlaces: 2,
      );

      test('should accept quarter increments', () {
        for (final value in ['0.25', '0.5', '0.75', '1.0', '1.25', '2.75']) {
          final state = KeypadState(input: value);
          final result = validateUseCase(currentState: state, config: config);

          expect(result.isValid, true, reason: 'Value $value should be valid');
          expect(result.error, null);
        }
      });

      test('should reject non-quarter values', () {
        for (final value in ['0.1', '0.2', '0.3', '0.6', '1.1', '2.3']) {
          final state = KeypadState(input: value);
          final result = validateUseCase(currentState: state, config: config);

          expect(
            result.isValid,
            false,
            reason: 'Value $value should be invalid',
          );
          expect(result.error, isA<StepSizeViolationError>());
        }
      });
    });

    group('Negative Values with Step Size', () {
      const config = KeypadConfig(
        stepSize: 2.0,
        allowNegative: true,
        showSignKey: true,
      );

      test('should accept negative even numbers', () {
        for (final value in ['-2', '-4', '-6', '-8', '-10']) {
          final state = KeypadState(input: value);
          final result = validateUseCase(currentState: state, config: config);

          expect(result.isValid, true, reason: 'Value $value should be valid');
          expect(result.error, null);
        }
      });

      test('should reject negative odd numbers', () {
        for (final value in ['-1', '-3', '-5', '-7', '-9']) {
          final state = KeypadState(input: value);
          final result = validateUseCase(currentState: state, config: config);

          expect(
            result.isValid,
            false,
            reason: 'Value $value should be invalid',
          );
          expect(result.error, isA<StepSizeViolationError>());
        }
      });
    });

    group('No Step Size Constraint', () {
      const config = KeypadConfig();

      test('should accept any valid number when stepSize is null', () {
        for (final value in ['1', '1.5', '2.33', '7.777', '123.456']) {
          final state = KeypadState(input: value);
          final result = validateUseCase(currentState: state, config: config);

          expect(result.isValid, true, reason: 'Value $value should be valid');
          expect(result.error, null);
        }
      });
    });

    group('Edge Cases', () {
      test('should handle zero step size as no constraint', () {
        const config = KeypadConfig(stepSize: 0.0);

        final state = KeypadState(input: '1.23');
        final result = validateUseCase(currentState: state, config: config);

        expect(result.isValid, true);
        expect(result.error, null);
      });

      test('should handle negative step size as no constraint', () {
        const config = KeypadConfig(stepSize: -1.0);

        final state = KeypadState(input: '1.23');
        final result = validateUseCase(currentState: state, config: config);

        expect(result.isValid, true);
        expect(result.error, null);
      });

      test('should handle very small step sizes', () {
        const config = KeypadConfig(stepSize: 0.001, maxDecimalPlaces: 3);

        final validState = KeypadState(input: '1.001');
        final validResult = validateUseCase(
          currentState: validState,
          config: config,
        );
        expect(validResult.isValid, true);

        final invalidState = KeypadState(input: '1.0015');
        final invalidResult = validateUseCase(
          currentState: invalidState,
          config: config,
        );
        expect(invalidResult.isValid, false);
        expect(invalidResult.error, isA<StepSizeViolationError>());
      });
    });
  });
}
