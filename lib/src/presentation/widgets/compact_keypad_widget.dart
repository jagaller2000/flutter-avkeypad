import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/domain.dart';
import '../../infrastructure/adapters/compact_keypad_adapter.dart';
import 'keypad_key_widget.dart';
import 'keypad_display_widget.dart';

/// A compact keypad widget with action buttons integrated around the display
class CompactKeypadWidget extends StatefulWidget {
  const CompactKeypadWidget({
    super.key,
    required this.config,
    this.onKeyPressed,
    this.onValueChanged,
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

  /// Callback when cancel is pressed
  final VoidCallback? onCancel;

  /// Custom display widget (optional)
  final Widget? displayWidget;

  /// Custom key builder (optional)
  final Widget Function(KeypadKey, VoidCallback)? keyBuilder;

  @override
  State<CompactKeypadWidget> createState() => _CompactKeypadWidgetState();
}

class _CompactKeypadWidgetState extends State<CompactKeypadWidget> {
  late KeypadSession _session;
  late KeypadPort _adapter;
  late KeypadState _currentState;
  late List<List<KeypadKey>> _layout;
  late List<KeypadKey> _actionKeys;

  static const _processInputUseCase = ProcessKeypadInputUseCase();
  static const _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _adapter = CompactKeypadAdapter();
    _session = KeypadSession(id: _uuid.v4(), config: widget.config);
    _currentState = _session.currentState;
    _updateLayout();
  }

  @override
  void didUpdateWidget(CompactKeypadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _session = KeypadSession(id: _uuid.v4(), config: widget.config);
      _currentState = _session.currentState;
      _updateLayout();
    }
  }

  void _updateLayout() {
    _layout = _adapter.getKeypadLayout(widget.config);
    _actionKeys = (_adapter as CompactKeypadAdapter).getDisplayActionKeys(
      widget.config,
    );
  }

  @visibleForTesting
  KeypadAction createActionFromKey(KeypadKey key) {
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

  @visibleForTesting
  void handleKeyPress(KeypadKey key) {
    widget.onKeyPressed?.call(key);

    final action = createActionFromKey(key);
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

    // Handle cancel action
    // Handle cancel action
    if (key.type == KeypadKeyType.cancel) {
      widget.onCancel?.call();
    }
  }

  Widget _buildActionButton(KeypadKey key) {
    return SizedBox(
      width: 32,
      height: 32,
      child:
          widget.keyBuilder?.call(key, () => handleKeyPress(key)) ??
          KeypadKeyWidget(keypadKey: key, onPressed: () => handleKeyPress(key)),
    );
  }

  Widget _buildDisplayArea() {
    return Row(
      children: [
        // Clear button on the left
        if (widget.config.showClearKey)
          _buildActionButton(
            const KeypadKey(
              value: 'clear',
              type: KeypadKeyType.clear,
              displayText: 'C',
            ),
          ),

        if (widget.config.showClearKey) const SizedBox(width: 8),

        // Display widget in the center
        Expanded(
          child:
              widget.displayWidget ?? KeypadDisplayWidget(state: _currentState),
        ),

        // Backspace button on the right
        if (_actionKeys.any((k) => k.type == KeypadKeyType.backspace))
          const SizedBox(width: 8),

        if (_actionKeys.any((k) => k.type == KeypadKeyType.backspace))
          _buildActionButton(
            _actionKeys.firstWhere((k) => k.type == KeypadKeyType.backspace),
          ),
      ],
    );
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
                    widget.keyBuilder?.call(key, () => handleKeyPress(key)) ??
                    KeypadKeyWidget(
                      keypadKey: key,
                      onPressed: () => handleKeyPress(key),
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
        // Display area with integrated action buttons
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildDisplayArea(),
        ),

        // Keypad grid
        _buildKeypadGrid(),
      ],
    );
  }
}
