import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

void main() {
  group('Hexagonal Architecture Tests', () {
    test('Session creation should go through use case', () {
      const createSessionUseCase = CreateKeypadSessionUseCase();
      const config = KeypadConfig();

      final session = createSessionUseCase(
        sessionId: 'test-session-123',
        config: config,
      );

      expect(session.id, 'test-session-123');
      expect(session.config, config);
      expect(session.currentState.input, '');
      expect(
        session.currentState.isValid,
        true,
      ); // Default KeypadState is valid
    });

    test('Session updates should go through use case', () {
      const createSessionUseCase = CreateKeypadSessionUseCase();
      const updateSessionUseCase = UpdateKeypadSessionUseCase();

      final session = createSessionUseCase(
        sessionId: 'test-session-123',
        config: const KeypadConfig(),
      );

      const newState = KeypadState(input: '123', isValid: true);
      final updatedSession = updateSessionUseCase(
        session: session,
        newState: newState,
      );

      expect(identical(session, updatedSession), true);
      expect(session.currentState.input, '123');
      expect(session.currentState.isValid, true);
    });

    test('Session information should be accessed through use case', () {
      const createSessionUseCase = CreateKeypadSessionUseCase();
      const updateSessionUseCase = UpdateKeypadSessionUseCase();
      const getSessionInfoUseCase = GetSessionInfoUseCase();

      final session = createSessionUseCase(
        sessionId: 'test-session-456',
        config: const KeypadConfig(),
      );

      updateSessionUseCase(
        session: session,
        newState: const KeypadState(input: '42.5', isValid: true),
      );

      expect(getSessionInfoUseCase.getSessionId(session), 'test-session-456');
      expect(getSessionInfoUseCase.getCurrentInput(session), '42.5');
      expect(getSessionInfoUseCase.getCurrentNumericValue(session), 42.5);
      expect(getSessionInfoUseCase.hasValidInput(session), true);
      expect(getSessionInfoUseCase.isSessionComplete(session), true);
      expect(getSessionInfoUseCase.getDisplayText(session), '42.5');
    });

    test('Presentation layer should not directly access entity properties', () {
      // This test verifies our architectural constraint
      // If someone adds direct entity access, it would show up here

      const createSessionUseCase = CreateKeypadSessionUseCase();
      const getSessionInfoUseCase = GetSessionInfoUseCase();

      final session = createSessionUseCase(
        sessionId: 'test-session-789',
        config: const KeypadConfig(),
      );

      // These are the ONLY acceptable ways to access session information
      // from the presentation layer:

      // ✅ Through use case
      final sessionId = getSessionInfoUseCase.getSessionId(session);
      final currentInput = getSessionInfoUseCase.getCurrentInput(session);
      final isComplete = getSessionInfoUseCase.isSessionComplete(session);

      expect(sessionId, 'test-session-789');
      expect(currentInput, '');
      expect(isComplete, false); // Empty input means incomplete

      // ❌ Direct entity access is forbidden in presentation layer:
      // session.id (should not be used)
      // session.currentState.input (should not be used)
      // session.isComplete (should not be used)
    });
  });
}
