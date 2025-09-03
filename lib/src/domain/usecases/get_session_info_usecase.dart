import '../entities/keypad_session.dart';

/// Use case for querying keypad session information
class GetSessionInfoUseCase {
  const GetSessionInfoUseCase();

  /// Get session ID
  String getSessionId(KeypadSession session) => session.id;

  /// Get current input value
  String getCurrentInput(KeypadSession session) => session.currentState.input;

  /// Get current numeric value
  double? getCurrentNumericValue(KeypadSession session) =>
      session.currentState.numericValue;

  /// Check if session is complete
  bool isSessionComplete(KeypadSession session) => session.isComplete;

  /// Check if session has valid input
  bool hasValidInput(KeypadSession session) => session.currentState.isValid;

  /// Get current display text
  String getDisplayText(KeypadSession session) =>
      session.currentState.displayText;
}
