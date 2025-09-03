import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

void main() {
  group('CreateKeypadSessionUseCase Tests', () {
    late CreateKeypadSessionUseCase useCase;
    const testSessionId = 'test-session-123';
    const testConfig = KeypadConfig();

    setUp(() {
      useCase = const CreateKeypadSessionUseCase();
    });

    group('Session Creation', () {
      test('should create session with required parameters', () {
        final session = useCase(
          sessionId: testSessionId,
          config: testConfig,
        );

        expect(session.id, equals(testSessionId));
        expect(session.config, equals(testConfig));
        expect(session.currentState, equals(const KeypadState()));
      });

      test('should create session with custom initial state', () {
        const initialState = KeypadState(input: '123', isValid: true);
        
        final session = useCase(
          sessionId: testSessionId,
          config: testConfig,
          initialState: initialState,
        );

        expect(session.id, equals(testSessionId));
        expect(session.config, equals(testConfig));
        expect(session.currentState, equals(initialState));
      });

      test('should use default empty state when no initial state provided', () {
        final session = useCase(
          sessionId: testSessionId,
          config: testConfig,
        );

        expect(session.currentState.input, isEmpty);
        expect(session.currentState.isValid, isTrue);
        expect(session.currentState.hasDecimal, isFalse);
        expect(session.currentState.isNegative, isFalse);
        expect(session.currentState.error, isNull);
      });
    });

    group('Session Identity', () {
      test('should create sessions with unique identifiers', () {
        final session1 = useCase(
          sessionId: 'session-1',
          config: testConfig,
        );
        final session2 = useCase(
          sessionId: 'session-2',
          config: testConfig,
        );

        expect(session1.id, isNot(equals(session2.id)));
        expect(session1, isNot(equals(session2)));
      });

      test('should create identical sessions with same parameters', () {
        final session1 = useCase(
          sessionId: testSessionId,
          config: testConfig,
        );
        final session2 = useCase(
          sessionId: testSessionId,
          config: testConfig,
        );

        expect(session1.id, equals(session2.id));
        expect(session1.config, equals(session2.config));
        expect(session1.currentState, equals(session2.currentState));
        expect(session1, equals(session2));
      });

      test('should handle empty session IDs', () {
        final session = useCase(
          sessionId: '',
          config: testConfig,
        );

        expect(session.id, isEmpty);
        expect(session.config, equals(testConfig));
      });

      test('should handle very long session IDs', () {
        final longId = 'a' * 1000;
        final session = useCase(
          sessionId: longId,
          config: testConfig,
        );

        expect(session.id, equals(longId));
        expect(session.id.length, equals(1000));
      });

      test('should handle special characters in session IDs', () {
        const specialId = 'session_123-abc!@#';
        final session = useCase(
          sessionId: specialId,
          config: testConfig,
        );

        expect(session.id, equals(specialId));
      });
    });

    group('Configuration Handling', () {
      test('should preserve all config properties', () {
        const customConfig = KeypadConfig(
          showDecimalKey: false,
          showSignKey: true,
          maxDigits: 5,
          allowNegative: true,
          stepSize: 0.5,
        );

        final session = useCase(
          sessionId: testSessionId,
          config: customConfig,
        );

        expect(session.config, equals(customConfig));
        expect(session.config.showDecimalKey, isFalse);
        expect(session.config.showSignKey, isTrue);
        expect(session.config.maxDigits, equals(5));
        expect(session.config.allowNegative, isTrue);
        expect(session.config.stepSize, equals(0.5));
      });

      test('should handle minimal config', () {
        const minimalConfig = KeypadConfig();

        final session = useCase(
          sessionId: testSessionId,
          config: minimalConfig,
        );

        expect(session.config, equals(minimalConfig));
      });

      test('should handle complex config with custom keys', () {
        final customKeys = [
          const KeypadKey(value: 'pi', type: KeypadKeyType.custom, displayText: 'π'),
          const KeypadKey(value: 'euler', type: KeypadKeyType.custom, displayText: 'e'),
        ];

        final complexConfig = KeypadConfig(
          showDecimalKey: true,
          showSignKey: true,
          showConfirmKey: true,
          maxDigits: 10,
          maxDecimalPlaces: 4,
          allowNegative: true,
          stepSize: 0.0001,
          customKeys: customKeys,
        );

        final session = useCase(
          sessionId: testSessionId,
          config: complexConfig,
        );

        expect(session.config, equals(complexConfig));
        expect(session.config.customKeys.length, equals(2));
      });
    });

    group('Initial State Handling', () {
      test('should handle valid initial state', () {
        const validState = KeypadState(
          input: '123.45',
          isValid: true,
          hasDecimal: true,
          isNegative: false,
        );

        final session = useCase(
          sessionId: testSessionId,
          config: testConfig,
          initialState: validState,
        );

        expect(session.currentState, equals(validState));
        expect(session.currentState.input, equals('123.45'));
        expect(session.currentState.isValid, isTrue);
        expect(session.currentState.hasDecimal, isTrue);
      });

      test('should handle invalid initial state', () {
        const invalidState = KeypadState(
          input: 'invalid',
          isValid: false,
          error: InvalidNumberFormatError(),
        );

        final session = useCase(
          sessionId: testSessionId,
          config: testConfig,
          initialState: invalidState,
        );

        expect(session.currentState, equals(invalidState));
        expect(session.currentState.isValid, isFalse);
        expect(session.currentState.error, isA<InvalidNumberFormatError>());
      });

      test('should handle negative initial state', () {
        const negativeState = KeypadState(
          input: '-123.45',
          isValid: true,
          hasDecimal: true,
          isNegative: true,
        );

        final session = useCase(
          sessionId: testSessionId,
          config: testConfig,
          initialState: negativeState,
        );

        expect(session.currentState, equals(negativeState));
        expect(session.currentState.isNegative, isTrue);
      });

      test('should handle empty initial state', () {
        const emptyState = KeypadState();

        final session = useCase(
          sessionId: testSessionId,
          config: testConfig,
          initialState: emptyState,
        );

        expect(session.currentState, equals(emptyState));
        expect(session.currentState.isEmpty, isTrue);
      });
    });

    group('Use Case Consistency', () {
      test('should be stateless and pure', () {
        // Multiple calls with same parameters should produce identical results
        final session1 = useCase(
          sessionId: testSessionId,
          config: testConfig,
        );
        final session2 = useCase(
          sessionId: testSessionId,
          config: testConfig,
        );

        expect(session1, equals(session2));
        expect(session1.id, equals(session2.id));
        expect(session1.config, equals(session2.config));
        expect(session1.currentState, equals(session2.currentState));
      });

      test('should not modify input parameters', () {
        const originalConfig = KeypadConfig(maxDigits: 5);
        const originalState = KeypadState(input: '123');

        final session = useCase(
          sessionId: testSessionId,
          config: originalConfig,
          initialState: originalState,
        );

        // Original objects should remain unchanged
        expect(originalConfig.maxDigits, equals(5));
        expect(originalState.input, equals('123'));
        
        // Session should have copies/references, not the originals
        expect(session.config, equals(originalConfig));
        expect(session.currentState, equals(originalState));
      });

      test('should handle rapid consecutive calls', () {
        final sessions = <KeypadSession>[];
        
        for (int i = 0; i < 100; i++) {
          final session = useCase(
            sessionId: 'session-$i',
            config: testConfig,
          );
          sessions.add(session);
        }

        expect(sessions.length, equals(100));
        
        // Each session should have unique ID
        final ids = sessions.map((s) => s.id).toSet();
        expect(ids.length, equals(100));
        
        // All should have same config
        for (final session in sessions) {
          expect(session.config, equals(testConfig));
        }
      });
    });

    group('Edge Cases', () {
      test('should handle Unicode session IDs', () {
        const unicodeId = 'session-测试-123-π';
        final session = useCase(
          sessionId: unicodeId,
          config: testConfig,
        );

        expect(session.id, equals(unicodeId));
      });

      test('should handle newlines in session IDs', () {
        const multilineId = 'session\\nwith\\nnewlines';
        final session = useCase(
          sessionId: multilineId,
          config: testConfig,
        );

        expect(session.id, equals(multilineId));
      });

      test('should handle config with all features disabled', () {
        const restrictedConfig = KeypadConfig(
          showDecimalKey: false,
          showSignKey: false,
          showClearKey: false,
          showBackspaceKey: false,
          showConfirmKey: false,
          showCancelKey: false,
          maxDigits: 1,
          maxDecimalPlaces: 0,
          allowNegative: false,
          allowZero: false,
        );

        final session = useCase(
          sessionId: testSessionId,
          config: restrictedConfig,
        );

        expect(session.config, equals(restrictedConfig));
        expect(session.config.showDecimalKey, isFalse);
        expect(session.config.allowNegative, isFalse);
      });

      test('should handle complex initial state with error', () {
        const errorState = KeypadState(
          input: '999999999',
          isValid: false,
          hasDecimal: false,
          isNegative: false,
          error: MaxDigitsExceededError(5),
        );

        final session = useCase(
          sessionId: testSessionId,
          config: testConfig,
          initialState: errorState,
        );

        expect(session.currentState, equals(errorState));
        expect(session.currentState.error, isA<MaxDigitsExceededError>());
      });
    });

    group('Session Properties Verification', () {
      test('should create session with correct completion status', () {
        const emptyState = KeypadState();
        const filledState = KeypadState(input: '123', isValid: true);

        final emptySession = useCase(
          sessionId: 'empty',
          config: testConfig,
          initialState: emptyState,
        );
        final filledSession = useCase(
          sessionId: 'filled',
          config: testConfig,
          initialState: filledState,
        );

        expect(emptySession.isComplete, isFalse);
        expect(filledSession.isComplete, isTrue);
      });

      test('should preserve state immutability in created session', () {
        const initialState = KeypadState(input: '123');
        
        final session = useCase(
          sessionId: testSessionId,
          config: testConfig,
          initialState: initialState,
        );

        // Modifying returned session should not affect original state
        expect(session.currentState, equals(initialState));
        expect(session.currentState.input, equals('123'));
      });
    });
  });
}
