import '../errors/domain_errors.dart';
import '../value_objects/keypad_action.dart';
import '../value_objects/keypad_config.dart';
import '../value_objects/keypad_state.dart';
import 'validate_keypad_input_usecase.dart';

/// Use case for processing keypad input and managing state
class ProcessKeypadInputUseCase {
  const ProcessKeypadInputUseCase();

  static const _validator = ValidateKeypadInputUseCase();

  /// Process a keypad action and return the new state
  KeypadState call({
    required KeypadState currentState,
    required KeypadAction action,
    required KeypadConfig config,
  }) {
    KeypadState newState;
    
    switch (action.type) {
      case KeypadActionType.digitInput:
        newState = _handleDigitInput(currentState, action.value!, config);
        break;

      case KeypadActionType.decimalInput:
        newState = _handleDecimalInput(currentState, config);
        break;

      case KeypadActionType.backspace:
        newState = _handleBackspace(currentState, config);
        break;

      case KeypadActionType.clear:
        newState = _handleClear();
        break;

      case KeypadActionType.toggleSign:
        newState = _handleToggleSign(currentState, config);
        break;

      case KeypadActionType.confirm:
      case KeypadActionType.cancel:
      case KeypadActionType.custom:
        // These actions don't modify the state, they're handled by the UI layer
        return currentState;
    }

    // For digit input that would violate constraints, return error state without changing input
    if (action.type == KeypadActionType.digitInput && 
        identical(newState, currentState)) {
      // Check if this was due to max digits constraint
      if (config.maxDigits != null) {
        final testInput = currentState.input + action.value!;
        final digitsOnly = testInput.replaceAll(RegExp(r'[^\d]'), '');
        if (digitsOnly.length > config.maxDigits!) {
          return currentState.copyWith(
            isValid: false,
            error: () => MaxDigitsExceededError(config.maxDigits!),
          );
        }
      }
    }

    // Apply validation to the new state
    return _validator(currentState: newState, config: config);
  }

  KeypadState _handleDigitInput(
    KeypadState currentState,
    String digit,
    KeypadConfig config,
  ) {
    final newInput = currentState.input + digit;

    // Check max digits constraint - don't allow addition if it would exceed
    if (config.maxDigits != null) {
      final digitsOnly = newInput.replaceAll(RegExp(r'[^\d]'), '');
      if (digitsOnly.length > config.maxDigits!) {
        // Return unchanged state (will be handled by main call method)
        return currentState;
      }
    }

    return currentState.copyWith(input: newInput);
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
    );
  }

  KeypadState _handleBackspace(KeypadState currentState, KeypadConfig config) {
    if (currentState.input.isEmpty) {
      return currentState;
    }

    final newInput = currentState.input.substring(
      0,
      currentState.input.length - 1,
    );
    final hasDecimal = newInput.contains(config.decimalSeparator);
    final isNegative = newInput.startsWith('-');

    return currentState.copyWith(
      input: newInput,
      hasDecimal: hasDecimal,
      isNegative: isNegative,
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
    );
  }
}
