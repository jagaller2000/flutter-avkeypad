import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

void main() {
  group('KeypadSession Entity Tests', () {
    late KeypadSession session;
    const testId = 'test-session-123';
    const testConfig = KeypadConfig();

    setUp(() {
      session = KeypadSession(id: testId, config: testConfig);
    });

    group('Constructor', () {
      test('should create session with required parameters', () {
        expect(session.id, equals(testId));
        expect(session.config, equals(testConfig));
        expect(session.currentState, equals(const KeypadState()));
      });

      test('should create session with custom initial state', () {
        const initialState = KeypadState(input: '123', isValid: true);
        final customSession = KeypadSession(
          id: 'custom-id',
          config: testConfig,
          initialState: initialState,
        );

        expect(customSession.currentState, equals(initialState));
      });

      test('should use default empty state if no initial state provided', () {
        expect(session.currentState.input, isEmpty);
        expect(session.currentState.isValid, isTrue);
      });
    });

    group('Identity and Equality', () {
      test('should be equal when IDs are same', () {
        final session1 = KeypadSession(id: 'same-id', config: testConfig);
        final session2 = KeypadSession(id: 'same-id', config: testConfig);

        expect(session1, equals(session2));
        expect(session1.hashCode, equals(session2.hashCode));
      });

      test('should not be equal when IDs are different', () {
        final session1 = KeypadSession(id: 'id-1', config: testConfig);
        final session2 = KeypadSession(id: 'id-2', config: testConfig);

        expect(session1, isNot(equals(session2)));
        expect(session1.hashCode, isNot(equals(session2.hashCode)));
      });

      test('should be equal to itself', () {
        expect(session, equals(session));
        expect(session.hashCode, equals(session.hashCode));
      });

      test('should not be equal to non-KeypadSession objects', () {
        expect(session, isNot(equals('string')));
        expect(session, isNot(equals(123)));
        expect(session, isNot(equals(null)));
      });
    });

    group('State Management', () {
      test('should update current state', () {
        const newState = KeypadState(input: '456', isValid: true);

        session.updateState(newState);

        expect(session.currentState, equals(newState));
      });

      test('should allow multiple state updates', () {
        const state1 = KeypadState(input: '1', isValid: true);
        const state2 = KeypadState(input: '12', isValid: true);
        const state3 = KeypadState(input: '123', isValid: true);

        session.updateState(state1);
        expect(session.currentState, equals(state1));

        session.updateState(state2);
        expect(session.currentState, equals(state2));

        session.updateState(state3);
        expect(session.currentState, equals(state3));
      });

      test('should handle invalid state updates', () {
        const invalidState = KeypadState(input: 'invalid', isValid: false);

        session.updateState(invalidState);

        expect(session.currentState, equals(invalidState));
        expect(session.currentState.isValid, isFalse);
      });
    });

    group('Completion Status', () {
      test('should be incomplete when state is empty', () {
        expect(session.isComplete, isFalse);
      });

      test('should be incomplete when state is invalid', () {
        const invalidState = KeypadState(input: '123', isValid: false);
        session.updateState(invalidState);

        expect(session.isComplete, isFalse);
      });

      test('should be incomplete when state is empty but valid', () {
        const emptyState = KeypadState(input: '', isValid: true);
        session.updateState(emptyState);

        expect(session.isComplete, isFalse);
      });

      test('should be complete when state is valid and not empty', () {
        const validState = KeypadState(input: '123', isValid: true);
        session.updateState(validState);

        expect(session.isComplete, isTrue);
      });

      test('should handle completion status changes', () {
        // Start incomplete
        expect(session.isComplete, isFalse);

        // Become complete
        session.updateState(const KeypadState(input: '123', isValid: true));
        expect(session.isComplete, isTrue);

        // Become incomplete again
        session.updateState(const KeypadState(input: '', isValid: true));
        expect(session.isComplete, isFalse);
      });
    });

    group('String Representation', () {
      test('should have meaningful toString', () {
        const state = KeypadState(input: '123', isValid: true);
        session.updateState(state);

        final result = session.toString();

        expect(result, contains('KeypadSession'));
        expect(result, contains(testId));
        expect(result, contains('123'));
      });

      test('should include current state in string representation', () {
        const state = KeypadState(input: '456', isValid: false);
        session.updateState(state);

        final result = session.toString();

        expect(result, contains('456'));
      });
    });

    group('Immutability', () {
      test('should not allow ID modification after creation', () {
        // ID is final, so this test ensures compiler-level immutability
        expect(session.id, equals(testId));
        // Cannot modify: session.id = 'new-id'; // Would cause compile error
      });

      test('should not allow config modification after creation', () {
        // Config is final, so this test ensures compiler-level immutability
        expect(session.config, equals(testConfig));
        // Cannot modify: session.config = KeypadConfig(); // Would cause compile error
      });

      test('should allow state modification through updateState only', () {
        const originalState = KeypadState();
        expect(session.currentState, equals(originalState));

        const newState = KeypadState(input: '123', isValid: true);
        session.updateState(newState);

        expect(session.currentState, equals(newState));
        expect(session.currentState, isNot(equals(originalState)));
      });
    });

    group('Edge Cases', () {
      test('should handle session with very long ID', () {
        final longId = 'a' * 1000;
        final longIdSession = KeypadSession(id: longId, config: testConfig);

        expect(longIdSession.id, equals(longId));
        expect(longIdSession.id.length, equals(1000));
      });

      test('should handle session with empty string ID', () {
        final emptyIdSession = KeypadSession(id: '', config: testConfig);

        expect(emptyIdSession.id, isEmpty);
      });

      test('should handle session with special characters in ID', () {
        const specialId = 'test-id_123!@#\$%^&*()';
        final specialSession = KeypadSession(id: specialId, config: testConfig);

        expect(specialSession.id, equals(specialId));
      });

      test('should handle rapid state updates', () {
        for (int i = 0; i < 100; i++) {
          final state = KeypadState(input: i.toString(), isValid: true);
          session.updateState(state);
          expect(session.currentState.input, equals(i.toString()));
        }
      });
    });
  });
}
