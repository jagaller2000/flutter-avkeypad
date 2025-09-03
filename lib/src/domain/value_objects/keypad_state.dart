import '../errors/domain_errors.dart';

/// Represents the current state and input value of the keypad
class KeypadState {
  const KeypadState({
    this.input = '',
    this.isValid = true,
    this.hasDecimal = false,
    this.isNegative = false,
    this.error,
  });

  /// The current input string
  final String input;

  /// Whether the current input is valid
  final bool isValid;

  /// Whether the input contains a decimal point
  final bool hasDecimal;

  /// Whether the input is negative
  final bool isNegative;

  /// Domain error if input is invalid
  final DomainError? error;

  /// Returns the numeric value of the input, or null if invalid
  double? get numericValue {
    if (input.isEmpty || !isValid) return null;
    return double.tryParse(input);
  }

  /// Returns whether the input is empty
  bool get isEmpty => input.isEmpty;

  /// Returns whether the input is not empty
  bool get isNotEmpty => input.isNotEmpty;

  /// Returns the display text for the current input
  String get displayText => input.isEmpty ? '0' : input;

  /// Creates a copy of this state with updated properties
  KeypadState copyWith({
    String? input,
    bool? isValid,
    bool? hasDecimal,
    bool? isNegative,
    DomainError? error,
  }) {
    return KeypadState(
      input: input ?? this.input,
      isValid: isValid ?? this.isValid,
      hasDecimal: hasDecimal ?? this.hasDecimal,
      isNegative: isNegative ?? this.isNegative,
      error: error ?? this.error,
    );
  }

  /// Creates a new state with cleared input
  KeypadState clear() {
    return const KeypadState();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KeypadState &&
        other.input == input &&
        other.isValid == isValid &&
        other.hasDecimal == hasDecimal &&
        other.isNegative == isNegative &&
        other.error == error;
  }

  @override
  int get hashCode {
    return Object.hash(input, isValid, hasDecimal, isNegative, error);
  }

  @override
  String toString() {
    return 'KeypadState('
        'input: $input, '
        'isValid: $isValid, '
        'hasDecimal: $hasDecimal, '
        'isNegative: $isNegative, '
        'error: $error)';
  }
}
