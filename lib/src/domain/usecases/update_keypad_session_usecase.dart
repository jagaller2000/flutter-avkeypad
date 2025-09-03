import '../entities/keypad_session.dart';
import '../value_objects/keypad_state.dart';

/// Use case for updating a keypad session state
class UpdateKeypadSessionUseCase {
  const UpdateKeypadSessionUseCase();

  /// Update the session state and return the updated session
  KeypadSession call({
    required KeypadSession session,
    required KeypadState newState,
  }) {
    session.updateState(newState);
    return session;
  }
}
