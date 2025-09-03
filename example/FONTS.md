# Custom Font Configuration

## Overview

The AVKeypad demo app uses custom fonts to enhance the user experience:

- **B612**: Default font for all UI text (designed for legibility)
- **B612 Mono**: Monospace font for numeric content (keypad keys and display)

## Implementation

### TextTheme Extension

The font configuration is implemented via a `TextTheme` extension located in `lib/extensions/text_theme_extension.dart`:

```dart
extension CustomFontTextTheme on TextTheme {
  /// Returns a TextTheme with B612 as the default font family
  TextTheme get withB612Font { /* ... */ }

  /// Returns a TextTheme with B612 Mono for numeric content
  TextTheme get withB612MonoForNumbers { /* ... */ }

  /// Returns a complete TextTheme with both custom fonts
  TextTheme get withCustomFonts { /* ... */ }
}
```

### Usage in MaterialApp

The extension is applied in `main.dart`:

```dart
MaterialApp(
  theme: ThemeData(
    // ... other theme properties
    textTheme: ThemeData.light().textTheme.withCustomFonts,
  ),
  darkTheme: ThemeData(
    // ... other theme properties  
    textTheme: ThemeData.dark().textTheme.withCustomFonts,
  ),
)
```

## Font Mapping

### B612 (Default UI Font)
Applied to all standard text styles:
- `displayLarge`, `displayMedium`, `displaySmall`
- `headlineLarge`, `headlineMedium`, `headlineSmall`
- `titleLarge`, `titleMedium`, `titleSmall`
- `bodyLarge`, `bodyMedium`, `bodySmall`
- `labelLarge`, `labelMedium`, `labelSmall`

### B612 Mono (Numeric Content)
Applied to specific text styles used for numeric display:
- `titleMedium`: Used by keypad keys (numbers 0-9, decimal point)
- `headlineMedium`: Used by keypad display (main number display)
- `bodyLarge`: Used for other numeric content

## Font Features

Both B612 Mono configurations include the `tabularFigures` font feature for consistent digit width and alignment.

## Font Assets

Fonts are included in the `assets/fonts/` directory:

```
assets/fonts/
├── B612/
│   ├── B612-Regular.ttf
│   ├── B612-Bold.ttf
│   ├── B612-Italic.ttf
│   └── B612-BoldItalic.ttf
└── B612_Mono/
    ├── B612Mono-Regular.ttf
    ├── B612Mono-Bold.ttf
    ├── B612Mono-Italic.ttf
    └── B612Mono-BoldItalic.ttf
```

## Benefits

1. **Consistent Typography**: B612 provides excellent legibility across all UI text
2. **Numeric Clarity**: B612 Mono ensures clear, aligned numeric display
3. **Professional Appearance**: Both fonts are designed for technical/aviation applications
4. **Accessibility**: High legibility especially important for numeric input
5. **Maintainable**: Extension pattern allows easy font changes across the entire app

## About B612 Fonts

- **B612**: Designed by ENAC (École nationale de l'aviation civile) for cockpit displays
- **B612 Mono**: Monospace variant optimized for numeric and tabular data
- **License**: Open Font License (OFL)
- **Purpose**: Maximum legibility in critical applications
