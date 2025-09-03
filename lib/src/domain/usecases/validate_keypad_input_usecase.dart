import '../errors/domain_errors.dart';
import '../value_objects/keypad_config.dart';
import '../value_objects/keypad_state.dart';

/// Use case for validating keypad input according to configuration rules
class ValidateKeypadInputUseCase {
  const ValidateKeypadInputUseCase();

  /// Validate the current keypad state according to config rules
  KeypadState call({
    required KeypadState currentState,
    required KeypadConfig config,
  }) {
    if (currentState.input.isEmpty) {
      return currentState.copyWith(isValid: true, error: () => null);
    }

    // Normalize the input for parsing by replacing custom decimal separator with standard '.'
    final normalizedInput = currentState.input.replaceAll(
      config.decimalSeparator,
      '.',
    );

    // Parse the numeric value
    final numericValue = double.tryParse(normalizedInput);
    if (numericValue == null) {
      return currentState.copyWith(
        isValid: false,
        error: () => const InvalidNumberFormatError(),
      );
    }

    // Check if zero is allowed
    if (!config.allowZero && numericValue == 0.0) {
      return currentState.copyWith(
        isValid: false,
        error: () => const ZeroNotAllowedError(),
      );
    }

    // Check if negative is allowed
    if (!config.allowNegative && numericValue < 0) {
      return currentState.copyWith(
        isValid: false,
        error: () => const NegativeNotAllowedError(),
      );
    }

    // Check decimal places
    if (currentState.hasDecimal &&
        currentState.input.contains(config.decimalSeparator)) {
      final parts = currentState.input.split(config.decimalSeparator);
      if (parts.length == 2) {
        final decimalPart = parts[1];
        if (decimalPart.length > config.maxDecimalPlaces) {
          return currentState.copyWith(
            isValid: false,
            error: () => MaxDecimalPlacesExceededError(config.maxDecimalPlaces),
          );
        }
      }
    }

    // Check max digits
    if (config.maxDigits != null) {
      final digitsOnly = currentState.input.replaceAll(RegExp(r'[^\d]'), '');
      if (digitsOnly.length > config.maxDigits!) {
        return currentState.copyWith(
          isValid: false,
          error: () => MaxDigitsExceededError(config.maxDigits!),
        );
      }
    }

    // Check step size constraint
    if (config.stepSize != null) {
      final stepSizeError = _validateStepSize(numericValue, config.stepSize!);
      if (stepSizeError != null) {
        return currentState.copyWith(
          isValid: false,
          error: () => stepSizeError,
        );
      }
    }

    return currentState.copyWith(isValid: true, error: () => null);
  }

  /// Validates if a value conforms to the step size constraint
  DomainError? _validateStepSize(double value, double stepSize) {
    // Handle edge case where step size is effectively zero
    if (stepSize <= 0) {
      return null; // No constraint
    }

    // Calculate the remainder when dividing by step size
    final remainder = value % stepSize;

    // Use a small epsilon for floating point comparison
    const epsilon = 1e-10;

    // Check if the remainder is effectively zero (within epsilon)
    // or if it's effectively equal to stepSize (for negative remainders)
    final isValid =
        remainder.abs() < epsilon || (stepSize - remainder).abs() < epsilon;

    if (!isValid) {
      return StepSizeViolationError(stepSize, value);
    }

    return null;
  }

  /// Check if a specific action would be valid without applying it
  bool isActionValid({
    required KeypadState currentState,
    required String actionValue,
    required KeypadConfig config,
  }) {
    // Simulate the action
    final simulatedInput = currentState.input + actionValue;
    final simulatedState = currentState.copyWith(input: simulatedInput);

    final validatedState = call(currentState: simulatedState, config: config);

    return validatedState.isValid;
  }
}
