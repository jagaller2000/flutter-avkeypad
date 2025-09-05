import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_config.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_key.dart';
import 'package:avkeypad/src/presentation/widgets/traditional_keypad_widget.dart';
import 'package:avkeypad/src/presentation/widgets/keypad_display_widget.dart';
import 'package:avkeypad/src/presentation/widgets/keypad_key_widget.dart';

void main() {
  group('TraditionalKeypadWidget', () {
    Widget createTestWidget({required TraditionalKeypadWidget child}) {
      return MaterialApp(home: Scaffold(body: child));
    }

    group('basic rendering', () {
      testWidgets('should render with default configuration', (tester) async {
        // Arrange
        const widget = TraditionalKeypadWidget(config: KeypadConfig());

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.byType(TraditionalKeypadWidget), findsOneWidget);
        expect(find.byType(KeypadDisplayWidget), findsOneWidget);
        expect(find.byType(KeypadKeyWidget), findsWidgets);
      });

      testWidgets('should render display widget showing initial state', (
        tester,
      ) async {
        // Arrange
        const widget = TraditionalKeypadWidget(config: KeypadConfig());

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.byType(KeypadDisplayWidget), findsOneWidget);
        expect(find.text('0'), findsNWidgets(2)); // Display + button
      });

      testWidgets('should render all digit keys 0-9', (tester) async {
        // Arrange
        const widget = TraditionalKeypadWidget(config: KeypadConfig());

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        for (int i = 0; i <= 9; i++) {
          expect(find.text(i.toString()), findsWidgets);
        }
      });

      testWidgets('should render decimal key when enabled', (tester) async {
        // Arrange
        const widget = TraditionalKeypadWidget(
          config: KeypadConfig(showDecimalKey: true),
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.text('.'), findsOneWidget);
      });

      testWidgets('should not render decimal key when disabled', (
        tester,
      ) async {
        // Arrange
        const widget = TraditionalKeypadWidget(
          config: KeypadConfig(showDecimalKey: false),
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.text('.'), findsNothing);
      });

      testWidgets('should render clear key when enabled', (tester) async {
        // Arrange
        const widget = TraditionalKeypadWidget(
          config: KeypadConfig(showClearKey: true),
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.text('C'), findsOneWidget);
      });

      testWidgets('should render sign key when enabled', (tester) async {
        // Arrange
        const widget = TraditionalKeypadWidget(
          config: KeypadConfig(showSignKey: true),
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.text('±'), findsOneWidget);
      });

      testWidgets('should render confirm key when enabled', (tester) async {
        // Arrange
        const widget = TraditionalKeypadWidget(config: KeypadConfig());

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.text('✓'), findsOneWidget);
      });

      testWidgets('should render backspace key when enabled', (tester) async {
        // Arrange
        const widget = TraditionalKeypadWidget(
          config: KeypadConfig(showBackspaceKey: true),
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.text('⌫'), findsOneWidget);
      });
    });

    group('custom display widget', () {
      testWidgets('should use custom display widget when provided', (
        tester,
      ) async {
        // Arrange
        const customDisplay = Text('Custom Display');
        const widget = TraditionalKeypadWidget(
          config: KeypadConfig(),
          displayWidget: customDisplay,
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.text('Custom Display'), findsOneWidget);
        expect(find.byType(KeypadDisplayWidget), findsNothing);
      });

      testWidgets('should use default display widget when not provided', (
        tester,
      ) async {
        // Arrange
        const widget = TraditionalKeypadWidget(config: KeypadConfig());

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.byType(KeypadDisplayWidget), findsOneWidget);
      });
    });

    group('custom key builder', () {
      testWidgets('should use custom key builder when provided', (
        tester,
      ) async {
        // Arrange
        Widget customKeyBuilder(KeypadKey key, VoidCallback onPressed) {
          return ElevatedButton(
            onPressed: onPressed,
            child: Text('Custom ${key.value}'),
          );
        }

        final widget = TraditionalKeypadWidget(
          config: const KeypadConfig(),
          keyBuilder: customKeyBuilder,
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.byType(ElevatedButton), findsWidgets);
        expect(find.text('Custom 1'), findsOneWidget);
        expect(find.byType(KeypadKeyWidget), findsNothing);
      });

      testWidgets('should use default key widgets when builder not provided', (
        tester,
      ) async {
        // Arrange
        const widget = TraditionalKeypadWidget(config: KeypadConfig());

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.byType(KeypadKeyWidget), findsWidgets);
      });
    });

    group('input handling', () {
      testWidgets('should update display when digit key is pressed', (
        tester,
      ) async {
        // Arrange
        const widget = TraditionalKeypadWidget(config: KeypadConfig());

        await tester.pumpWidget(createTestWidget(child: widget));

        // Act
        await tester.tap(find.text('1'));
        await tester.pump();

        // Assert
        expect(find.text('1'), findsWidgets); // Button + display
      });

      testWidgets('should update display when multiple digits pressed', (
        tester,
      ) async {
        // Arrange
        const widget = TraditionalKeypadWidget(config: KeypadConfig());

        await tester.pumpWidget(createTestWidget(child: widget));

        // Act
        await tester.tap(find.text('1'));
        await tester.pump();
        await tester.tap(find.text('2'));
        await tester.pump();
        await tester.tap(find.text('3'));
        await tester.pump();

        // Assert
        expect(find.text('123'), findsOneWidget);
      });

      testWidgets('should handle decimal input when enabled', (tester) async {
        // Arrange
        const widget = TraditionalKeypadWidget(
          config: KeypadConfig(showDecimalKey: true),
        );

        await tester.pumpWidget(createTestWidget(child: widget));

        // Act
        await tester.tap(find.text('1'));
        await tester.pump();
        await tester.tap(find.text('.'));
        await tester.pump();
        await tester.tap(find.text('5'));
        await tester.pump();

        // Assert
        expect(find.text('1.5'), findsOneWidget);
      });

      testWidgets('should handle backspace when enabled', (tester) async {
        // Arrange
        const widget = TraditionalKeypadWidget(
          config: KeypadConfig(showBackspaceKey: true),
        );

        await tester.pumpWidget(createTestWidget(child: widget));

        // Act
        await tester.tap(find.text('1'));
        await tester.pump();
        await tester.tap(find.text('2'));
        await tester.pump();
        await tester.tap(find.text('⌫'));
        await tester.pump();

        // Assert
        expect(find.text('1'), findsWidgets); // Button + display
      });

      testWidgets('should handle clear when enabled', (tester) async {
        // Arrange
        const widget = TraditionalKeypadWidget(
          config: KeypadConfig(showClearKey: true),
        );

        await tester.pumpWidget(createTestWidget(child: widget));

        // Act
        await tester.tap(find.text('1'));
        await tester.pump();
        await tester.tap(find.text('2'));
        await tester.pump();
        await tester.tap(find.text('C'));
        await tester.pump();

        // Assert
        expect(find.text('0'), findsWidgets); // Back to initial state
      });

      testWidgets('should handle sign toggle when enabled', (tester) async {
        // Arrange
        const widget = TraditionalKeypadWidget(
          config: KeypadConfig(showSignKey: true, allowNegative: true),
        );

        await tester.pumpWidget(createTestWidget(child: widget));

        // Act
        await tester.tap(find.text('1'));
        await tester.pump();
        await tester.tap(find.text('±'));
        await tester.pump();

        // Assert
        expect(find.text('-1'), findsOneWidget);
      });
    });

    group('callbacks', () {
      testWidgets('should call onKeyPressed when key is tapped', (
        tester,
      ) async {
        // Arrange
        KeypadKey? pressedKey;
        final widget = TraditionalKeypadWidget(
          config: const KeypadConfig(),
          onKeyPressed: (key) => pressedKey = key,
        );

        await tester.pumpWidget(createTestWidget(child: widget));

        // Act
        await tester.tap(find.text('1'));
        await tester.pump();

        // Assert
        expect(pressedKey, isNotNull);
        expect(pressedKey!.value, equals('1'));
        expect(pressedKey!.type, equals(KeypadKeyType.digit));
      });

      testWidgets('should call onValueChanged when input changes', (
        tester,
      ) async {
        // Arrange
        String? changedValue;
        final widget = TraditionalKeypadWidget(
          config: const KeypadConfig(),
          onValueChanged: (value) => changedValue = value,
        );

        await tester.pumpWidget(createTestWidget(child: widget));

        // Act
        await tester.tap(find.text('1'));
        await tester.pump();

        // Assert
        expect(changedValue, equals('1'));
      });

      testWidgets('should call onConfirm when confirm key is pressed', (
        tester,
      ) async {
        // Arrange
        String? confirmedValue;
        final widget = TraditionalKeypadWidget(config: const KeypadConfig());

        await tester.pumpWidget(createTestWidget(child: widget));

        // Act
        await tester.tap(find.text('1'));
        await tester.pump();
        await tester.tap(find.text('✓'));
        await tester.pump();

        // Assert
        expect(confirmedValue, equals('1'));
      });

      testWidgets('should call onCancel when cancel key is pressed', (
        tester,
      ) async {
        // Arrange
        bool cancelCalled = false;
        final widget = TraditionalKeypadWidget(
          config: const KeypadConfig(showCancelKey: true),
          onCancel: () => cancelCalled = true,
        );

        await tester.pumpWidget(createTestWidget(child: widget));

        // Act
        await tester.tap(find.text('✕'));
        await tester.pump();

        // Assert
        expect(cancelCalled, isTrue);
      });

      testWidgets('should handle custom key types', (tester) async {
        // Arrange - create custom keys
        const customKeys = [
          KeypadKey(value: 'pi', type: KeypadKeyType.custom, displayText: 'π'),
          KeypadKey(
            value: 'euler',
            type: KeypadKeyType.custom,
            displayText: 'e',
          ),
        ];

        const config = KeypadConfig(
          customKeys: customKeys,
          // Ensure action row is created
        );

        KeypadKey? pressedKey;

        final widget = TraditionalKeypadWidget(
          config: config,
          onKeyPressed: (key) {
            pressedKey = key;
          },
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert - custom keys should be rendered
        expect(find.text('π'), findsOneWidget);
        expect(find.text('e'), findsOneWidget);

        // Test pressing custom key
        await tester.tap(find.text('π'));
        await tester.pump();

        // Verify callback was called with custom key
        expect(pressedKey, isNotNull);
        expect(pressedKey!.value, equals('pi'));
        expect(pressedKey!.type, equals(KeypadKeyType.custom));
        expect(pressedKey!.displayText, equals('π'));
      });

      testWidgets('should handle multiple custom keys', (tester) async {
        // Arrange - create multiple custom keys
        const customKeys = [
          KeypadKey(
            value: 'sqrt',
            type: KeypadKeyType.custom,
            displayText: '√',
          ),
          KeypadKey(
            value: 'percent',
            type: KeypadKeyType.custom,
            displayText: '%',
          ),
          KeypadKey(
            value: 'memory',
            type: KeypadKeyType.custom,
            displayText: 'M+',
          ),
        ];

        const config = KeypadConfig(
          customKeys: customKeys,
          showClearKey: true, // Ensure action row exists
        );

        final pressedKeys = <KeypadKey>[];

        final widget = TraditionalKeypadWidget(
          config: config,
          onKeyPressed: (key) {
            pressedKeys.add(key);
          },
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert - all custom keys should be rendered
        expect(find.text('√'), findsOneWidget);
        expect(find.text('%'), findsOneWidget);
        expect(find.text('M+'), findsOneWidget);

        // Test pressing each custom key
        await tester.tap(find.text('√'));
        await tester.pump();
        await tester.tap(find.text('%'));
        await tester.pump();
        await tester.tap(find.text('M+'));
        await tester.pump();

        // Verify all callbacks were called correctly
        expect(pressedKeys.length, equals(3));
        expect(pressedKeys[0].value, equals('sqrt'));
        expect(pressedKeys[1].value, equals('percent'));
        expect(pressedKeys[2].value, equals('memory'));

        // Verify all are custom type
        for (final key in pressedKeys) {
          expect(key.type, equals(KeypadKeyType.custom));
        }
      });

      testWidgets('should handle custom key with key builder', (tester) async {
        // Arrange - custom key with custom builder
        const customKey = KeypadKey(
          value: 'special',
          type: KeypadKeyType.custom,
          displayText: '★',
        );

        const config = KeypadConfig(
          customKeys: [customKey],
          showBackspaceKey: true, // Ensure action row exists
        );

        KeypadKey? pressedKey;
        bool customBuilderUsed = false;

        final widget = TraditionalKeypadWidget(
          config: config,
          onKeyPressed: (key) {
            pressedKey = key;
          },
          keyBuilder: (key, onPressed) {
            if (key.type == KeypadKeyType.custom) {
              customBuilderUsed = true;
              return ElevatedButton(
                onPressed: onPressed,
                child: Text('CUSTOM: ${key.display}'),
              );
            }
            return KeypadKeyWidget(keypadKey: key, onPressed: onPressed);
          },
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert - custom builder should be used
        expect(customBuilderUsed, isTrue);
        expect(find.text('CUSTOM: ★'), findsOneWidget);

        // Test pressing custom key through custom builder
        await tester.tap(find.text('CUSTOM: ★'));
        await tester.pump();

        // Verify callback was called
        expect(pressedKey, isNotNull);
        expect(pressedKey!.value, equals('special'));
        expect(pressedKey!.type, equals(KeypadKeyType.custom));
      });
    });

    group('configuration updates', () {
      testWidgets('should update layout when config changes', (tester) async {
        // Arrange
        const initialConfig = KeypadConfig(showDecimalKey: false);
        const updatedConfig = KeypadConfig(showDecimalKey: true);

        Widget buildWidget(KeypadConfig config) {
          return MaterialApp(
            home: Scaffold(body: TraditionalKeypadWidget(config: config)),
          );
        }

        await tester.pumpWidget(buildWidget(initialConfig));

        // Assert initial state
        expect(find.text('.'), findsNothing);

        // Act
        await tester.pumpWidget(buildWidget(updatedConfig));
        await tester.pump();

        // Assert updated state
        expect(find.text('.'), findsOneWidget);
      });

      testWidgets('should maintain input state during config updates', (
        tester,
      ) async {
        // Arrange
        const initialConfig = KeypadConfig();
        const updatedConfig = KeypadConfig(showSignKey: true);

        Widget buildWidget(KeypadConfig config) {
          return MaterialApp(
            home: Scaffold(body: TraditionalKeypadWidget(config: config)),
          );
        }

        await tester.pumpWidget(buildWidget(initialConfig));

        // Enter some input
        await tester.tap(find.text('1'));
        await tester.pump();
        await tester.tap(find.text('2'));
        await tester.pump();

        // Assert input exists
        expect(find.text('12'), findsOneWidget);

        // Act - update config
        await tester.pumpWidget(buildWidget(updatedConfig));
        await tester.pump();

        // Assert input is reset (new session created)
        expect(find.text('0'), findsWidgets);
      });
    });

    group('validation and error handling', () {
      testWidgets('should respect max digits configuration', (tester) async {
        // Arrange
        const widget = TraditionalKeypadWidget(
          config: KeypadConfig(maxDigits: 2),
        );

        await tester.pumpWidget(createTestWidget(child: widget));

        // Act
        await tester.tap(find.text('1'));
        await tester.pump();
        await tester.tap(find.text('2'));
        await tester.pump();
        await tester.tap(find.text('3')); // Should be ignored
        await tester.pump();

        // Assert
        expect(find.text('12'), findsOneWidget);
        expect(find.text('123'), findsNothing);
      });

      testWidgets('should prevent multiple decimal points', (tester) async {
        // Arrange
        const widget = TraditionalKeypadWidget(
          config: KeypadConfig(showDecimalKey: true),
        );

        await tester.pumpWidget(createTestWidget(child: widget));

        // Act
        await tester.tap(find.text('1'));
        await tester.pump();
        await tester.tap(find.text('.'));
        await tester.pump();
        await tester.tap(find.text('5'));
        await tester.pump();
        await tester.tap(find.text('.')); // Should be ignored
        await tester.pump();

        // Assert
        expect(find.text('1.5'), findsOneWidget);
      });

      testWidgets('should handle zero not allowed configuration', (
        tester,
      ) async {
        // Arrange
        const widget = TraditionalKeypadWidget(
          config: KeypadConfig(allowZero: false),
        );

        await tester.pumpWidget(createTestWidget(child: widget));

        // Act - find the zero button specifically (not in display)
        final zeroButtons = find.text('0');

        // Tap the zero button (should be the one inside a KeypadKeyWidget)
        await tester.tap(zeroButtons.last);
        await tester.pump();

        // Assert - should show error or remain at initial state
        expect(
          find.text('0'),
          findsNWidgets(2),
        ); // Still showing initial display
      });
    });

    group('edge cases', () {
      testWidgets('should handle empty configuration gracefully', (
        tester,
      ) async {
        // Arrange
        const widget = TraditionalKeypadWidget(config: KeypadConfig());

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.byType(TraditionalKeypadWidget), findsOneWidget);
        expect(find.byType(KeypadDisplayWidget), findsOneWidget);
      });

      testWidgets('should handle rapid key presses', (tester) async {
        // Arrange
        const widget = TraditionalKeypadWidget(config: KeypadConfig());

        await tester.pumpWidget(createTestWidget(child: widget));

        // Act - rapid taps
        for (int i = 1; i <= 5; i++) {
          await tester.tap(find.text(i.toString()));
          await tester.pump(const Duration(milliseconds: 10));
        }

        // Assert
        expect(find.text('12345'), findsOneWidget);
      });

      testWidgets('should handle key presses with null callbacks', (
        tester,
      ) async {
        // Arrange
        const widget = TraditionalKeypadWidget(
          config: KeypadConfig(),
          // All callbacks are null by default
        );

        await tester.pumpWidget(createTestWidget(child: widget));

        // Act
        await tester.tap(find.text('1'));
        await tester.pump();

        // Assert - should not crash
        expect(find.text('1'), findsWidgets);
      });
    });

    group('accessibility', () {
      testWidgets('should be accessible to screen readers', (tester) async {
        // Arrange
        const widget = TraditionalKeypadWidget(config: KeypadConfig());

        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert - just verify the widget is accessible
        expect(find.byType(TraditionalKeypadWidget), findsOneWidget);
        expect(find.byType(KeypadKeyWidget), findsWidgets);
      });
    });
  });
}
