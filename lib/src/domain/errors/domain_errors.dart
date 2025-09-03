/// Base class for all domain errors
abstract class DomainError {
  const DomainError({required this.message, this.code});

  /// Human-readable error message
  final String message;

  /// Optional error code for programmatic handling
  final String? code;

  @override
  String toString() => message;
}

/// Error when input exceeds maximum allowed digits
class MaxDigitsExceededError extends DomainError {
  const MaxDigitsExceededError(this.maxDigits)
    : super(
        message: 'Maximum $maxDigits digits allowed',
        code: 'MAX_DIGITS_EXCEEDED',
      );

  final int maxDigits;
}

/// Error when input exceeds maximum decimal places
class MaxDecimalPlacesExceededError extends DomainError {
  const MaxDecimalPlacesExceededError(this.maxDecimalPlaces)
    : super(
        message: 'Maximum $maxDecimalPlaces decimal places allowed',
        code: 'MAX_DECIMAL_PLACES_EXCEEDED',
      );

  final int maxDecimalPlaces;
}

/// Error when zero is not allowed but provided
class ZeroNotAllowedError extends DomainError {
  const ZeroNotAllowedError()
    : super(message: 'Zero is not allowed', code: 'ZERO_NOT_ALLOWED');
}

/// Error when negative numbers are not allowed but provided
class NegativeNotAllowedError extends DomainError {
  const NegativeNotAllowedError()
    : super(
        message: 'Negative numbers are not allowed',
        code: 'NEGATIVE_NOT_ALLOWED',
      );
}

/// Error when input format is invalid
class InvalidNumberFormatError extends DomainError {
  const InvalidNumberFormatError()
    : super(message: 'Invalid number format', code: 'INVALID_NUMBER_FORMAT');
}

/// Error when decimal point is not allowed in current context
class DecimalNotAllowedError extends DomainError {
  const DecimalNotAllowedError()
    : super(
        message: 'Decimal point is not allowed',
        code: 'DECIMAL_NOT_ALLOWED',
      );
}

/// Error when sign toggle is not allowed in current context
class SignToggleNotAllowedError extends DomainError {
  const SignToggleNotAllowedError()
    : super(
        message: 'Sign toggle is not allowed',
        code: 'SIGN_TOGGLE_NOT_ALLOWED',
      );
}

/// Error when trying to add decimal but one already exists
class DecimalAlreadyExistsError extends DomainError {
  const DecimalAlreadyExistsError()
    : super(
        message: 'Decimal point already exists',
        code: 'DECIMAL_ALREADY_EXISTS',
      );
}

/// Error when input value doesn't conform to the required step size
class StepSizeViolationError extends DomainError {
  const StepSizeViolationError(this.stepSize, this.value)
    : super(
        message: 'Value $value is not a valid multiple of step size $stepSize',
        code: 'STEP_SIZE_VIOLATION',
      );

  final double stepSize;
  final double value;
}
