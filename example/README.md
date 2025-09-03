# AVKeypad Demo Application

This demo application showcases the various features and configurations of the AVKeypad Flutter package.

## Structure

The demo application is organized into separate files for better maintainability and readability:

### `/lib/main.dart`
The main entry point of the application. Contains only the `MyApp` widget and minimal setup.

### `/lib/widgets/`
Contains reusable widgets and UI components:

- **`keypad_demo_base.dart`** - Base classes for all demo pages with common functionality
- **`keypad_demo_tabs.dart`** - Main tab navigation widget
- **`widgets.dart`** - Export file for all widgets

### `/lib/demos/`
Contains individual demo pages, each showcasing a specific keypad configuration:

- **`basic_keypad_demo.dart`** - Simple numeric keypad with minimal features
- **`decimal_keypad_demo.dart`** - Keypad with decimal point support
- **`signed_keypad_demo.dart`** - Keypad supporting positive and negative numbers
- **`limited_keypad_demo.dart`** - Keypad with input constraints and validation
- **`advanced_keypad_demo.dart`** - Keypad with all features enabled
- **`step_size_2_demo.dart`** - Keypad constrained to even numbers only
- **`step_size_decimal_demo.dart`** - Keypad constrained to 0.1 increments
- **`demos.dart`** - Export file for all demo pages

## Demo Features

Each demo page demonstrates different aspects of the keypad:

1. **Basic** - Essential number input functionality
2. **Decimal** - Decimal point support with precision control
3. **Signed** - Positive and negative number input
4. **Limited** - Input validation and constraints
5. **Advanced** - Comprehensive feature set
6. **Step 2** - Step size validation (even numbers)
7. **Step 0.1** - Decimal step size validation

## Settings Panel

The demo app includes a comprehensive settings panel accessible via the settings icon in the app bar:

### 🌙 Theme Mode
- **Light Mode** - Forces light theme
- **Dark Mode** - Forces dark theme  
- **System** - Follows system theme preference (default)

### 📏 Visual Density
- **Standard** - Default Material 3 spacing (default)
- **Comfortable** - More spacious layout
- **Compact** - Tighter, more condensed layout

### 🔤 Text Scaling
- **Slider Control** - Fine-tune text size from 0.5x to 3.0x
- **Quick Presets** - Common scaling factors (0.8x, 1.0x, 1.2x, 1.5x, 2.0x, etc.)
- **Real-time Preview** - Changes apply immediately

These settings demonstrate how the keypad adapts to different accessibility and design requirements.

## Benefits of This Structure

- **Maintainability** - Each demo is in its own file, making it easy to modify or add new demos
- **Readability** - Clear separation of concerns with logical grouping
- **Reusability** - Base classes and widgets can be easily reused
- **Scalability** - Easy to add new demo configurations without bloating existing files
- **Organization** - Clean directory structure with proper exports

## Adding New Demos

To add a new demo:

1. Create a new file in `/lib/demos/` (e.g., `my_new_demo.dart`)
2. Extend `KeypadDemoPage` and `KeypadDemoPageState`
3. Add the export to `/lib/demos/demos.dart`
4. Add the widget to the tab list in `/lib/widgets/keypad_demo_tabs.dart`
5. Update the tab count in the `TabController`

## Architecture

The package follows hexagonal architecture principles:

- **Domain Layer**: Contains entities, value objects, use cases, and ports
- **Infrastructure Layer**: Contains adapters that implement the ports  
- **Presentation Layer**: Contains Flutter widgets and UI components

### Domain-Driven Design (DDD)

The package properly separates:
- **Entities**: `KeypadSession` (things with identity and lifecycle)
- **Value Objects**: `KeypadState`, `KeypadKey`, `KeypadConfig`, `KeypadAction` (immutable objects defined by their attributes)
- **Ports**: Interfaces for external dependencies
- **Use Cases**: Business logic operations
- **Domain Errors**: Strongly-typed error handling

## Running the Demo

```bash
cd example
flutter run
```

## Usage Example

```dart
import 'package:avkeypad/avkeypad.dart';

NumericKeypad(
  config: const KeypadConfig(
    showConfirmKey: true,
    showCancelKey: true,
    showBackspaceKey: true,
    allowNegative: true,
    maxDigits: 6,
  ),
  onValueChanged: (value) => print('Input: $value'),
  onConfirm: (value) => print('Confirmed: $value'),
  onCancel: () => print('Cancelled'),
)
```

## Configuration Options

- `showDecimalKey`: Show/hide decimal point key
- `showSignKey`: Show/hide +/- toggle key
- `showBackspaceKey`: Show/hide backspace key
- `showClearKey`: Show/hide clear key
- `showConfirmKey`: Show/hide confirm key
- `showCancelKey`: Show/hide cancel key
- `maxDigits`: Maximum number of digits allowed
- `maxDecimalPlaces`: Maximum decimal places
- `allowNegative`: Allow negative numbers
- `allowZero`: Allow zero as input
- `decimalSeparator`: Character used for decimal separation

## Error Handling

The package includes comprehensive domain error types:

- `MaxDigitsExceededError`: When input exceeds digit limit
- `MaxDecimalPlacesExceededError`: When decimal places exceed limit
- `ZeroNotAllowedError`: When zero is not permitted
- `NegativeNotAllowedError`: When negative numbers are not allowed
- `InvalidNumberFormatError`: When input format is invalid

Each error provides structured information and error codes for programmatic handling.
