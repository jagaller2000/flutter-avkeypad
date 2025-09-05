import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/domain.dart';
import '../../infrastructure/adapters/traditional_keypad_adapter.dart';
import 'keypad_key_widget.dart';
import 'keypad_display_widget.dart';

/// A traditional keypad widget with action buttons in a separate bottom row
class TraditionalKeypadWidget extends StatefulWidget {
  const TraditionalKeypadWidget({
    super.key,
    required this.config,
    this.onKeyPressed,
    this.onValueChanged,
    this.onConfirm,
    this.onCancel,
    this.displayWidget,
    this.keyBuilder,
  });

  /// Configuration for the keypad
  final KeypadConfig config;

  /// Callback when a key is pressed
  final void Function(KeypadKey)? onKeyPressed;

  /// Callback when the value changes
  final void Function(String)? onValueChanged;

  /// Callback when confirm is pressed
  final void Function(String)? onConfirm;

  /// Callback when cancel is pressed
  final VoidCallback? onCancel;

  /// Custom display widget (optional)
  final Widget? displayWidget;

  /// Custom key builder (optional)
  final Widget Function(KeypadKey, VoidCallback)? keyBuilder;

  @override
  State<TraditionalKeypadWidget> createState() =>
      _TraditionalKeypadWidgetState();
}

class _TraditionalKeypadWidgetState extends State<TraditionalKeypadWidget> {
  late KeypadSession _session;
  late KeypadPort _adapter;
  late KeypadState _currentState;
  late List<List<KeypadKey>> _layout;

  static const _processInputUseCase = ProcessKeypadInputUseCase();
  static const _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _adapter = TraditionalKeypadAdapter();
    _session = KeypadSession(id: _uuid.v4(), config: widget.config);
    _currentState = _session.currentState;
    _updateLayout();
  }

  @override
  void didUpdateWidget(TraditionalKeypadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _session = KeypadSession(id: _uuid.v4(), config: widget.config);
      _currentState = _session.currentState;
      _updateLayout();
    }
  }

  void _updateLayout() {
    _layout = _adapter.getKeypadLayout(widget.config);
  }

  KeypadAction _createActionFromKey(KeypadKey key) {
    switch (key.type) {
      case KeypadKeyType.digit:
        return KeypadAction(
          type: KeypadActionType.digitInput,
          value: key.value,
          key: key.value,
        );
      case KeypadKeyType.decimal:
        return KeypadAction(
          type: KeypadActionType.decimalInput,
          value: key.value,
          key: key.value,
        );
      case KeypadKeyType.backspace:
        return const KeypadAction(
          type: KeypadActionType.backspace,
          key: 'backspace',
        );
      case KeypadKeyType.clear:
        return const KeypadAction(type: KeypadActionType.clear, key: 'clear');
      case KeypadKeyType.sign:
        return const KeypadAction(
          type: KeypadActionType.toggleSign,
          key: 'sign',
        );
      case KeypadKeyType.confirm:
        return const KeypadAction(
          type: KeypadActionType.confirm,
          key: 'confirm',
        );
      case KeypadKeyType.cancel:
        return const KeypadAction(type: KeypadActionType.cancel, key: 'cancel');
      case KeypadKeyType.custom:
        return KeypadAction(
          type: KeypadActionType.custom,
          value: key.value,
          key: key.value,
        );
    }
  }

  void _handleKeyPress(KeypadKey key) {
    widget.onKeyPressed?.call(key);

    final action = _createActionFromKey(key);
    final newState = _processInputUseCase(
      currentState: _currentState,
      action: action,
      config: widget.config,
    );

    setState(() {
      _currentState = newState;
      _session.updateState(newState);
    });

    widget.onValueChanged?.call(_currentState.input);

    // Handle confirm action
    if (key.type == KeypadKeyType.confirm) {
      widget.onConfirm?.call(_currentState.input);
    }

    // Handle cancel action
    if (key.type == KeypadKeyType.cancel) {
      widget.onCancel?.call();
    }
  }

  Widget _buildKeypadGrid() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _layout.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              return SizedBox(
                width: 60,
                height: 50,
                child:
                    widget.keyBuilder?.call(key, () => _handleKeyPress(key)) ??
                    KeypadKeyWidget(
                      keypadKey: key,
                      onPressed: () => _handleKeyPress(key),
                    ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display widget
        if (widget.displayWidget != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: widget.displayWidget!,
          )
        else
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: KeypadDisplayWidget(state: _currentState),
          ),

        // Keypad grid
        _buildKeypadGrid(),
      ],
    );
  }
}
