import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_key.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_state.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_config.dart';
import 'package:avkeypad/src/presentation/widgets/keypad_layout_widget.dart';
import 'package:avkeypad/src/presentation/widgets/keypad_key_widget.dart';

void main() {
  group('KeypadLayoutWidget Tests', () {
    late List<List<KeypadKey>> standardLayout;
    late KeypadConfig config;
    late KeypadState emptyState;

    setUp(() {
      standardLayout = [
        [
          const KeypadKey(value: '1', type: KeypadKeyType.digit),
          const KeypadKey(value: '2', type: KeypadKeyType.digit),
          const KeypadKey(value: '3', type: KeypadKeyType.digit),
        ],
        [
          const KeypadKey(value: '.', type: KeypadKeyType.decimal),
          const KeypadKey(value: '0', type: KeypadKeyType.digit),
          const KeypadKey(
            value: 'backspace',
            type: KeypadKeyType.backspace,
            displayText: '⌫',
          ),
        ],
      ];

      config = const KeypadConfig();
      emptyState = const KeypadState(input: '', isValid: true);
    });

    testWidgets('should render layout correctly', (tester) async {
      // Arrange
      final pressedKeys = <KeypadKey>[];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadLayoutWidget(
              layout: standardLayout,
              onKeyPressed: (key) => pressedKeys.add(key),
              state: emptyState,
              config: config,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNWidgets(2)); // 2 rows
      expect(find.byType(KeypadKeyWidget), findsNWidgets(6)); // 6 keys total
    });

    testWidgets('should disable decimal key when decimal already exists', (
      tester,
    ) async {
      // Arrange
      const stateWithDecimal = KeypadState(
        input: '1.',
        isValid: true,
        hasDecimal: true,
      );
      final pressedKeys = <KeypadKey>[];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadLayoutWidget(
              layout: standardLayout,
              onKeyPressed: (key) => pressedKeys.add(key),
              state: stateWithDecimal,
              config: config,
            ),
          ),
        ),
      );

      // Assert
      final decimalKeyFinder = find.byWidgetPredicate(
        (widget) =>
            widget is KeypadKeyWidget &&
            widget.keypadKey.value == '.' &&
            widget.keypadKey.type == KeypadKeyType.decimal,
      );
      expect(decimalKeyFinder, findsOneWidget);

      final decimalKey = tester.widget<KeypadKeyWidget>(decimalKeyFinder);
      expect(decimalKey.isEnabled, isFalse);
    });

    testWidgets('should handle sign key enablement correctly', (tester) async {
      // Arrange
      final layoutWithSign = [
        [
          const KeypadKey(value: '1', type: KeypadKeyType.digit),
          const KeypadKey(value: '±', type: KeypadKeyType.sign),
        ],
      ];
      final pressedKeys = <KeypadKey>[];

      // Test with empty state and negative allowed (should be disabled - needs input)
      const configWithNegative = KeypadConfig(allowNegative: true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadLayoutWidget(
              layout: layoutWithSign,
              onKeyPressed: (key) => pressedKeys.add(key),
              state: emptyState,
              config: configWithNegative,
            ),
          ),
        ),
      );

      final signKeyEmptyFinder = find.byWidgetPredicate(
        (widget) =>
            widget is KeypadKeyWidget &&
            widget.keypadKey.value == '±' &&
            widget.keypadKey.type == KeypadKeyType.sign,
      );
      expect(signKeyEmptyFinder, findsOneWidget);

      final signKeyEmpty = tester.widget<KeypadKeyWidget>(signKeyEmptyFinder);
      expect(signKeyEmpty.isEnabled, isFalse);

      // Test with input and negative allowed (should be enabled)
      const stateWithInput = KeypadState(input: '123', isValid: true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadLayoutWidget(
              layout: layoutWithSign,
              onKeyPressed: (key) => pressedKeys.add(key),
              state: stateWithInput,
              config: configWithNegative,
            ),
          ),
        ),
      );

      final signKeyWithInputFinder = find.byWidgetPredicate(
        (widget) =>
            widget is KeypadKeyWidget &&
            widget.keypadKey.value == '±' &&
            widget.keypadKey.type == KeypadKeyType.sign,
      );
      expect(signKeyWithInputFinder, findsOneWidget);

      final signKeyWithInput = tester.widget<KeypadKeyWidget>(
        signKeyWithInputFinder,
      );
      expect(signKeyWithInput.isEnabled, isTrue);
    });

    testWidgets('should handle backspace key enablement correctly', (
      tester,
    ) async {
      // Arrange
      final pressedKeys = <KeypadKey>[];

      // Test with empty state (should be disabled)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadLayoutWidget(
              layout: standardLayout,
              onKeyPressed: (key) => pressedKeys.add(key),
              state: emptyState,
              config: config,
            ),
          ),
        ),
      );

      final backspaceKeyEmptyFinder = find.byWidgetPredicate(
        (widget) =>
            widget is KeypadKeyWidget &&
            widget.keypadKey.type == KeypadKeyType.backspace,
      );
      expect(backspaceKeyEmptyFinder, findsOneWidget);

      final backspaceKeyEmpty = tester.widget<KeypadKeyWidget>(
        backspaceKeyEmptyFinder,
      );
      expect(backspaceKeyEmpty.isEnabled, isFalse);

      // Test with input (should be enabled)
      const stateWithInput = KeypadState(input: '123', isValid: true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadLayoutWidget(
              layout: standardLayout,
              onKeyPressed: (key) => pressedKeys.add(key),
              state: stateWithInput,
              config: config,
            ),
          ),
        ),
      );

      final backspaceKeyWithInputFinder = find.byWidgetPredicate(
        (widget) =>
            widget is KeypadKeyWidget &&
            widget.keypadKey.type == KeypadKeyType.backspace,
      );
      expect(backspaceKeyWithInputFinder, findsOneWidget);

      final backspaceKeyWithInput = tester.widget<KeypadKeyWidget>(
        backspaceKeyWithInputFinder,
      );
      expect(backspaceKeyWithInput.isEnabled, isTrue);
    });

    testWidgets('should trigger callback when key is pressed', (tester) async {
      // Arrange
      final pressedKeys = <KeypadKey>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadLayoutWidget(
              layout: standardLayout,
              onKeyPressed: (key) => pressedKeys.add(key),
              state: emptyState,
              config: config,
            ),
          ),
        ),
      );

      // Act
      final digitKeyFinder = find.byWidgetPredicate(
        (widget) =>
            widget is KeypadKeyWidget &&
            widget.keypadKey.value == '1' &&
            widget.keypadKey.type == KeypadKeyType.digit,
      );
      expect(digitKeyFinder, findsOneWidget);

      await tester.tap(digitKeyFinder);
      await tester.pump();

      // Assert
      expect(pressedKeys.length, 1);
      expect(pressedKeys.first.value, '1');
      expect(pressedKeys.first.type, KeypadKeyType.digit);
    });
  });
}
