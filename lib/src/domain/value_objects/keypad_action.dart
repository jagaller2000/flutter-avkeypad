/// Represents an action performed on the keypad
class KeypadAction {
  const KeypadAction({
    required this.type,
    this.value,
    this.key,
  });

  /// The type of action performed
  final KeypadActionType type;

  /// The value associated with the action (for input actions)
  final String? value;

  /// The key that was pressed (optional context)
  final String? key;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KeypadAction &&
        other.type == type &&
        other.value == value &&
        other.key == key;
  }

  @override
  int get hashCode {
    return Object.hash(type, value, key);
  }

  @override
  String toString() {
    return 'KeypadAction(type: $type, value: $value, key: $key)';
  }
}

/// Enum representing different types of keypad actions
enum KeypadActionType {
  /// Add a digit to the input
  digitInput,

  /// Add a decimal point
  decimalInput,

  /// Remove the last character
  backspace,

  /// Clear all input
  clear,

  /// Toggle the sign (positive/negative)
  toggleSign,

  /// Cancel and dismiss the keypad
  cancel,

  /// Custom action
  custom,
}
