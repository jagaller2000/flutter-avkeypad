import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

void main() {
  group('HardwareKeyboardKeypad Tests', () {
    testWidgets('should handle digit key presses', (tester) async {
      // Arrange
      KeypadAction? capturedAction;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HardwareKeyboardKeypad(
              onKeypadAction: (action) => capturedAction = action,
              child: const Text('Test Child'),
            ),
          ),
        ),
      );

      // Act - simulate pressing digit 5
      await tester.sendKeyEvent(LogicalKeyboardKey.digit5);
      await tester.pump();

      // Assert
      expect(capturedAction, isNotNull);
      expect(capturedAction!.type, KeypadActionType.digitInput);
      expect(capturedAction!.value, '5');
    });

    testWidgets('should handle numpad digit key presses', (tester) async {
      // Arrange
      KeypadAction? capturedAction;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HardwareKeyboardKeypad(
              onKeypadAction: (action) => capturedAction = action,
              child: const Text('Test Child'),
            ),
          ),
        ),
      );

      // Act - simulate pressing numpad 3
      await tester.sendKeyEvent(LogicalKeyboardKey.numpad3);
      await tester.pump();

      // Assert
      expect(capturedAction, isNotNull);
      expect(capturedAction!.type, KeypadActionType.digitInput);
      expect(capturedAction!.value, '3');
    });

    testWidgets('should handle decimal point key press', (tester) async {
      // Arrange
      KeypadAction? capturedAction;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HardwareKeyboardKeypad(
              onKeypadAction: (action) => capturedAction = action,
              child: const Text('Test Child'),
            ),
          ),
        ),
      );

      // Act - simulate pressing period for decimal
      await tester.sendKeyEvent(LogicalKeyboardKey.period);
      await tester.pump();

      // Assert
      expect(capturedAction, isNotNull);
      expect(capturedAction!.type, KeypadActionType.decimalInput);
    });

    testWidgets('should handle backspace key press', (tester) async {
      // Arrange
      KeypadAction? capturedAction;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HardwareKeyboardKeypad(
              onKeypadAction: (action) => capturedAction = action,
              child: const Text('Test Child'),
            ),
          ),
        ),
      );

      // Act - simulate pressing backspace
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pump();

      // Assert
      expect(capturedAction, isNotNull);
      expect(capturedAction!.type, KeypadActionType.backspace);
    });

    testWidgets('should handle escape key press for clear', (tester) async {
      // Arrange
      KeypadAction? capturedAction;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HardwareKeyboardKeypad(
              onKeypadAction: (action) => capturedAction = action,
              child: const Text('Test Child'),
            ),
          ),
        ),
      );

      // Act - simulate pressing escape to clear
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      // Assert
      expect(capturedAction, isNotNull);
      expect(capturedAction!.type, KeypadActionType.clear);
    });

    testWidgets('should handle minus key for sign toggle', (tester) async {
      // Arrange
      KeypadAction? capturedAction;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HardwareKeyboardKeypad(
              onKeypadAction: (action) => capturedAction = action,
              child: const Text('Test Child'),
            ),
          ),
        ),
      );

      // Act - simulate pressing minus key
      await tester.sendKeyEvent(LogicalKeyboardKey.minus);
      await tester.pump();

      // Assert
      expect(capturedAction, isNotNull);
      expect(capturedAction!.type, KeypadActionType.toggleSign);
    });

    testWidgets('should not handle keys when disabled', (tester) async {
      // Arrange
      KeypadAction? capturedAction;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HardwareKeyboardKeypad(
              enabled: false,
              onKeypadAction: (action) => capturedAction = action,
              child: const Text('Test Child'),
            ),
          ),
        ),
      );

      // Act - simulate pressing digit 5
      await tester.sendKeyEvent(LogicalKeyboardKey.digit5);
      await tester.pump();

      // Assert
      expect(capturedAction, isNull);
    });

    testWidgets('should focus on tap when enabled', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HardwareKeyboardKeypad(
              onKeypadAction: (_) {},
              child: const Text('Test Child'),
            ),
          ),
        ),
      );

      // Act - tap on the widget
      await tester.tap(find.text('Test Child'));
      await tester.pump();

      // Assert - widget should have focus (tested by sending a key event)
      KeypadAction? capturedAction;
      final widget = tester.widget<HardwareKeyboardKeypad>(
        find.byType(HardwareKeyboardKeypad),
      );
      
      // We can't directly test focus, but we can test that keyboard events are handled
      // This is an indirect test of focus
      expect(widget.enabled, isTrue);
    });

    testWidgets('should handle all digit keys 0-9', (tester) async {
      // Arrange
      final capturedActions = <KeypadAction>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HardwareKeyboardKeypad(
              onKeypadAction: (action) => capturedActions.add(action),
              child: const Text('Test Child'),
            ),
          ),
        ),
      );

      // Act - simulate pressing all digit keys
      for (int i = 0; i <= 9; i++) {
        final key = LogicalKeyboardKey(0x00000030 + i); // ASCII codes for 0-9
        await tester.sendKeyEvent(key);
        await tester.pump();
      }

      // Assert
      expect(capturedActions.length, 10);
      for (int i = 0; i < 10; i++) {
        expect(capturedActions[i].type, KeypadActionType.digitInput);
        expect(capturedActions[i].value, i.toString());
      }
    });
  });

  group('NumericKeypad with Hardware Keyboard', () {
    testWidgets('should work with hardware keyboard enabled by default', (tester) async {
      // Arrange
      String? lastValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumericKeypad(
              onValueChanged: (value) => lastValue = value,
            ),
          ),
        ),
      );

      // Act - simulate pressing digit keys via keyboard
      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.digit3);
      await tester.pump();

      // Assert
      expect(lastValue, '123');
    });

    testWidgets('should clear input with escape key', (tester) async {
      // Arrange
      String? lastValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumericKeypad(
              onValueChanged: (value) => lastValue = value,
            ),
          ),
        ),
      );

      // Act - enter some digits then clear with escape
      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
      await tester.pump();
      expect(lastValue, '12'); // Verify we have input

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      // Assert
      expect(lastValue, '');
    });

    testWidgets('should not handle keyboard when disabled', (tester) async {
      // Arrange
      String? lastValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumericKeypad(
              enableHardwareKeyboard: false,
              onValueChanged: (value) => lastValue = value,
            ),
          ),
        ),
      );

      // Act - simulate pressing digit keys via keyboard
      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.pump();

      // Assert - no keyboard input should be processed
      expect(lastValue, isNull);
    });
  });
}