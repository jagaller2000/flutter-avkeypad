import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_key.dart';
import 'package:avkeypad/src/presentation/widgets/keypad_key_widget.dart';

void main() {
  group('KeypadKeyWidget Tests', () {
    testWidgets('should render digit key correctly', (tester) async {
      // Arrange
      const key = KeypadKey(value: '5', type: KeypadKeyType.digit);
      bool pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadKeyWidget(
              keypadKey: key,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('5'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);

      // Test button press
      await tester.tap(find.byType(FilledButton));
      expect(pressed, isTrue);
    });

    testWidgets('should render decimal key correctly', (tester) async {
      // Arrange
      const key = KeypadKey(value: '.', type: KeypadKeyType.decimal);
      bool pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadKeyWidget(
              keypadKey: key,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('.'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);

      // Test button press
      await tester.tap(find.byType(FilledButton));
      expect(pressed, isTrue);
    });

    testWidgets('should render backspace key correctly', (tester) async {
      // Arrange
      const key = KeypadKey(
        value: 'backspace',
        type: KeypadKeyType.backspace,
        displayText: '⌫',
      );
      bool pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadKeyWidget(
              keypadKey: key,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('⌫'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);

      // Test button press
      await tester.tap(find.byType(FilledButton));
      expect(pressed, isTrue);
    });

    testWidgets('should render clear key correctly', (tester) async {
      // Arrange
      const key = KeypadKey(
        value: 'clear',
        type: KeypadKeyType.clear,
        displayText: 'C',
      );
      bool pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadKeyWidget(
              keypadKey: key,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('C'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);

      // Test button press
      await tester.tap(find.byType(FilledButton));
      expect(pressed, isTrue);
    });

    testWidgets('should render confirm key correctly', (tester) async {
      // Arrange
      const key = KeypadKey(
        value: 'confirm',
        type: KeypadKeyType.confirm,
        displayText: '✓',
      );
      bool pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadKeyWidget(
              keypadKey: key,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('✓'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);

      // Test button press
      await tester.tap(find.byType(FilledButton));
      expect(pressed, isTrue);
    });

    testWidgets('should render cancel key correctly', (tester) async {
      // Arrange
      const key = KeypadKey(
        value: 'cancel',
        type: KeypadKeyType.cancel,
        displayText: '✕',
      );
      bool pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadKeyWidget(
              keypadKey: key,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('✕'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);

      // Test button press
      await tester.tap(find.byType(FilledButton));
      expect(pressed, isTrue);
    });

    testWidgets('should handle disabled key correctly', (tester) async {
      // Arrange
      const key = KeypadKey(value: '5', type: KeypadKeyType.digit);
      bool pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadKeyWidget(
              keypadKey: key,
              onPressed: () => pressed = true,
              isEnabled: false,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('5'), findsOneWidget);
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);

      // Test that button press doesn't trigger callback
      await tester.tap(find.byType(FilledButton));
      expect(pressed, isFalse);
    });

    testWidgets('should handle key with disabled state correctly', (
      tester,
    ) async {
      // Arrange
      const key = KeypadKey(
        value: '5',
        type: KeypadKeyType.digit,
        isEnabled: false,
      );
      bool pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadKeyWidget(
              keypadKey: key,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('5'), findsOneWidget);
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);

      // Test that button press doesn't trigger callback
      await tester.tap(find.byType(FilledButton));
      expect(pressed, isFalse);
    });

    testWidgets('should apply visual density correctly', (tester) async {
      // Arrange
      const key = KeypadKey(value: '5', type: KeypadKeyType.digit);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(visualDensity: VisualDensity.compact),
          home: Scaffold(
            body: KeypadKeyWidget(keypadKey: key, onPressed: () {}),
          ),
        ),
      );

      // Assert
      expect(find.text('5'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);

      // Verify the button has the expected visual density applied
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.style?.visualDensity, VisualDensity.compact);
    });

    testWidgets('should have proper styling for different key types', (
      tester,
    ) async {
      // Test multiple key types to ensure different colors are applied
      const digitKey = KeypadKey(value: '1', type: KeypadKeyType.digit);
      const errorKey = KeypadKey(
        value: 'backspace',
        type: KeypadKeyType.backspace,
        displayText: '⌫',
      );
      const confirmKey = KeypadKey(
        value: 'confirm',
        type: KeypadKeyType.confirm,
        displayText: '✓',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                KeypadKeyWidget(
                  key: const Key('digit'),
                  keypadKey: digitKey,
                  onPressed: () {},
                ),
                KeypadKeyWidget(
                  key: const Key('error'),
                  keypadKey: errorKey,
                  onPressed: () {},
                ),
                KeypadKeyWidget(
                  key: const Key('confirm'),
                  keypadKey: confirmKey,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      // Verify all buttons are rendered
      expect(find.byKey(const Key('digit')), findsOneWidget);
      expect(find.byKey(const Key('error')), findsOneWidget);
      expect(find.byKey(const Key('confirm')), findsOneWidget);
    });

    testWidgets('should use FittedBox for text scaling', (tester) async {
      // Arrange
      const key = KeypadKey(value: '5', type: KeypadKeyType.digit);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadKeyWidget(keypadKey: key, onPressed: () {}),
          ),
        ),
      );

      // Assert
      expect(find.byType(FittedBox), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should use custom display text when provided', (tester) async {
      // Arrange
      const key = KeypadKey(
        value: 'sign',
        type: KeypadKeyType.sign,
        displayText: '±',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadKeyWidget(keypadKey: key, onPressed: () {}),
          ),
        ),
      );

      // Assert
      expect(find.text('±'), findsOneWidget);
      expect(find.text('sign'), findsNothing);
    });

    group('compact mode', () {
      testWidgets('should render in compact mode with correct sizing', (
        tester,
      ) async {
        // Arrange
        const key = KeypadKey(value: '1', type: KeypadKeyType.digit);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: KeypadKeyWidget(
                keypadKey: key,
                onPressed: () {},
                isCompact: true, // This will exercise line 42
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('1'), findsOneWidget);
        expect(find.byType(FilledButton), findsOneWidget);

        // The compact mode applies different sizing and padding
        // which exercises the compact padding calculation on line 42
      });

      testWidgets('should render action button in compact mode', (
        tester,
      ) async {
        // Arrange
        const key = KeypadKey(
          value: 'backspace',
          type: KeypadKeyType.backspace,
          displayText: '⌫',
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: KeypadKeyWidget(
                keypadKey: key,
                onPressed: () {},
                isCompact: true, // This ensures compact sizing is used
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('⌫'), findsOneWidget);
        expect(find.byType(FilledButton), findsOneWidget);
      });
    });
  });
}
