import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_config.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_key.dart';
import 'package:avkeypad/src/domain/ports/keypad_port.dart';
import 'package:avkeypad/src/presentation/widgets/compact_keypad_widget.dart';
import 'package:avkeypad/src/presentation/widgets/keypad_key_widget.dart';

// Mock implementation for testing - follows clean hexagonal architecture
class MockKeypadPort implements KeypadPort {
  List<List<KeypadKey>>? _mockLayout;

  void setMockLayout(List<List<KeypadKey>> layout) {
    _mockLayout = layout;
  }

  @override
  KeypadConfig getDefaultConfig() => const KeypadConfig();

  @override
  List<List<KeypadKey>> getKeypadLayout(KeypadConfig config) =>
      _mockLayout ?? [];

  @override
  String getLocalizedKeyText(KeypadKeyType keyType) => keyType.toString();
}

void main() {
  group('CompactKeypadWidget', () {
    late MockKeypadPort mockKeypadPort;

    setUp(() {
      mockKeypadPort = MockKeypadPort();
    });

    Widget createTestWidget({required CompactKeypadWidget child}) {
      return MaterialApp(home: Scaffold(body: child));
    }

    group('basic rendering', () {
      testWidgets('should render display area with current value', (
        tester,
      ) async {
        // Arrange
        mockKeypadPort.setMockLayout([
          [const KeypadKey(value: '1', type: KeypadKeyType.digit)],
        ]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '42',
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.text('42'), findsOneWidget);
      });

      testWidgets('should render "0" when current value is empty', (
        tester,
      ) async {
        // Arrange
        mockKeypadPort.setMockLayout([
          [const KeypadKey(value: '1', type: KeypadKeyType.digit)],
        ]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '',
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.text('0'), findsOneWidget);
      });

      testWidgets('should render digit keys from layout', (tester) async {
        // Arrange - typical compact layout with 4 rows of digits
        mockKeypadPort.setMockLayout([
          [
            const KeypadKey(value: '1', type: KeypadKeyType.digit),
            const KeypadKey(value: '2', type: KeypadKeyType.digit),
            const KeypadKey(value: '3', type: KeypadKeyType.digit),
          ],
          [
            const KeypadKey(value: '4', type: KeypadKeyType.digit),
            const KeypadKey(value: '5', type: KeypadKeyType.digit),
            const KeypadKey(value: '6', type: KeypadKeyType.digit),
          ],
          [
            const KeypadKey(value: '7', type: KeypadKeyType.digit),
            const KeypadKey(value: '8', type: KeypadKeyType.digit),
            const KeypadKey(value: '9', type: KeypadKeyType.digit),
          ],
          [const KeypadKey(value: '0', type: KeypadKeyType.digit)],
        ]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '',
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(find.text('4'), findsOneWidget);
        expect(find.text('5'), findsOneWidget);
        expect(find.text('6'), findsOneWidget);
        expect(find.text('7'), findsOneWidget);
        expect(find.text('8'), findsOneWidget);
        expect(find.text('9'), findsOneWidget);
        expect(
          find.text('0'),
          findsNWidgets(2),
        ); // One in display, one as button
      });
    });

    group('action buttons', () {
      testWidgets('should render confirm button when provided', (tester) async {
        // Arrange - layout with action buttons in separate row
        mockKeypadPort.setMockLayout([
          [const KeypadKey(value: '1', type: KeypadKeyType.digit)],
          // Action buttons row
          [
            const KeypadKey(
              value: 'confirm',
              type: KeypadKeyType.confirm,
              displayText: '✓',
            ),
          ],
        ]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '123',
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.text('✓'), findsOneWidget);
      });

      testWidgets('should render backspace button when provided', (
        tester,
      ) async {
        // Arrange
        mockKeypadPort.setMockLayout([
          [const KeypadKey(value: '1', type: KeypadKeyType.digit)],
          // Action buttons row
          [
            const KeypadKey(
              value: 'backspace',
              type: KeypadKeyType.backspace,
              displayText: '⌫',
            ),
          ],
        ]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '123',
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.text('⌫'), findsOneWidget);
      });

      testWidgets('should render both action buttons when provided', (
        tester,
      ) async {
        // Arrange
        mockKeypadPort.setMockLayout([
          [const KeypadKey(value: '1', type: KeypadKeyType.digit)],
          // Action buttons row
          [
            const KeypadKey(
              value: 'confirm',
              type: KeypadKeyType.confirm,
              displayText: '✓',
            ),
            const KeypadKey(
              value: 'backspace',
              type: KeypadKeyType.backspace,
              displayText: '⌫',
            ),
          ],
        ]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '123',
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.text('✓'), findsOneWidget);
        expect(find.text('⌫'), findsOneWidget);
      });

      testWidgets('should handle empty action buttons gracefully', (
        tester,
      ) async {
        // Arrange - no action buttons
        mockKeypadPort.setMockLayout([
          [const KeypadKey(value: '1', type: KeypadKeyType.digit)],
        ]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '123',
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert - should not crash and should render digit
        expect(find.text('1'), findsOneWidget);
        expect(find.text('✓'), findsNothing);
        expect(find.text('⌫'), findsNothing);
      });
    });

    group('user interactions', () {
      testWidgets('should call onKeyPressed when digit key is tapped', (
        tester,
      ) async {
        // Arrange
        KeypadKey? pressedKey;
        mockKeypadPort.setMockLayout([
          [const KeypadKey(value: '5', type: KeypadKeyType.digit)],
        ]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '',
          onKeyPressed: (key) => pressedKey = key,
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));
        await tester.tap(find.text('5'));

        // Assert
        expect(pressedKey?.value, equals('5'));
        expect(pressedKey?.type, equals(KeypadKeyType.digit));
      });

      testWidgets('should call onKeyPressed when confirm button is tapped', (
        tester,
      ) async {
        // Arrange
        KeypadKey? pressedKey;
        mockKeypadPort.setMockLayout([
          [const KeypadKey(value: '1', type: KeypadKeyType.digit)],
          [
            const KeypadKey(
              value: 'confirm',
              type: KeypadKeyType.confirm,
              displayText: '✓',
            ),
          ],
        ]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '123',
          onKeyPressed: (key) => pressedKey = key,
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));
        await tester.tap(find.text('✓'));

        // Assert
        expect(pressedKey?.value, equals('confirm'));
        expect(pressedKey?.type, equals(KeypadKeyType.confirm));
      });

      testWidgets('should call onKeyPressed when backspace button is tapped', (
        tester,
      ) async {
        // Arrange
        KeypadKey? pressedKey;
        mockKeypadPort.setMockLayout([
          [const KeypadKey(value: '1', type: KeypadKeyType.digit)],
          [
            const KeypadKey(
              value: 'backspace',
              type: KeypadKeyType.backspace,
              displayText: '⌫',
            ),
          ],
        ]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '123',
          onKeyPressed: (key) => pressedKey = key,
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));
        await tester.tap(find.text('⌫'));

        // Assert
        expect(pressedKey?.value, equals('backspace'));
        expect(pressedKey?.type, equals(KeypadKeyType.backspace));
      });

      testWidgets('should not crash when onKeyPressed is null', (tester) async {
        // Arrange
        mockKeypadPort.setMockLayout([
          [const KeypadKey(value: '1', type: KeypadKeyType.digit)],
        ]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '',
          // onKeyPressed is null
        );

        // Act & Assert - should not crash
        await tester.pumpWidget(createTestWidget(child: widget));
        await tester.tap(find.text('1'));
        // Test passes if no exception is thrown
      });
    });

    group('layout structure', () {
      testWidgets('should use compact keys for action buttons', (tester) async {
        // Arrange
        mockKeypadPort.setMockLayout([
          [const KeypadKey(value: '1', type: KeypadKeyType.digit)],
          [
            const KeypadKey(
              value: 'confirm',
              type: KeypadKeyType.confirm,
              displayText: '✓',
            ),
          ],
        ]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '',
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert - find KeypadKeyWidget with isCompact=true for action button
        final confirmKeyWidget = tester.widget<KeypadKeyWidget>(
          find.descendant(
            of: find.byType(CompactKeypadWidget),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is KeypadKeyWidget &&
                  widget.keypadKey.type == KeypadKeyType.confirm,
            ),
          ),
        );
        expect(confirmKeyWidget.isCompact, isTrue);
      });
    });

    group('complex layouts', () {
      testWidgets('should handle multiple rows of digits', (tester) async {
        // Arrange - realistic compact layout
        mockKeypadPort.setMockLayout([
          [
            const KeypadKey(value: '1', type: KeypadKeyType.digit),
            const KeypadKey(value: '2', type: KeypadKeyType.digit),
            const KeypadKey(value: '3', type: KeypadKeyType.digit),
          ],
          [
            const KeypadKey(value: '4', type: KeypadKeyType.digit),
            const KeypadKey(value: '5', type: KeypadKeyType.digit),
            const KeypadKey(value: '6', type: KeypadKeyType.digit),
          ],
          [
            const KeypadKey(value: '0', type: KeypadKeyType.digit),
            const KeypadKey(value: '.', type: KeypadKeyType.decimal),
          ],
          [
            const KeypadKey(
              value: 'confirm',
              type: KeypadKeyType.confirm,
              displayText: '✓',
            ),
            const KeypadKey(
              value: 'backspace',
              type: KeypadKeyType.backspace,
              displayText: '⌫',
            ),
          ],
        ]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '',
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(find.text('4'), findsOneWidget);
        expect(find.text('5'), findsOneWidget);
        expect(find.text('6'), findsOneWidget);
        expect(
          find.text('0'),
          findsNWidgets(2),
        ); // One in display, one as button
        expect(find.text('.'), findsOneWidget);
        expect(find.text('✓'), findsOneWidget);
        expect(find.text('⌫'), findsOneWidget);
      });

      testWidgets('should handle mixed key types in rows', (tester) async {
        // Arrange - layout with mixed key types
        mockKeypadPort.setMockLayout([
          [
            const KeypadKey(value: '1', type: KeypadKeyType.digit),
            const KeypadKey(value: '2', type: KeypadKeyType.digit),
          ],
          [
            const KeypadKey(
              value: 'clear',
              type: KeypadKeyType.clear,
              displayText: 'C',
            ),
            const KeypadKey(value: '0', type: KeypadKeyType.digit),
            const KeypadKey(value: '.', type: KeypadKeyType.decimal),
          ],
        ]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '',
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: widget));

        // Assert
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('C'), findsOneWidget);
        expect(
          find.text('0'),
          findsNWidgets(2),
        ); // One in display, one as button
        expect(find.text('.'), findsOneWidget);
      });
    });

    group('edge cases', () {
      testWidgets('should handle empty layout gracefully', (tester) async {
        // Arrange
        mockKeypadPort.setMockLayout([]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '',
        );

        // Act & Assert - should not crash
        await tester.pumpWidget(createTestWidget(child: widget));
        // Test passes if widget renders without exception
      });

      testWidgets('should work with different themes', (tester) async {
        // Arrange
        mockKeypadPort.setMockLayout([
          [const KeypadKey(value: '1', type: KeypadKeyType.digit)],
        ]);

        final widget = CompactKeypadWidget(
          keypadPort: mockKeypadPort,
          config: const KeypadConfig(),
          currentValue: '42',
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(body: widget),
          ),
        );

        // Assert - should render with dark theme
        expect(find.text('1'), findsOneWidget);
        expect(find.text('42'), findsOneWidget);
      });
    });
  });
}
