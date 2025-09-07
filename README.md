# avkeypad

A Flutter package providing customizable numeric keypad widgets designed for aviation and professional applications where precise numeric input is critical.

[![codecov](https://codecov.io/github/jagaller2000/flutter-avkeypad/graph/badge.svg?token=CRB3KCA530)](https://codecov.io/github/jagaller2000/flutter-avkeypad)

## Features

- **Multiple Layout Options**: Compact and traditional keypad layouts
- **Hardware Keyboard Support**: Full support for physical keyboard input as fallback
- **Highly Configurable**: Control which keys are shown and how input is validated
- **Input Validation**: Built-in support for step sizes, decimal limits, and range constraints
- **Aviation-Focused**: Designed for professional applications requiring precise numeric input
- **Clean Architecture**: Follows hexagonal architecture principles for maintainability
- **Comprehensive Testing**: High test coverage for reliable behavior

## Getting Started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  avkeypad: ^0.0.1
```

Then import the package:

```dart
import 'package:avkeypad/avkeypad.dart';
```

## Basic Usage

### Simple Numeric Keypad

```dart
import 'package:flutter/material.dart';
import 'package:avkeypad/avkeypad.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String currentValue = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Current Value: $currentValue'),
          NumericKeypad(
            onValueChanged: (value) {
              setState(() {
                currentValue = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
```

### Compact Layout

For space-constrained interfaces, use the compact layout with action buttons integrated around the display:

```dart
CompactKeypadWidget(
  config: KeypadConfig(
    showDecimalKey: true,
    showClearKey: true,
    showBackspaceKey: true,
  ),
  onValueChanged: (value) {
    print('Value: $value');
  },
)
```

### Traditional Layout

For more traditional calculator-style layouts:

```dart
TraditionalKeypadWidget(
  config: KeypadConfig(
    showDecimalKey: true,
    showSignKey: true,
    showClearKey: true,
  ),
  onValueChanged: (value) {
    print('Value: $value');
  },
)
```

## Hardware Keyboard Support

All keypad widgets include built-in hardware keyboard support as a fallback for users. This feature is enabled by default and automatically handles physical keyboard input.

### Supported Keys

The hardware keyboard support maps the following keys to keypad actions:

- **Digit Keys (0-9)**: Main keyboard and numpad digits for input
- **Decimal Point**: Period (.), comma (,), and numpad decimal for decimal input
- **Backspace**: Removes the last entered character
- **Escape**: Clears all input (same as Clear button)
- **Minus (-)**: Toggles positive/negative sign (same as ± button)

### Configuration

```dart
NumericKeypad(
  enableHardwareKeyboard: true,  // Enable/disable hardware keyboard (default: true)
  autofocus: true,               // Auto-focus for keyboard input (default: true)
  onValueChanged: (value) {
    print('Value from keyboard or touch: $value');
  },
)
```

### Usage Tips

- **Focus**: Click on the keypad to ensure it receives keyboard input
- **Accessibility**: Hardware keyboard support improves accessibility for users who prefer keyboard navigation
- **Fallback**: Provides a seamless fallback when touch input is unavailable or inconvenient
- **Aviation Use**: Particularly useful in cockpit environments where keyboard input may be preferred

### Disabling Hardware Keyboard

If you need to disable hardware keyboard support:

```dart
NumericKeypad(
  enableHardwareKeyboard: false,
  // ... other configuration
)
```

## Configuration Options

The `KeypadConfig` class provides extensive customization options:

### Key Visibility

```dart
KeypadConfig(
  showDecimalKey: true,      // Show decimal point key
  showSignKey: false,        // Show +/- toggle key
  showClearKey: true,        // Show clear all key
  showBackspaceKey: true,    // Show backspace key
  showCancelKey: false,      // Show cancel/dismiss key
)
```

### Input Validation

```dart
KeypadConfig(
  maxDigits: 8,              // Maximum total digits
  maxDecimalPlaces: 2,       // Maximum decimal places
  allowNegative: true,       // Allow negative numbers
  allowZero: true,           // Allow zero values
  stepSize: 0.25,           // Only allow multiples of 0.25
  decimalSeparator: '.',     // Decimal separator character
)
```

### Advanced Configuration Examples

#### Aviation Frequency Input (118.000 - 136.975 MHz)

```dart
KeypadConfig(
  maxDigits: 6,
  maxDecimalPlaces: 3,
  allowNegative: false,
  stepSize: 0.025,  // 25 kHz steps
  showSignKey: false,
  showDecimalKey: true,
)
```

#### Integer-Only Input

```dart
KeypadConfig(
  showDecimalKey: false,
  maxDigits: 5,
  allowNegative: false,
)
```

#### Currency Input

```dart
KeypadConfig(
  maxDecimalPlaces: 2,
  stepSize: 0.01,
  showSignKey: true,
  allowNegative: true,
)
```

## Callbacks

### Value Changes

```dart
NumericKeypad(
  onValueChanged: (String value) {
    // Called whenever the input value changes
    print('New value: $value');
  },
)
```

### Key Presses

```dart
NumericKeypad(
  onKeyPressed: (KeypadKey key) {
    // Called for each key press
    print('Key pressed: ${key.value}');
  },
)
```

### Cancel Action

```dart
NumericKeypad(
  config: KeypadConfig(showCancelKey: true),
  onCancel: () {
    // Called when cancel key is pressed
    Navigator.of(context).pop();
  },
)
```

## Custom Styling

### Custom Key Builder

```dart
NumericKeypad(
  keyBuilder: (KeypadKey key, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      child: Text(key.displayText ?? key.value),
    );
  },
)
```

### Custom Display Widget

```dart
CompactKeypadWidget(
  displayWidget: Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      currentValue,
      style: TextStyle(fontSize: 24),
    ),
  ),
)
```

## Widget Types

### NumericKeypad

A flexible numeric keypad that automatically selects the appropriate layout adapter. Includes built-in hardware keyboard support.

```dart
NumericKeypad(
  config: KeypadConfig(),
  enableHardwareKeyboard: true,  // Hardware keyboard support (default: true)
  onValueChanged: (value) => print(value),
)
```

### CompactKeypadWidget

Space-efficient layout with action buttons integrated around the display area. Also supports hardware keyboard input.

```dart
CompactKeypadWidget(
  config: KeypadConfig(),
  enableHardwareKeyboard: true,  // Hardware keyboard support (default: true)
  onValueChanged: (value) => print(value),
)
```

### TraditionalKeypadWidget

Traditional calculator-style layout with action buttons in a separate bottom row. Hardware keyboard support included.

```dart
TraditionalKeypadWidget(
  config: KeypadConfig(),
  enableHardwareKeyboard: true,  // Hardware keyboard support (default: true)
  onValueChanged: (value) => print(value),
)
```

### KeypadLayoutWidget

Low-level widget for custom layout implementations.

### HardwareKeyboardKeypad

A wrapper widget that adds hardware keyboard support to any widget. Useful for creating custom keypad implementations.

```dart
HardwareKeyboardKeypad(
  onKeypadAction: (action) {
    // Handle KeypadAction from keyboard input
    print('Action: ${action.type}, Value: ${action.value}');
  },
  enabled: true,
  autofocus: true,
  child: YourCustomWidget(),
)
```

## Input Validation

The package includes built-in validation for common use cases:

### Step Size Validation

```dart
// Only allow multiples of 0.5
KeypadConfig(stepSize: 0.5)

// Only allow even numbers
KeypadConfig(stepSize: 2.0)

// Quarter increments
KeypadConfig(stepSize: 0.25)
```

### Range Constraints

While the keypad itself doesn't enforce ranges, you can combine it with validation:

```dart
onValueChanged: (value) {
  final numValue = double.tryParse(value);
  if (numValue != null && numValue >= 100 && numValue <= 200) {
    // Valid range
    setState(() => currentValue = value);
  }
}
```

## Architecture

This package follows hexagonal architecture principles:

- **Domain Layer**: Core business logic and value objects
- **Infrastructure Layer**: Layout adapters and concrete implementations  
- **Presentation Layer**: Flutter widgets and UI components

This design ensures the package is testable, maintainable, and flexible for future enhancements.

## Contributing

Contributions are welcome! Please read the contributing guidelines and ensure all tests pass before submitting a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.