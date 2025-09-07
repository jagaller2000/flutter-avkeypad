import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_state.dart';
import 'package:avkeypad/src/domain/errors/domain_errors.dart';
import 'package:avkeypad/src/presentation/widgets/keypad_display_widget.dart';

void main() {
  group('KeypadDisplayWidget Tests', () {
    testWidgets('should display input text correctly', (tester) async {
      // Arrange
      const state = KeypadState(input: '123.45', isValid: true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: KeypadDisplayWidget(state: state)),
        ),
      );

      // Assert
      expect(find.text('123.45'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should display placeholder when input is empty', (
      tester,
    ) async {
      // Arrange
      const state = KeypadState(input: '', isValid: true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: KeypadDisplayWidget(state: state)),
        ),
      );

      // Assert
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('should display error message when state is invalid', (
      tester,
    ) async {
      // Arrange
      const state = KeypadState(
        input: '123456',
        isValid: false,
        error: MaxDigitsExceededError(5),
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: KeypadDisplayWidget(state: state)),
        ),
      );

      // Assert
      expect(find.text('123456'), findsOneWidget);
      expect(find.text('Maximum 5 digits allowed'), findsOneWidget);
    });

    testWidgets('should not display error when state is valid', (tester) async {
      // Arrange
      const state = KeypadState(input: '123', isValid: true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: KeypadDisplayWidget(state: state)),
        ),
      );

      // Assert
      expect(find.text('123'), findsOneWidget);
      // Should not find any error message
      expect(find.textContaining('allowed'), findsNothing);
      expect(find.textContaining('exceeded'), findsNothing);
    });

    testWidgets('should apply custom text style correctly', (tester) async {
      // Arrange
      const state = KeypadState(input: '123', isValid: true);
      const customTextStyle = TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KeypadDisplayWidget(state: state, textStyle: customTextStyle),
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text('123'));
      expect(textWidget.style?.fontSize, 32);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
      expect(textWidget.style?.color, Colors.red);
    });

    testWidgets('should apply custom error text style correctly', (
      tester,
    ) async {
      // Arrange
      const state = KeypadState(
        input: '123456',
        isValid: false,
        error: MaxDigitsExceededError(5),
      );
      const customErrorTextStyle = TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.orange,
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KeypadDisplayWidget(
              state: state,
              errorTextStyle: customErrorTextStyle,
            ),
          ),
        ),
      );

      // Assert
      final errorTextWidget = tester.widget<Text>(
        find.text('Maximum 5 digits allowed'),
      );
      expect(errorTextWidget.style?.fontSize, 14);
      expect(errorTextWidget.style?.fontWeight, FontWeight.w600);
      expect(errorTextWidget.style?.color, Colors.orange);
    });

    testWidgets('should apply custom padding correctly', (tester) async {
      // Arrange
      const state = KeypadState(input: '123', isValid: true);
      const customPadding = EdgeInsets.all(24);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KeypadDisplayWidget(state: state, padding: customPadding),
          ),
        ),
      );

      // Assert
      final containerWidget = tester.widget<Container>(find.byType(Container));
      expect(containerWidget.padding, customPadding);
    });

    testWidgets('should apply custom decoration correctly', (tester) async {
      // Arrange
      const state = KeypadState(input: '123', isValid: true);
      const customDecoration = BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KeypadDisplayWidget(
              state: state,
              decoration: customDecoration,
            ),
          ),
        ),
      );

      // Assert
      final containerWidget = tester.widget<Container>(find.byType(Container));
      expect(containerWidget.decoration, customDecoration);
    });

    testWidgets('should handle visual density correctly', (tester) async {
      // Arrange
      const state = KeypadState(input: '123', isValid: true);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(visualDensity: VisualDensity.compact),
          home: const Scaffold(body: KeypadDisplayWidget(state: state)),
        ),
      );

      // Assert
      expect(find.text('123'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should display different error types correctly', (
      tester,
    ) async {
      // Test various error types
      const testCases = [
        (
          KeypadState(input: '0', isValid: false, error: ZeroNotAllowedError()),
          'Zero is not allowed',
        ),
        (
          KeypadState(
            input: '-5',
            isValid: false,
            error: NegativeNotAllowedError(),
          ),
          'Negative numbers are not allowed',
        ),
        (
          KeypadState(
            input: '1.234',
            isValid: false,
            error: MaxDecimalPlacesExceededError(2),
          ),
          'Maximum 2 decimal places allowed',
        ),
        (
          KeypadState(
            input: 'abc',
            isValid: false,
            error: InvalidNumberFormatError(),
          ),
          'Invalid number format',
        ),
      ];

      for (final (state, expectedErrorMessage) in testCases) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: KeypadDisplayWidget(state: state)),
          ),
        );

        expect(find.text(state.input), findsOneWidget);
        expect(find.text(expectedErrorMessage), findsOneWidget);

        // Clear the widget tree for next test
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('should have proper layout structure', (tester) async {
      // Arrange
      const state = KeypadState(
        input: '123.45',
        isValid: false,
        error: MaxDigitsExceededError(5),
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: KeypadDisplayWidget(state: state)),
        ),
      );

      // Assert
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget); // Error spacing

      // Verify Column properties
      final columnWidget = tester.widget<Column>(find.byType(Column));
      expect(columnWidget.crossAxisAlignment, CrossAxisAlignment.end);
      expect(columnWidget.mainAxisSize, MainAxisSize.min);
    });

    testWidgets('should use tabular figures for numeric display', (
      tester,
    ) async {
      // Arrange
      const state = KeypadState(input: '123.45', isValid: true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: KeypadDisplayWidget(state: state)),
        ),
      );

      // Assert
      final displayText = tester.widget<Text>(find.text('123.45'));
      expect(displayText.style?.fontFeatures, isNotNull);
      expect(displayText.style?.fontFeatures, isNotEmpty);
    });

    testWidgets('should display text with unit correctly', (tester) async {
      // Arrange - simulate what GetSessionInfoUseCase would return
      const state = KeypadState(input: '123.45 km', isValid: true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: KeypadDisplayWidget(state: state)),
        ),
      );

      // Assert
      expect(find.text('123.45 km'), findsOneWidget);
    });

    testWidgets('should display placeholder with unit correctly', (
      tester,
    ) async {
      // Arrange - simulate what GetSessionInfoUseCase would return for empty input with unit
      const state = KeypadState(input: '0 kg', isValid: true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: KeypadDisplayWidget(state: state)),
        ),
      );

      // Assert
      expect(find.text('0 kg'), findsOneWidget);
    });

    testWidgets('should display various unit formats correctly', (
      tester,
    ) async {
      // Test different unit formats
      const testCases = [
        '100 \$',
        '75 %',
        '98.6 °F',
        '-15.5 °C',
        '50.5 m/s',
      ];

      for (final displayText in testCases) {
        final state = KeypadState(input: displayText, isValid: true);
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: KeypadDisplayWidget(state: state)),
          ),
        );

        expect(find.text(displayText), findsOneWidget);

        // Clear the widget tree for next test
        await tester.pumpWidget(Container());
      }
    });
  });
}
