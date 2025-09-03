import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

void main() {
  group('UpdateKeypadSessionUseCase Tests', () {
    late UpdateKeypadSessionUseCase useCase;
    late KeypadSession testSession;
    const testConfig = KeypadConfig();

    setUp(() {
      useCase = const UpdateKeypadSessionUseCase();
      testSession = KeypadSession(id: 'test-session', config: testConfig);
    });

    group('State Update', () {
      test('should update session state', () {
        const newState = KeypadState(input: '123', isValid: true);

        final result = useCase(session: testSession, newState: newState);

        expect(result.currentState, equals(newState));
        expect(result.currentState.input, equals('123'));
        expect(result.currentState.isValid, isTrue);
      });

      test('should return same session instance', () {
        const newState = KeypadState(input: '456');

        final result = useCase(session: testSession, newState: newState);

        expect(identical(result, testSession), isTrue);
        expect(result.id, equals(testSession.id));
        expect(result.config, equals(testSession.config));
      });

      test('should update from empty to filled state', () {
        expect(testSession.currentState.isEmpty, isTrue);

        const filledState = KeypadState(input: '123.45', isValid: true);
        final result = useCase(session: testSession, newState: filledState);

        expect(result.currentState.isEmpty, isFalse);
        expect(result.currentState.input, equals('123.45'));
      });

      test('should update from filled to empty state', () {
        // First set a filled state
        testSession.updateState(const KeypadState(input: '123'));

        const emptyState = KeypadState();
        final result = useCase(session: testSession, newState: emptyState);

        expect(result.currentState.isEmpty, isTrue);
        expect(result.currentState.input, isEmpty);
      });
    });

    group('State Properties', () {
      test('should update validity status', () {
        const invalidState = KeypadState(
          input: '123',
          isValid: false,
          error: MaxDigitsExceededError(2),
        );

        final result = useCase(session: testSession, newState: invalidState);

        expect(result.currentState.isValid, isFalse);
        expect(result.currentState.error, isA<MaxDigitsExceededError>());
      });

      test('should update decimal flag', () {
        const decimalState = KeypadState(input: '123.45', hasDecimal: true);

        final result = useCase(session: testSession, newState: decimalState);

        expect(result.currentState.hasDecimal, isTrue);
        expect(result.currentState.input, contains('.'));
      });

      test('should update negative flag', () {
        const negativeState = KeypadState(input: '-123', isNegative: true);

        final result = useCase(session: testSession, newState: negativeState);

        expect(result.currentState.isNegative, isTrue);
        expect(result.currentState.input, startsWith('-'));
      });

      test('should update complex state', () {
        const complexState = KeypadState(
          input: '-456.789',
          isValid: true,
          hasDecimal: true,
          isNegative: true,
        );

        final result = useCase(session: testSession, newState: complexState);

        expect(result.currentState.input, equals('-456.789'));
        expect(result.currentState.isValid, isTrue);
        expect(result.currentState.hasDecimal, isTrue);
        expect(result.currentState.isNegative, isTrue);
      });
    });

    group('Error States', () {
      test('should update to error state', () {
        const errorState = KeypadState(
          input: '123456',
          isValid: false,
          error: MaxDigitsExceededError(5),
        );

        final result = useCase(session: testSession, newState: errorState);

        expect(result.currentState.isValid, isFalse);
        expect(result.currentState.error, isA<MaxDigitsExceededError>());
        expect(result.currentState.input, equals('123456'));
      });

      test('should clear error state', () {
        // First set an error state
        testSession.updateState(
          const KeypadState(
            input: '123',
            isValid: false,
            error: ZeroNotAllowedError(),
          ),
        );

        const validState = KeypadState(input: '123', isValid: true);
        final result = useCase(session: testSession, newState: validState);

        expect(result.currentState.isValid, isTrue);
        expect(result.currentState.error, isNull);
      });

      test('should update to different error type', () {
        // First set one error
        testSession.updateState(
          const KeypadState(
            input: '123',
            isValid: false,
            error: MaxDigitsExceededError(2),
          ),
        );

        const newErrorState = KeypadState(
          input: '123.456',
          isValid: false,
          error: MaxDecimalPlacesExceededError(2),
        );
        final result = useCase(session: testSession, newState: newErrorState);

        expect(result.currentState.error, isA<MaxDecimalPlacesExceededError>());
        expect(result.currentState.error, isNot(isA<MaxDigitsExceededError>()));
      });
    });

    group('Completion Status', () {
      test('should update completion status to complete', () {
        expect(testSession.isComplete, isFalse);

        const completeState = KeypadState(input: '123', isValid: true);
        final result = useCase(session: testSession, newState: completeState);

        expect(result.isComplete, isTrue);
      });

      test('should update completion status to incomplete', () {
        // First make it complete
        testSession.updateState(const KeypadState(input: '123', isValid: true));
        expect(testSession.isComplete, isTrue);

        const incompleteState = KeypadState(input: '', isValid: true);
        final result = useCase(session: testSession, newState: incompleteState);

        expect(result.isComplete, isFalse);
      });

      test('should handle invalid complete state', () {
        const invalidState = KeypadState(
          input: '123',
          isValid: false,
          error: StepSizeViolationError(2.0, 123),
        );

        final result = useCase(session: testSession, newState: invalidState);

        expect(result.isComplete, isFalse);
        expect(result.currentState.isValid, isFalse);
      });
    });

    group('Multiple Updates', () {
      test('should handle sequential updates', () {
        const state1 = KeypadState(input: '1');
        const state2 = KeypadState(input: '12');
        const state3 = KeypadState(input: '123');

        var result = useCase(session: testSession, newState: state1);
        expect(result.currentState.input, equals('1'));

        result = useCase(session: testSession, newState: state2);
        expect(result.currentState.input, equals('12'));

        result = useCase(session: testSession, newState: state3);
        expect(result.currentState.input, equals('123'));
      });

      test('should maintain session identity across updates', () {
        final originalId = testSession.id;
        final originalConfig = testSession.config;

        const state1 = KeypadState(input: '1');
        const state2 = KeypadState(input: '12');

        var result = useCase(session: testSession, newState: state1);
        expect(result.id, equals(originalId));
        expect(result.config, equals(originalConfig));

        result = useCase(session: testSession, newState: state2);
        expect(result.id, equals(originalId));
        expect(result.config, equals(originalConfig));
      });

      test('should handle rapid updates', () {
        for (int i = 0; i < 100; i++) {
          final state = KeypadState(input: i.toString());
          final result = useCase(session: testSession, newState: state);
          expect(result.currentState.input, equals(i.toString()));
        }
      });
    });

    group('State Immutability', () {
      test('should not modify the new state parameter', () {
        const originalState = KeypadState(input: '123', isValid: true);

        useCase(session: testSession, newState: originalState);

        // Original state should remain unchanged
        expect(originalState.input, equals('123'));
        expect(originalState.isValid, isTrue);
      });

      test('should preserve state equality after update', () {
        const newState = KeypadState(input: '123', isValid: true);

        final result = useCase(session: testSession, newState: newState);

        expect(result.currentState, equals(newState));
        expect(result.currentState.input, equals(newState.input));
        expect(result.currentState.isValid, equals(newState.isValid));
      });
    });

    group('Session Context Preservation', () {
      test('should preserve session ID', () {
        const testId = 'unique-session-id-123';
        final session = KeypadSession(id: testId, config: testConfig);

        const newState = KeypadState(input: '456');
        final result = useCase(session: session, newState: newState);

        expect(result.id, equals(testId));
      });

      test('should preserve session config', () {
        const customConfig = KeypadConfig(
          maxDigits: 5,
          allowNegative: true,
          stepSize: 0.5,
        );
        final session = KeypadSession(id: 'test', config: customConfig);

        const newState = KeypadState(input: '123');
        final result = useCase(session: session, newState: newState);

        expect(result.config, equals(customConfig));
        expect(result.config.maxDigits, equals(5));
        expect(result.config.allowNegative, isTrue);
        expect(result.config.stepSize, equals(0.5));
      });
    });

    group('Use Case Behavior', () {
      test('should be deterministic', () {
        const newState = KeypadState(input: '123', isValid: true);

        final result1 = useCase(session: testSession, newState: newState);
        final result2 = useCase(session: testSession, newState: newState);

        expect(result1.currentState, equals(result2.currentState));
        expect(identical(result1, result2), isTrue); // Same session instance
      });

      test('should not create new session instance', () {
        const newState = KeypadState(input: '123');

        final result = useCase(session: testSession, newState: newState);

        expect(identical(result, testSession), isTrue);
      });

      test('should work with different session types', () {
        // Test with session with initial state
        final sessionWithInitialState = KeypadSession(
          id: 'initial-session',
          config: testConfig,
          initialState: const KeypadState(input: '999'),
        );

        const newState = KeypadState(input: '111');
        final result = useCase(
          session: sessionWithInitialState,
          newState: newState,
        );

        expect(result.currentState.input, equals('111'));
        expect(result.id, equals('initial-session'));
      });
    });

    group('Edge Cases', () {
      test('should handle empty string state', () {
        const emptyState = KeypadState(input: '');

        final result = useCase(session: testSession, newState: emptyState);

        expect(result.currentState.input, isEmpty);
        expect(result.currentState.isEmpty, isTrue);
      });

      test('should handle very long input state', () {
        final longInput = '1' * 1000;
        final longState = KeypadState(input: longInput);

        final result = useCase(session: testSession, newState: longState);

        expect(result.currentState.input, equals(longInput));
        expect(result.currentState.input.length, equals(1000));
      });

      test('should handle state with special characters', () {
        const specialState = KeypadState(input: '-123.456€');

        final result = useCase(session: testSession, newState: specialState);

        expect(result.currentState.input, equals('-123.456€'));
      });

      test('should handle null error state properly', () {
        const stateWithoutError = KeypadState(
          input: '123',
          isValid: true,
          error: null,
        );

        final result = useCase(
          session: testSession,
          newState: stateWithoutError,
        );

        expect(result.currentState.error, isNull);
        expect(result.currentState.isValid, isTrue);
      });
    });

    group('Session State Transitions', () {
      test('should transition from valid to invalid state', () {
        testSession.updateState(const KeypadState(input: '123', isValid: true));
        expect(testSession.currentState.isValid, isTrue);

        const invalidState = KeypadState(
          input: '123456',
          isValid: false,
          error: MaxDigitsExceededError(5),
        );
        final result = useCase(session: testSession, newState: invalidState);

        expect(result.currentState.isValid, isFalse);
        expect(result.currentState.error, isNotNull);
      });

      test('should transition from invalid to valid state', () {
        testSession.updateState(
          const KeypadState(
            input: '123',
            isValid: false,
            error: ZeroNotAllowedError(),
          ),
        );
        expect(testSession.currentState.isValid, isFalse);

        const validState = KeypadState(input: '123', isValid: true);
        final result = useCase(session: testSession, newState: validState);

        expect(result.currentState.isValid, isTrue);
        expect(result.currentState.error, isNull);
      });
    });
  });
}
