import '../errors/domain_errors.dart';
import '../value_objects/keypad_action.dart';
import '../value_objects/keypad_config.dart';
import '../value_objects/keypad_state.dart';

/// Use case for processing keypad input and managing state
class ProcessKeypadInputUseCase {
  const ProcessKeypadInputUseCase();

  /// Process a keypad action and return the new state
  KeypadState call({
    required KeypadState currentState,
    required KeypadAction action,
    required KeypadConfig config,
  }) {
    switch (action.type) {
      case KeypadActionType.digitInput:
        return _handleDigitInput(currentState, action.value!, config);

      case KeypadActionType.decimalInput:
        return _handleDecimalInput(currentState, config);

      case KeypadActionType.backspace:
        return _handleBackspace(currentState);

      case KeypadActionType.clear:
        return _handleClear();

      case KeypadActionType.toggleSign:
        return _handleToggleSign(currentState, config);

      case KeypadActionType.confirm:
      case KeypadActionType.cancel:
      case KeypadActionType.custom:
        // These actions don't modify the state, they're handled by the UI layer
        return currentState;
    }
  }

  KeypadState _handleDigitInput(
    KeypadState currentState,
    String digit,
    KeypadConfig config,
  ) {
    final newInput = currentState.input + digit;

    // Check max digits constraint
    if (config.maxDigits != null) {
      final digitsOnly = newInput.replaceAll(RegExp(r'[^\d]'), '');
      if (digitsOnly.length > config.maxDigits!) {
        return currentState.copyWith(
          isValid: false,
          error: MaxDigitsExceededError(config.maxDigits!),
        );
      }
    }

    return currentState.copyWith(input: newInput, isValid: true, error: null);
  }

  KeypadState _handleDecimalInput(
    KeypadState currentState,
    KeypadConfig config,
  ) {
    // Don't allow decimal if already present or not allowed
    if (currentState.hasDecimal || !config.showDecimalKey) {
      return currentState;
    }

    // Add decimal point (with leading zero if input is empty)
    final newInput = currentState.input.isEmpty
        ? '0${config.decimalSeparator}'
        : currentState.input + config.decimalSeparator;

    return currentState.copyWith(
      input: newInput,
      hasDecimal: true,
      isValid: true,
      error: null,
    );
  }

  KeypadState _handleBackspace(KeypadState currentState) {
    if (currentState.input.isEmpty) {
      return currentState;
    }

    final newInput = currentState.input.substring(
      0,
      currentState.input.length - 1,
    );
    final hasDecimal = newInput.contains('.');
    final isNegative = newInput.startsWith('-');

    return currentState.copyWith(
      input: newInput,
      hasDecimal: hasDecimal,
      isNegative: isNegative,
      isValid: true,
      error: null,
    );
  }

  KeypadState _handleClear() {
    return const KeypadState();
  }

  KeypadState _handleToggleSign(KeypadState currentState, KeypadConfig config) {
    // Don't allow negative if not allowed
    if (!config.allowNegative) {
      return currentState;
    }

    // Don't toggle sign for empty input
    if (currentState.input.isEmpty) {
      return currentState;
    }

    final newInput = currentState.isNegative
        ? currentState.input.substring(1) // Remove negative sign
        : '-${currentState.input}'; // Add negative sign

    return currentState.copyWith(
      input: newInput,
      isNegative: !currentState.isNegative,
      isValid: true,
      error: null,
    );
  }
}
