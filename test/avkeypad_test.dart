import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

void main() {
  group('AVKeypad Domain Tests', () {
    test('KeypadSession should have identity and lifecycle', () {
      final session1 = KeypadSession(
        id: 'session-1',
        config: const KeypadConfig(),
      );

      final session2 = KeypadSession(
        id: 'session-1',
        config: const KeypadConfig(),
      );

      // Same ID means same entity
      expect(session1, session2);
      expect(session1.isComplete, false);

      // Update state
      session1.updateState(const KeypadState(input: '123', isValid: true));
      expect(session1.isComplete, true);
    });

    test('KeypadState should handle basic input', () {
      const state = KeypadState(input: '123', isValid: true);

      expect(state.input, '123');
      expect(state.isValid, true);
      expect(state.numericValue, 123.0);
      expect(state.displayText, '123');
    });

    test('KeypadConfig should have default values', () {
      const config = KeypadConfig();

      expect(config.showDecimalKey, true);
      expect(config.showSignKey, false);
      expect(config.maxDecimalPlaces, 2);
      expect(config.decimalSeparator, '.');
    });

    test('ProcessKeypadInputUseCase should handle digit input', () {
      const useCase = ProcessKeypadInputUseCase();
      const config = KeypadConfig();
      const currentState = KeypadState();
      const action = KeypadAction(
        type: KeypadActionType.digitInput,
        value: '5',
      );

      final newState = useCase(
        currentState: currentState,
        action: action,
        config: config,
      );

      expect(newState.input, '5');
      expect(newState.isValid, true);
    });

    test('ProcessKeypadInputUseCase should handle decimal input', () {
      const useCase = ProcessKeypadInputUseCase();
      const config = KeypadConfig();
      const currentState = KeypadState(input: '123');
      const action = KeypadAction(type: KeypadActionType.decimalInput);

      final newState = useCase(
        currentState: currentState,
        action: action,
        config: config,
      );

      expect(newState.input, '123.');
      expect(newState.hasDecimal, true);
      expect(newState.isValid, true);
    });

    test('ProcessKeypadInputUseCase should handle backspace', () {
      const useCase = ProcessKeypadInputUseCase();
      const config = KeypadConfig();
      const currentState = KeypadState(input: '123');
      const action = KeypadAction(type: KeypadActionType.backspace);

      final newState = useCase(
        currentState: currentState,
        action: action,
        config: config,
      );

      expect(newState.input, '12');
      expect(newState.isValid, true);
    });

    test('ValidateKeypadInputUseCase should validate input correctly', () {
      const useCase = ValidateKeypadInputUseCase();
      const config = KeypadConfig(maxDigits: 3);
      const state = KeypadState(input: '1234');

      final validatedState = useCase(currentState: state, config: config);

      expect(validatedState.isValid, false);
      expect(validatedState.error, isA<MaxDigitsExceededError>());
      expect(validatedState.error!.message, 'Maximum 3 digits allowed');
    });

    test('KeypadKey should have correct properties', () {
      const key = KeypadKey(
        value: '5',
        type: KeypadKeyType.digit,
        displayText: 'Five',
      );

      expect(key.value, '5');
      expect(key.type, KeypadKeyType.digit);
      expect(key.display, 'Five');
      expect(key.isEnabled, true);
    });

    test('Domain errors should have proper structure', () {
      const maxDigitsError = MaxDigitsExceededError(5);
      expect(maxDigitsError.message, 'Maximum 5 digits allowed');
      expect(maxDigitsError.code, 'MAX_DIGITS_EXCEEDED');
      expect(maxDigitsError.maxDigits, 5);

      const zeroError = ZeroNotAllowedError();
      expect(zeroError.message, 'Zero is not allowed');
      expect(zeroError.code, 'ZERO_NOT_ALLOWED');

      const negativeError = NegativeNotAllowedError();
      expect(negativeError.message, 'Negative numbers are not allowed');
      expect(negativeError.code, 'NEGATIVE_NOT_ALLOWED');
    });
  });
}
