import '../value_objects/keypad_config.dart';
import '../value_objects/keypad_state.dart';

/// Represents a keypad session from a user perspective
/// This is an entity because it has identity and lifecycle
class KeypadSession {
  KeypadSession({
    required this.id,
    required this.config,
    KeypadState? initialState,
  }) : currentState = initialState ?? const KeypadState();

  /// Unique identifier for this keypad session
  final String id;

  /// Configuration for this keypad session
  final KeypadConfig config;

  /// Current state of input in this session
  KeypadState currentState;

  /// Update the current state
  void updateState(KeypadState newState) {
    currentState = newState;
  }

  /// Check if the session is complete (has valid input)
  bool get isComplete => currentState.isValid && currentState.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KeypadSession && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'KeypadSession(id: $id, currentState: $currentState)';
  }
}
