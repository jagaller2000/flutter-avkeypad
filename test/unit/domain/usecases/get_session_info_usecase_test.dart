import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

void main() {
  group('GetSessionInfoUseCase Tests', () {
    late GetSessionInfoUseCase useCase;
    late KeypadSession testSession;
    const testConfig = KeypadConfig();

    setUp(() {
      useCase = const GetSessionInfoUseCase();
      testSession = KeypadSession(id: 'test-session-123', config: testConfig);
    });

    group('Session ID Retrieval', () {
      test('should return correct session ID', () {
        final result = useCase.getSessionId(testSession);
        expect(result, equals('test-session-123'));
      });

      test('should return empty ID for empty session', () {
        final emptySession = KeypadSession(id: '', config: testConfig);
        final result = useCase.getSessionId(emptySession);
        expect(result, isEmpty);
      });

      test('should return long ID correctly', () {
        final longId = 'a' * 1000;
        final longIdSession = KeypadSession(id: longId, config: testConfig);
        final result = useCase.getSessionId(longIdSession);
        expect(result, equals(longId));
        expect(result.length, equals(1000));
      });

      test('should return ID with special characters', () {
        const specialId = 'session-123_abc!@#';
        final specialSession = KeypadSession(id: specialId, config: testConfig);
        final result = useCase.getSessionId(specialSession);
        expect(result, equals(specialId));
      });
    });

    group('Current Input Retrieval', () {
      test('should return empty string for new session', () {
        final result = useCase.getCurrentInput(testSession);
        expect(result, isEmpty);
      });

      test('should return current input after update', () {
        testSession.updateState(const KeypadState(input: '123.45'));
        final result = useCase.getCurrentInput(testSession);
        expect(result, equals('123.45'));
      });

      test('should return negative input', () {
        testSession.updateState(
          const KeypadState(input: '-789', isNegative: true),
        );
        final result = useCase.getCurrentInput(testSession);
        expect(result, equals('-789'));
      });

      test('should return decimal input', () {
        testSession.updateState(
          const KeypadState(input: '123.456', hasDecimal: true),
        );
        final result = useCase.getCurrentInput(testSession);
        expect(result, equals('123.456'));
      });

      test('should return input with leading zero', () {
        testSession.updateState(const KeypadState(input: '0.123'));
        final result = useCase.getCurrentInput(testSession);
        expect(result, equals('0.123'));
      });
    });

    group('Current Numeric Value Retrieval', () {
      test('should return null for empty session', () {
        final result = useCase.getCurrentNumericValue(testSession);
        expect(result, isNull);
      });

      test('should return correct numeric value for integer', () {
        testSession.updateState(const KeypadState(input: '123', isValid: true));
        final result = useCase.getCurrentNumericValue(testSession);
        expect(result, equals(123.0));
      });

      test('should return correct numeric value for decimal', () {
        testSession.updateState(
          const KeypadState(input: '123.45', isValid: true),
        );
        final result = useCase.getCurrentNumericValue(testSession);
        expect(result, equals(123.45));
      });

      test('should return correct numeric value for negative', () {
        testSession.updateState(
          const KeypadState(input: '-789.123', isValid: true, isNegative: true),
        );
        final result = useCase.getCurrentNumericValue(testSession);
        expect(result, equals(-789.123));
      });

      test('should return zero for zero input', () {
        testSession.updateState(const KeypadState(input: '0', isValid: true));
        final result = useCase.getCurrentNumericValue(testSession);
        expect(result, equals(0.0));
      });

      test('should return null for invalid input', () {
        testSession.updateState(
          const KeypadState(input: '123', isValid: false),
        );
        final result = useCase.getCurrentNumericValue(testSession);
        expect(result, isNull);
      });

      test('should return null for non-numeric input', () {
        testSession.updateState(const KeypadState(input: 'abc', isValid: true));
        final result = useCase.getCurrentNumericValue(testSession);
        expect(result, isNull);
      });

      test('should handle very large numbers', () {
        testSession.updateState(
          const KeypadState(input: '999999999999', isValid: true),
        );
        final result = useCase.getCurrentNumericValue(testSession);
        expect(result, equals(999999999999.0));
      });

      test('should handle very small numbers', () {
        testSession.updateState(
          const KeypadState(input: '0.000001', isValid: true),
        );
        final result = useCase.getCurrentNumericValue(testSession);
        expect(result, equals(0.000001));
      });
    });

    group('Session Completion Status', () {
      test('should return false for empty session', () {
        final result = useCase.isSessionComplete(testSession);
        expect(result, isFalse);
      });

      test('should return true for valid non-empty input', () {
        testSession.updateState(const KeypadState(input: '123', isValid: true));
        final result = useCase.isSessionComplete(testSession);
        expect(result, isTrue);
      });

      test('should return false for invalid input', () {
        testSession.updateState(
          const KeypadState(
            input: '123',
            isValid: false,
            error: MaxDigitsExceededError(2),
          ),
        );
        final result = useCase.isSessionComplete(testSession);
        expect(result, isFalse);
      });

      test('should return false for empty but valid input', () {
        testSession.updateState(const KeypadState(input: '', isValid: true));
        final result = useCase.isSessionComplete(testSession);
        expect(result, isFalse);
      });

      test('should return true for decimal input', () {
        testSession.updateState(
          const KeypadState(input: '123.45', isValid: true, hasDecimal: true),
        );
        final result = useCase.isSessionComplete(testSession);
        expect(result, isTrue);
      });

      test('should return true for negative input', () {
        testSession.updateState(
          const KeypadState(input: '-123', isValid: true, isNegative: true),
        );
        final result = useCase.isSessionComplete(testSession);
        expect(result, isTrue);
      });

      test('should return true for zero input when valid', () {
        testSession.updateState(const KeypadState(input: '0', isValid: true));
        final result = useCase.isSessionComplete(testSession);
        expect(result, isTrue);
      });
    });

    group('Input Validity Status', () {
      test('should return true for new session', () {
        final result = useCase.hasValidInput(testSession);
        expect(result, isTrue);
      });

      test('should return true for valid input', () {
        testSession.updateState(const KeypadState(input: '123', isValid: true));
        final result = useCase.hasValidInput(testSession);
        expect(result, isTrue);
      });

      test('should return false for invalid input', () {
        testSession.updateState(
          const KeypadState(
            input: '123456',
            isValid: false,
            error: MaxDigitsExceededError(5),
          ),
        );
        final result = useCase.hasValidInput(testSession);
        expect(result, isFalse);
      });

      test('should return true for empty valid input', () {
        testSession.updateState(const KeypadState(input: '', isValid: true));
        final result = useCase.hasValidInput(testSession);
        expect(result, isTrue);
      });

      test('should return false when error present', () {
        testSession.updateState(
          const KeypadState(
            input: '0',
            isValid: false,
            error: ZeroNotAllowedError(),
          ),
        );
        final result = useCase.hasValidInput(testSession);
        expect(result, isFalse);
      });
    });

    group('Display Text Retrieval', () {
      test('should return "0" for empty session', () {
        final result = useCase.getDisplayText(testSession);
        expect(result, equals('0'));
      });

      test('should return actual input when not empty', () {
        testSession.updateState(const KeypadState(input: '123.45'));
        final result = useCase.getDisplayText(testSession);
        expect(result, equals('123.45'));
      });

      test('should return negative display text', () {
        testSession.updateState(
          const KeypadState(input: '-789', isNegative: true),
        );
        final result = useCase.getDisplayText(testSession);
        expect(result, equals('-789'));
      });

      test('should return decimal-only display text', () {
        testSession.updateState(
          const KeypadState(input: '.', hasDecimal: true),
        );
        final result = useCase.getDisplayText(testSession);
        expect(result, equals('.'));
      });

      test('should return "0" after clearing', () {
        testSession.updateState(const KeypadState(input: '123'));
        testSession.updateState(const KeypadState());
        final result = useCase.getDisplayText(testSession);
        expect(result, equals('0'));
      });

      test('should handle leading zero display', () {
        testSession.updateState(const KeypadState(input: '0123'));
        final result = useCase.getDisplayText(testSession);
        expect(result, equals('0123'));
      });
    });

    group('Multiple Session Operations', () {
      test('should handle multiple sessions correctly', () {
        final session1 = KeypadSession(id: 'session-1', config: testConfig);
        final session2 = KeypadSession(id: 'session-2', config: testConfig);

        session1.updateState(const KeypadState(input: '111'));
        session2.updateState(const KeypadState(input: '222'));

        expect(useCase.getSessionId(session1), equals('session-1'));
        expect(useCase.getSessionId(session2), equals('session-2'));
        expect(useCase.getCurrentInput(session1), equals('111'));
        expect(useCase.getCurrentInput(session2), equals('222'));
      });

      test('should handle session state changes', () {
        testSession.updateState(const KeypadState(input: '123', isValid: true));
        expect(useCase.isSessionComplete(testSession), isTrue);
        expect(useCase.hasValidInput(testSession), isTrue);

        testSession.updateState(
          const KeypadState(
            input: '123456',
            isValid: false,
            error: MaxDigitsExceededError(5),
          ),
        );
        expect(useCase.isSessionComplete(testSession), isFalse);
        expect(useCase.hasValidInput(testSession), isFalse);
      });
    });

    group('Use Case Behavior', () {
      test('should be pure and not modify session', () {
        const originalState = KeypadState(input: '123', isValid: true);
        testSession.updateState(originalState);

        useCase.getSessionId(testSession);
        useCase.getCurrentInput(testSession);
        useCase.getCurrentNumericValue(testSession);
        useCase.isSessionComplete(testSession);
        useCase.hasValidInput(testSession);
        useCase.getDisplayText(testSession);

        // Session should remain unchanged
        expect(testSession.currentState, equals(originalState));
        expect(testSession.id, equals('test-session-123'));
      });

      test('should be deterministic', () {
        testSession.updateState(
          const KeypadState(input: '123.45', isValid: true),
        );

        final id1 = useCase.getSessionId(testSession);
        final id2 = useCase.getSessionId(testSession);
        expect(id1, equals(id2));

        final input1 = useCase.getCurrentInput(testSession);
        final input2 = useCase.getCurrentInput(testSession);
        expect(input1, equals(input2));

        final value1 = useCase.getCurrentNumericValue(testSession);
        final value2 = useCase.getCurrentNumericValue(testSession);
        expect(value1, equals(value2));

        final complete1 = useCase.isSessionComplete(testSession);
        final complete2 = useCase.isSessionComplete(testSession);
        expect(complete1, equals(complete2));
      });

      test('should handle null values gracefully', () {
        // Test with session that has null numeric value
        testSession.updateState(const KeypadState(input: 'invalid'));

        expect(
          () => useCase.getCurrentNumericValue(testSession),
          returnsNormally,
        );
        expect(useCase.getCurrentNumericValue(testSession), isNull);
      });
    });

    group('Edge Cases', () {
      test('should handle very long input correctly', () {
        final longInput = '1' * 1000;
        testSession.updateState(KeypadState(input: longInput, isValid: true));

        expect(useCase.getCurrentInput(testSession), equals(longInput));
        expect(useCase.getDisplayText(testSession), equals(longInput));
        expect(useCase.getCurrentNumericValue(testSession), isNotNull);
      });

      test('should handle special numeric formats', () {
        const testCases = ['0.0', '000', '.5', '0.', '-0'];

        for (final input in testCases) {
          testSession.updateState(KeypadState(input: input, isValid: true));

          expect(useCase.getCurrentInput(testSession), equals(input));
          expect(useCase.getDisplayText(testSession), equals(input));
        }
      });

      test('should handle Unicode characters in input', () {
        testSession.updateState(const KeypadState(input: '123π'));

        expect(useCase.getCurrentInput(testSession), equals('123π'));
        expect(useCase.getDisplayText(testSession), equals('123π'));
        expect(useCase.getCurrentNumericValue(testSession), isNull);
      });

      test('should handle session with initial state', () {
        final initialState = const KeypadState(input: '999', isValid: true);
        final sessionWithInitial = KeypadSession(
          id: 'initial-session',
          config: testConfig,
          initialState: initialState,
        );

        expect(useCase.getCurrentInput(sessionWithInitial), equals('999'));
        expect(useCase.isSessionComplete(sessionWithInitial), isTrue);
        expect(
          useCase.getCurrentNumericValue(sessionWithInitial),
          equals(999.0),
        );
      });
    });

    group('Comprehensive Session Info', () {
      test('should provide complete session information', () {
        const complexState = KeypadState(
          input: '-123.45',
          isValid: true,
          hasDecimal: true,
          isNegative: true,
        );
        testSession.updateState(complexState);

        expect(useCase.getSessionId(testSession), equals('test-session-123'));
        expect(useCase.getCurrentInput(testSession), equals('-123.45'));
        expect(useCase.getCurrentNumericValue(testSession), equals(-123.45));
        expect(useCase.isSessionComplete(testSession), isTrue);
        expect(useCase.hasValidInput(testSession), isTrue);
        expect(useCase.getDisplayText(testSession), equals('-123.45'));
      });

      test('should handle invalid session information', () {
        const invalidState = KeypadState(
          input: '12345678',
          isValid: false,
          error: MaxDigitsExceededError(5),
        );
        testSession.updateState(invalidState);

        expect(useCase.getSessionId(testSession), equals('test-session-123'));
        expect(useCase.getCurrentInput(testSession), equals('12345678'));
        expect(useCase.getCurrentNumericValue(testSession), isNull);
        expect(useCase.isSessionComplete(testSession), isFalse);
        expect(useCase.hasValidInput(testSession), isFalse);
        expect(useCase.getDisplayText(testSession), equals('12345678'));
      });
    });
  });
}
