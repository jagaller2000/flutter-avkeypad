/// Represents a single key on the numeric keypad
class KeypadKey {
  const KeypadKey({
    required this.value,
    required this.type,
    this.displayText,
    this.isEnabled = true,
  });

  /// The actual value this key represents
  final String value;

  /// The type of key this represents
  final KeypadKeyType type;

  /// Optional custom display text (defaults to value if null)
  final String? displayText;

  /// Whether this key is currently enabled
  final bool isEnabled;

  /// The text to display on the key
  String get display => displayText ?? value;

  /// Creates a copy of this key with updated properties
  KeypadKey copyWith({
    String? value,
    KeypadKeyType? type,
    String? displayText,
    bool? isEnabled,
  }) {
    return KeypadKey(
      value: value ?? this.value,
      type: type ?? this.type,
      displayText: displayText ?? this.displayText,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KeypadKey &&
        other.value == value &&
        other.type == type &&
        other.displayText == displayText &&
        other.isEnabled == isEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(value, type, displayText, isEnabled);
  }

  @override
  String toString() {
    return 'KeypadKey(value: $value, type: $type, displayText: $displayText, isEnabled: $isEnabled)';
  }
}

/// Enum representing different types of keypad keys
enum KeypadKeyType {
  /// Numeric digit (0-9)
  digit,

  /// Decimal point separator
  decimal,

  /// Backspace/delete key
  backspace,

  /// Clear all input
  clear,

  /// Cancel/dismiss the keypad
  cancel,

  /// Plus/minus sign toggle
  sign,

  /// Custom action key
  custom,
}
