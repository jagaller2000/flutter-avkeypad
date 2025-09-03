import '../entities/keypad_session.dart';
import '../value_objects/keypad_config.dart';
import '../value_objects/keypad_state.dart';

/// Use case for creating a new keypad session
class CreateKeypadSessionUseCase {
  const CreateKeypadSessionUseCase();

  /// Create a new keypad session with a unique identifier
  KeypadSession call({
    required String sessionId,
    required KeypadConfig config,
    KeypadState? initialState,
  }) {
    return KeypadSession(
      id: sessionId,
      config: config,
      initialState: initialState,
    );
  }
}
