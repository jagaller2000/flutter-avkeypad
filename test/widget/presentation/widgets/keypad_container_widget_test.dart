import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_key.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_state.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_config.dart';
import 'package:avkeypad/src/domain/errors/domain_errors.dart';
import 'package:avkeypad/src/presentation/widgets/keypad_container_widget.dart';
import 'package:avkeypad/src/presentation/widgets/keypad_display_widget.dart';
import 'package:avkeypad/src/presentation/widgets/keypad_layout_widget.dart';

void main() {
  group('KeypadContainerWidget Tests', () {
    late KeypadConfig config;
    late KeypadState emptyState;
    late KeypadState stateWithInput;

    setUp(() {
      config = const KeypadConfig();
      emptyState = const KeypadState(input: '', isValid: true);
      stateWithInput = const KeypadState(input: '123.45', isValid: true);
    });

    testWidgets('should render container with display and layout', (
      tester,
    ) async {
      // Arrange
      final pressedKeys = <KeypadKey>[];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadContainerWidget(
              state: emptyState,
              config: config,
              onKeyPressed: (key) => pressedKeys.add(key),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Container), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(KeypadDisplayWidget), findsOneWidget);
      expect(find.byType(KeypadLayoutWidget), findsOneWidget);
    });

    testWidgets('should display current state correctly', (tester) async {
      // Arrange
      final pressedKeys = <KeypadKey>[];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadContainerWidget(
              state: stateWithInput,
              config: config,
              onKeyPressed: (key) => pressedKeys.add(key),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('123.45'), findsOneWidget);
    });

    testWidgets('should handle key press events', (tester) async {
      // Arrange
      final pressedKeys = <KeypadKey>[];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadContainerWidget(
              state: emptyState,
              config: config,
              onKeyPressed: (key) => pressedKeys.add(key),
            ),
          ),
        ),
      );

      // Tap a digit key
      await tester.tap(find.text('1'));
      await tester.tap(find.text('2'));

      // Assert
      expect(pressedKeys, hasLength(2));
      expect(pressedKeys[0].value, '1');
      expect(pressedKeys[1].value, '2');
    });

    testWidgets('should apply custom padding correctly', (tester) async {
      // Arrange
      const customPadding = EdgeInsets.all(32);
      final pressedKeys = <KeypadKey>[];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadContainerWidget(
              state: emptyState,
              config: config,
              onKeyPressed: (key) => pressedKeys.add(key),
              padding: customPadding,
            ),
          ),
        ),
      );

      // Assert
      // Find the main container
      final containerWidget = tester.widget<Container>(
        find.byType(Container).first,
      );
      expect(containerWidget.padding, customPadding);
    });

    testWidgets('should apply custom decoration correctly', (tester) async {
      // Arrange
      const customDecoration = BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      );
      final pressedKeys = <KeypadKey>[];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadContainerWidget(
              state: emptyState,
              config: config,
              onKeyPressed: (key) => pressedKeys.add(key),
              decoration: customDecoration,
            ),
          ),
        ),
      );

      // Assert
      final containerWidget = tester.widget<Container>(
        find.byType(Container).first,
      );
      expect(containerWidget.decoration, customDecoration);
    });

    testWidgets('should apply custom display margin correctly', (tester) async {
      // Arrange
      const customDisplayMargin = EdgeInsets.only(bottom: 30);
      final pressedKeys = <KeypadKey>[];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadContainerWidget(
              state: emptyState,
              config: config,
              onKeyPressed: (key) => pressedKeys.add(key),
              displayMargin: customDisplayMargin,
            ),
          ),
        ),
      );

      // Assert
      // Check if the margin is applied on any container
      final hasCorrectMargin = tester
          .widgetList<Container>(find.byType(Container))
          .any((container) => container.margin == customDisplayMargin);

      expect(hasCorrectMargin, isTrue);
    });

    testWidgets('should handle different visual densities', (tester) async {
      // Arrange
      final pressedKeys = <KeypadKey>[];

      // Test compact density
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(visualDensity: VisualDensity.compact),
          home: Scaffold(
            body: KeypadContainerWidget(
              state: emptyState,
              config: config,
              onKeyPressed: (key) => pressedKeys.add(key),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(KeypadDisplayWidget), findsOneWidget);
      expect(find.byType(KeypadLayoutWidget), findsOneWidget);

      // Test comfortable density
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(visualDensity: VisualDensity.comfortable),
          home: Scaffold(
            body: KeypadContainerWidget(
              state: emptyState,
              config: config,
              onKeyPressed: (key) => pressedKeys.add(key),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(KeypadDisplayWidget), findsOneWidget);
      expect(find.byType(KeypadLayoutWidget), findsOneWidget);
    });

    testWidgets('should generate standard layout with different configs', (
      tester,
    ) async {
      // Arrange
      final pressedKeys = <KeypadKey>[];

      // Test with decimal key disabled
      const configNoDecimal = KeypadConfig(showDecimalKey: false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadContainerWidget(
              state: emptyState,
              config: configNoDecimal,
              onKeyPressed: (key) => pressedKeys.add(key),
            ),
          ),
        ),
      );

      // Assert that the widget still renders (specific layout testing would be in integration tests)
      expect(find.byType(KeypadDisplayWidget), findsOneWidget);
      expect(find.byType(KeypadLayoutWidget), findsOneWidget);
    });

    testWidgets('should handle error states correctly', (tester) async {
      // Arrange
      const errorState = KeypadState(
        input: '123456',
        isValid: false,
        error: MaxDigitsExceededError(5),
      );
      final pressedKeys = <KeypadKey>[];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeypadContainerWidget(
              state: errorState,
              config: config,
              onKeyPressed: (key) => pressedKeys.add(key),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('123456'), findsOneWidget);
      expect(find.text('Maximum 5 digits allowed'), findsOneWidget);
    });

    testWidgets('should maintain minimum size layout', (tester) async {
      // Arrange
      final pressedKeys = <KeypadKey>[];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: KeypadContainerWidget(
                state: emptyState,
                config: config,
                onKeyPressed: (key) => pressedKeys.add(key),
              ),
            ),
          ),
        ),
      );

      // Assert
      final columnWidget = tester.widget<Column>(find.byType(Column).first);
      expect(columnWidget.mainAxisSize, MainAxisSize.min);
    });

    testWidgets('should work with different themes', (tester) async {
      // Arrange
      final pressedKeys = <KeypadKey>[];

      // Test with dark theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: KeypadContainerWidget(
              state: emptyState,
              config: config,
              onKeyPressed: (key) => pressedKeys.add(key),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(KeypadDisplayWidget), findsOneWidget);
      expect(find.byType(KeypadLayoutWidget), findsOneWidget);

      // Test with light theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: KeypadContainerWidget(
              state: emptyState,
              config: config,
              onKeyPressed: (key) => pressedKeys.add(key),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(KeypadDisplayWidget), findsOneWidget);
      expect(find.byType(KeypadLayoutWidget), findsOneWidget);
    });
  });
}
