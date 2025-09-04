import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

void main() {
  group('ProcessKeypadInputUseCase Tests', () {
    late ProcessKeypadInputUseCase useCase;

    setUp(() {
      useCase = const ProcessKeypadInputUseCase();
    });

    group('Digit Input Processing', () {
      test('should add digit to empty input', () {
        const currentState = KeypadState();
        const action = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '5',
        );
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('5'));
        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should append digit to existing input', () {
        const currentState = KeypadState(input: '12');
        const action = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '3',
        );
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('123'));
        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should handle all digits 0-9', () {
        for (int i = 0; i <= 9; i++) {
          const currentState = KeypadState(input: '1');
          final action = KeypadAction(
            type: KeypadActionType.digitInput,
            value: i.toString(),
          );
          const config = KeypadConfig();

          final result = useCase(
            currentState: currentState,
            action: action,
            config: config,
          );

          expect(result.input, equals('1${i}'));
          expect(result.isValid, isTrue);
        }
      });

      test('should respect max digits constraint', () {
        const currentState = KeypadState(input: '12345');
        const action = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '6',
        );
        const config = KeypadConfig(maxDigits: 5);

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('12345')); // Unchanged
        expect(result.isValid, isFalse);
        expect(result.error, isA<MaxDigitsExceededError>());
      });

      test('should count only digits for max constraint', () {
        const currentState = KeypadState(
          input: '-123.4',
          isNegative: true,
          hasDecimal: true,
        );
        const action = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '5',
        );
        const config = KeypadConfig(maxDigits: 5, allowNegative: true);

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('-123.45'));
        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should reject when adding digit would exceed max digits', () {
        const currentState = KeypadState(
          input: '1234',
          isNegative: false,
          hasDecimal: false,
        );
        const action = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '5',
        );
        const config = KeypadConfig(maxDigits: 4);

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('1234')); // Unchanged
        expect(result.isValid, isFalse);
        expect(result.error, isA<MaxDigitsExceededError>());
      });
    });

    group('Decimal Input Processing', () {
      test('should add decimal point to empty input', () {
        const currentState = KeypadState();
        const action = KeypadAction(type: KeypadActionType.decimalInput);
        const config = KeypadConfig(showDecimalKey: true);

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('0.'));
        expect(result.hasDecimal, isTrue);
        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should add decimal point to existing input', () {
        const currentState = KeypadState(input: '123');
        const action = KeypadAction(type: KeypadActionType.decimalInput);
        const config = KeypadConfig(showDecimalKey: true);

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('123.'));
        expect(result.hasDecimal, isTrue);
        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should not add decimal if already present', () {
        const currentState = KeypadState(input: '123.45', hasDecimal: true);
        const action = KeypadAction(type: KeypadActionType.decimalInput);
        const config = KeypadConfig(showDecimalKey: true);

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('123.45')); // Unchanged
        expect(result.hasDecimal, isTrue);
      });

      test('should not add decimal if not allowed by config', () {
        const currentState = KeypadState(input: '123');
        const action = KeypadAction(type: KeypadActionType.decimalInput);
        const config = KeypadConfig(showDecimalKey: false);

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('123')); // Unchanged
        expect(result.hasDecimal, isFalse);
      });

      test('should use custom decimal separator', () {
        const currentState = KeypadState(input: '123');
        const action = KeypadAction(type: KeypadActionType.decimalInput);
        const config = KeypadConfig(
          showDecimalKey: true,
          decimalSeparator: ',',
        );

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('123,'));
        expect(result.hasDecimal, isTrue);
      });

      test(
        'should add decimal with leading zero for empty input and custom separator',
        () {
          const currentState = KeypadState();
          const action = KeypadAction(type: KeypadActionType.decimalInput);
          const config = KeypadConfig(
            showDecimalKey: true,
            decimalSeparator: ',',
          );

          final result = useCase(
            currentState: currentState,
            action: action,
            config: config,
          );

          expect(result.input, equals('0,'));
          expect(result.hasDecimal, isTrue);
        },
      );
    });

    group('Backspace Processing', () {
      test('should remove last character', () {
        const currentState = KeypadState(input: '123');
        const action = KeypadAction(type: KeypadActionType.backspace);
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('12'));
        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should handle empty input gracefully', () {
        const currentState = KeypadState();
        const action = KeypadAction(type: KeypadActionType.backspace);
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, isEmpty);
        expect(result, equals(currentState));
      });

      test('should update decimal flag when removing decimal point', () {
        const currentState = KeypadState(input: '123.', hasDecimal: true);
        const action = KeypadAction(type: KeypadActionType.backspace);
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('123'));
        expect(result.hasDecimal, isFalse);
      });

      test('should update negative flag when removing negative sign', () {
        const currentState = KeypadState(input: '-1', isNegative: true);
        const action = KeypadAction(type: KeypadActionType.backspace);
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('-'));
        expect(result.isNegative, isTrue);
      });

      test('should handle complex number backspace', () {
        const currentState = KeypadState(
          input: '-123.45',
          isNegative: true,
          hasDecimal: true,
        );
        const action = KeypadAction(type: KeypadActionType.backspace);
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('-123.4'));
        expect(result.isNegative, isTrue);
        expect(result.hasDecimal, isTrue);
      });

      test('should clear error state when backspacing', () {
        const currentState = KeypadState(
          input: '123',
          isValid: false,
          error: MaxDigitsExceededError(2),
        );
        const action = KeypadAction(type: KeypadActionType.backspace);
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('12'));
        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });
    });

    group('Clear Processing', () {
      test('should reset to default state', () {
        const currentState = KeypadState(
          input: '123.45',
          isValid: false,
          hasDecimal: true,
          isNegative: false,
          error: MaxDigitsExceededError(2),
        );
        const action = KeypadAction(type: KeypadActionType.clear);
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, isEmpty);
        expect(result.isValid, isTrue);
        expect(result.hasDecimal, isFalse);
        expect(result.isNegative, isFalse);
        expect(result.error, isNull);
      });

      test('should clear complex state', () {
        const currentState = KeypadState(
          input: '-999.999',
          isValid: false,
          hasDecimal: true,
          isNegative: true,
          error: StepSizeViolationError(0.5, 999.999),
        );
        const action = KeypadAction(type: KeypadActionType.clear);
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result, equals(const KeypadState()));
      });

      test('should produce identical result to default constructor', () {
        const currentState = KeypadState(input: '123');
        const action = KeypadAction(type: KeypadActionType.clear);
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result, equals(const KeypadState()));
      });
    });

    group('Sign Toggle Processing', () {
      test('should add negative sign to positive number', () {
        const currentState = KeypadState(input: '123');
        const action = KeypadAction(type: KeypadActionType.toggleSign);
        const config = KeypadConfig(allowNegative: true);

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('-123'));
        expect(result.isNegative, isTrue);
        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should remove negative sign from negative number', () {
        const currentState = KeypadState(input: '-123', isNegative: true);
        const action = KeypadAction(type: KeypadActionType.toggleSign);
        const config = KeypadConfig(allowNegative: true);

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('123'));
        expect(result.isNegative, isFalse);
        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });

      test('should not toggle sign when negative not allowed', () {
        const currentState = KeypadState(input: '123');
        const action = KeypadAction(type: KeypadActionType.toggleSign);
        const config = KeypadConfig(allowNegative: false);

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('123')); // Unchanged
        expect(result.isNegative, isFalse);
        expect(result, equals(currentState));
      });

      test('should not toggle sign for empty input', () {
        const currentState = KeypadState();
        const action = KeypadAction(type: KeypadActionType.toggleSign);
        const config = KeypadConfig(allowNegative: true);

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, isEmpty); // Unchanged
        expect(result.isNegative, isFalse);
        expect(result, equals(currentState));
      });

      test('should toggle sign for decimal numbers', () {
        const currentState = KeypadState(input: '123.45', hasDecimal: true);
        const action = KeypadAction(type: KeypadActionType.toggleSign);
        const config = KeypadConfig(allowNegative: true);

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('-123.45'));
        expect(result.isNegative, isTrue);
        expect(result.hasDecimal, isTrue);
      });

      test('should clear error state when toggling sign', () {
        const currentState = KeypadState(
          input: '123',
          isValid: false,
          error: StepSizeViolationError(2.0, 123),
        );
        const action = KeypadAction(type: KeypadActionType.toggleSign);
        const config = KeypadConfig(allowNegative: true);

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('-123'));
        expect(result.isValid, isTrue);
        expect(result.error, isNull);
      });
    });

    group('Non-State-Modifying Actions', () {
      test('should not modify state for confirm action', () {
        const currentState = KeypadState(input: '123.45');
        const action = KeypadAction(type: KeypadActionType.confirm);
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result, equals(currentState));
        expect(identical(result, currentState), isTrue);
      });

      test('should not modify state for cancel action', () {
        const currentState = KeypadState(
          input: '123',
          isValid: false,
          error: MaxDigitsExceededError(2),
        );
        const action = KeypadAction(type: KeypadActionType.cancel);
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result, equals(currentState));
        expect(identical(result, currentState), isTrue);
      });

      test('should not modify state for custom action', () {
        const currentState = KeypadState(input: '123.45');
        const action = KeypadAction(
          type: KeypadActionType.custom,
          value: 'customValue',
        );
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result, equals(currentState));
        expect(identical(result, currentState), isTrue);
      });
    });

    group('Complex Input Sequences', () {
      test('should handle building a decimal number', () {
        const config = KeypadConfig();
        var state = const KeypadState();

        // Add '1'
        state = useCase(
          currentState: state,
          action: const KeypadAction(
            type: KeypadActionType.digitInput,
            value: '1',
          ),
          config: config,
        );
        expect(state.input, equals('1'));

        // Add '2'
        state = useCase(
          currentState: state,
          action: const KeypadAction(
            type: KeypadActionType.digitInput,
            value: '2',
          ),
          config: config,
        );
        expect(state.input, equals('12'));

        // Add decimal point
        state = useCase(
          currentState: state,
          action: const KeypadAction(type: KeypadActionType.decimalInput),
          config: config,
        );
        expect(state.input, equals('12.'));
        expect(state.hasDecimal, isTrue);

        // Add '3'
        state = useCase(
          currentState: state,
          action: const KeypadAction(
            type: KeypadActionType.digitInput,
            value: '3',
          ),
          config: config,
        );
        expect(state.input, equals('12.3'));

        // Toggle sign
        state = useCase(
          currentState: state,
          action: const KeypadAction(type: KeypadActionType.toggleSign),
          config: const KeypadConfig(allowNegative: true),
        );
        expect(state.input, equals('-12.3'));
        expect(state.isNegative, isTrue);
      });

      test('should handle error recovery sequence', () {
        const config = KeypadConfig(maxDigits: 2);
        var state = const KeypadState();

        // Add valid digits
        state = useCase(
          currentState: state,
          action: const KeypadAction(
            type: KeypadActionType.digitInput,
            value: '1',
          ),
          config: config,
        );
        state = useCase(
          currentState: state,
          action: const KeypadAction(
            type: KeypadActionType.digitInput,
            value: '2',
          ),
          config: config,
        );
        expect(state.input, equals('12'));
        expect(state.isValid, isTrue);

        // Try to add third digit (should fail)
        state = useCase(
          currentState: state,
          action: const KeypadAction(
            type: KeypadActionType.digitInput,
            value: '3',
          ),
          config: config,
        );
        expect(state.input, equals('12')); // Unchanged
        expect(state.isValid, isFalse);
        expect(state.error, isA<MaxDigitsExceededError>());

        // Backspace to recover
        state = useCase(
          currentState: state,
          action: const KeypadAction(type: KeypadActionType.backspace),
          config: config,
        );
        expect(state.input, equals('1'));
        expect(state.isValid, isTrue);
        expect(state.error, isNull);
      });
    });

    group('Use Case Behavior', () {
      test('should be pure and stateless', () {
        const currentState = KeypadState(input: '123');
        const action = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '4',
        );
        const config = KeypadConfig();

        final result1 = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );
        final result2 = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result1, equals(result2));
        expect(result1.input, equals(result2.input));
      });

      test('should not modify input parameters', () {
        const originalState = KeypadState(input: '123');
        const action = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '4',
        );
        const config = KeypadConfig();

        useCase(currentState: originalState, action: action, config: config);

        // Original parameters should remain unchanged
        expect(originalState.input, equals('123'));
      });
    });

    group('Edge Cases', () {
      test('should handle action with null value gracefully', () {
        const currentState = KeypadState(input: '123');
        const action = KeypadAction(type: KeypadActionType.clear);
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, isEmpty);
      });

      test('should handle very long input strings', () {
        final longInput = '1' * 50;
        final currentState = KeypadState(input: longInput);
        const action = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '9',
        );
        const config = KeypadConfig();

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals(longInput + '9'));
      });

      test('should preserve state flags correctly across operations', () {
        const currentState = KeypadState(
          input: '-123.45',
          isNegative: true,
          hasDecimal: true,
        );
        const action = KeypadAction(
          type: KeypadActionType.digitInput,
          value: '6',
        );
        const config = KeypadConfig(allowNegative: true);

        final result = useCase(
          currentState: currentState,
          action: action,
          config: config,
        );

        expect(result.input, equals('-123.456'));
        expect(result.isNegative, isTrue);
        expect(result.hasDecimal, isTrue);
      });
    });
  });
}
