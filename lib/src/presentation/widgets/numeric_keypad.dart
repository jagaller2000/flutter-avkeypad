import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/domain.dart';
import 'keypad_container_widget.dart';

/// A numeric keypad widget following Material 3 design
class NumericKeypad extends StatefulWidget {
  const NumericKeypad({
    super.key,
    this.config = const KeypadConfig(),
    this.onValueChanged,
    this.onCancel,
    this.description,
  });

  /// Configuration for the keypad
  final KeypadConfig config;

  /// Callback when the input value changes
  final ValueChanged<String>? onValueChanged;

  /// Callback when cancel is pressed
  final VoidCallback? onCancel;

  /// Optional description text to display alongside the keypad
  final String? description;

  @override
  State<NumericKeypad> createState() => _NumericKeypadState();
}

class _NumericKeypadState extends State<NumericKeypad> {
  late final KeypadSession _session;
  late final CreateKeypadSessionUseCase _createSessionUseCase;
  late final UpdateKeypadSessionUseCase _updateSessionUseCase;
  late final GetSessionInfoUseCase _getSessionInfoUseCase;
  late final ProcessKeypadInputUseCase _inputUseCase;
  late final ValidateKeypadInputUseCase _validateUseCase;

  @override
  void initState() {
    super.initState();

    // Initialize use cases
    _createSessionUseCase = const CreateKeypadSessionUseCase();
    _updateSessionUseCase = const UpdateKeypadSessionUseCase();
    _getSessionInfoUseCase = const GetSessionInfoUseCase();
    _inputUseCase = const ProcessKeypadInputUseCase();
    _validateUseCase = const ValidateKeypadInputUseCase();

    // Create session through use case
    const uuid = Uuid();
    _session = _createSessionUseCase(
      sessionId: uuid.v4(),
      config: widget.config,
    );
  }

  void _handleKeyPress(KeypadKey key) {
    final action = _createActionForKey(key);
    _processAction(action);
  }

  KeypadAction _createActionForKey(KeypadKey key) {
    switch (key.type) {
      case KeypadKeyType.digit:
        return KeypadAction(
          type: KeypadActionType.digitInput,
          value: key.value,
          key: key.value,
        );
      case KeypadKeyType.decimal:
        return const KeypadAction(type: KeypadActionType.decimalInput);
      case KeypadKeyType.backspace:
        return const KeypadAction(type: KeypadActionType.backspace);
      case KeypadKeyType.clear:
        return const KeypadAction(type: KeypadActionType.clear);
      case KeypadKeyType.sign:
        return const KeypadAction(type: KeypadActionType.toggleSign);
      case KeypadKeyType.cancel:
        return const KeypadAction(type: KeypadActionType.cancel);
      case KeypadKeyType.custom:
        return KeypadAction(
          type: KeypadActionType.custom,
          value: key.value,
          key: key.value,
        );
    }
  }

  void _processAction(KeypadAction action) {
    if (action.type == KeypadActionType.cancel) {
      widget.onCancel?.call();
      return;
    }

    // Process the input action
    final newState = _inputUseCase(
      currentState: _session.currentState,
      action: action,
      config: widget.config,
    );

    // Validate the new state
    final validatedState = _validateUseCase(
      currentState: newState,
      config: widget.config,
    );

    // Update session through use case
    setState(() {
      _updateSessionUseCase(session: _session, newState: validatedState);
    });

    // Notify parent of value change
    widget.onValueChanged?.call(
      _getSessionInfoUseCase.getCurrentInput(_session),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeypadContainerWidget(
      state: _session.currentState,
      config: widget.config,
      onKeyPressed: _handleKeyPress,
      description: widget.description,
    );
  }
}
