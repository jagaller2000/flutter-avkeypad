import 'keypad_key.dart';

/// Configuration for the keypad layout and behavior
class KeypadConfig {
  const KeypadConfig({
    this.showDecimalKey = true,
    this.showSignKey = false,
    this.showClearKey = true,
    this.showBackspaceKey = true,
    this.showCancelKey = false,
    this.maxDigits,
    this.maxDecimalPlaces = 2,
    this.allowNegative = false,
    this.allowZero = true,
    this.stepSize,
    this.decimalSeparator = '.',
    this.customKeys = const [],
  });

  /// Whether to show the decimal point key
  final bool showDecimalKey;

  /// Whether to show the +/- sign toggle key
  final bool showSignKey;

  /// Whether to show the clear all key
  final bool showClearKey;

  /// Whether to show the backspace key
  final bool showBackspaceKey;

  /// Whether to show the cancel/dismiss key
  final bool showCancelKey;

  /// Maximum number of digits allowed (null for no limit)
  final int? maxDigits;

  /// Maximum number of decimal places allowed
  final int maxDecimalPlaces;

  /// Whether negative numbers are allowed
  final bool allowNegative;

  /// Whether zero is allowed as a value
  final bool allowZero;

  /// Step size for numeric input validation (null for no step constraint)
  /// Examples: 2.0 (only even numbers), 0.1 (decimals to first place), 0.25 (quarters)
  final double? stepSize;

  /// The decimal separator character to use
  final String decimalSeparator;

  /// Additional custom keys to include
  final List<KeypadKey> customKeys;

  /// Creates a copy of this config with updated properties
  KeypadConfig copyWith({
    bool? showDecimalKey,
    bool? showSignKey,
    bool? showClearKey,
    bool? showBackspaceKey,
    bool? showCancelKey,
    int? maxDigits,
    int? maxDecimalPlaces,
    bool? allowNegative,
    bool? allowZero,
    double? stepSize,
    String? decimalSeparator,
    List<KeypadKey>? customKeys,
  }) {
    return KeypadConfig(
      showDecimalKey: showDecimalKey ?? this.showDecimalKey,
      showSignKey: showSignKey ?? this.showSignKey,
      showClearKey: showClearKey ?? this.showClearKey,
      showBackspaceKey: showBackspaceKey ?? this.showBackspaceKey,
      showCancelKey: showCancelKey ?? this.showCancelKey,
      maxDigits: maxDigits ?? this.maxDigits,
      maxDecimalPlaces: maxDecimalPlaces ?? this.maxDecimalPlaces,
      allowNegative: allowNegative ?? this.allowNegative,
      allowZero: allowZero ?? this.allowZero,
      stepSize: stepSize ?? this.stepSize,
      decimalSeparator: decimalSeparator ?? this.decimalSeparator,
      customKeys: customKeys ?? this.customKeys,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KeypadConfig &&
        other.showDecimalKey == showDecimalKey &&
        other.showSignKey == showSignKey &&
        other.showClearKey == showClearKey &&
        other.showBackspaceKey == showBackspaceKey &&
        other.showCancelKey == showCancelKey &&
        other.maxDigits == maxDigits &&
        other.maxDecimalPlaces == maxDecimalPlaces &&
        other.allowNegative == allowNegative &&
        other.allowZero == allowZero &&
        other.stepSize == stepSize &&
        other.decimalSeparator == decimalSeparator &&
        _listEquals(other.customKeys, customKeys);
  }

  @override
  int get hashCode {
    return Object.hash(
      showDecimalKey,
      showSignKey,
      showClearKey,
      showBackspaceKey,
      showCancelKey,
      maxDigits,
      maxDecimalPlaces,
      allowNegative,
      allowZero,
      stepSize,
      decimalSeparator,
      Object.hashAll(customKeys),
    );
  }

  @override
  String toString() {
    return 'KeypadConfig('
        'showDecimalKey: $showDecimalKey, '
        'showSignKey: $showSignKey, '
        'showClearKey: $showClearKey, '
        'showBackspaceKey: $showBackspaceKey, '
        'showCancelKey: $showCancelKey, '
        'maxDigits: $maxDigits, '
        'maxDecimalPlaces: $maxDecimalPlaces, '
        'allowNegative: $allowNegative, '
        'allowZero: $allowZero, '
        'stepSize: $stepSize, '
        'decimalSeparator: $decimalSeparator, '
        'customKeys: $customKeys)';
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    if (identical(a, b)) return true;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}
