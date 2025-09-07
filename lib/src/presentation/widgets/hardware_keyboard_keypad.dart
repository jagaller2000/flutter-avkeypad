import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/domain.dart';

/// A wrapper widget that adds hardware keyboard support to any keypad widget
class HardwareKeyboardKeypad extends StatefulWidget {
  const HardwareKeyboardKeypad({
    super.key,
    required this.child,
    required this.onKeypadAction,
    this.enabled = true,
    this.autofocus = true,
  });

  /// The child keypad widget to wrap
  final Widget child;

  /// Callback for handling keypad actions from hardware keyboard
  final ValueChanged<KeypadAction> onKeypadAction;

  /// Whether hardware keyboard input is enabled
  final bool enabled;

  /// Whether the widget should automatically receive focus
  final bool autofocus;

  @override
  State<HardwareKeyboardKeypad> createState() => _HardwareKeyboardKeypadState();
}

class _HardwareKeyboardKeypadState extends State<HardwareKeyboardKeypad> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// Maps keyboard keys to keypad actions
  KeypadAction? _mapKeyToAction(KeyEvent event) {
    if (!widget.enabled || event is! KeyDownEvent) {
      return null;
    }

    final key = event.logicalKey;

    // Digit keys (0-9)
    if (key == LogicalKeyboardKey.digit0 || key == LogicalKeyboardKey.numpad0) {
      return const KeypadAction(
        type: KeypadActionType.digitInput,
        value: '0',
        key: '0',
      );
    }
    if (key == LogicalKeyboardKey.digit1 || key == LogicalKeyboardKey.numpad1) {
      return const KeypadAction(
        type: KeypadActionType.digitInput,
        value: '1',
        key: '1',
      );
    }
    if (key == LogicalKeyboardKey.digit2 || key == LogicalKeyboardKey.numpad2) {
      return const KeypadAction(
        type: KeypadActionType.digitInput,
        value: '2',
        key: '2',
      );
    }
    if (key == LogicalKeyboardKey.digit3 || key == LogicalKeyboardKey.numpad3) {
      return const KeypadAction(
        type: KeypadActionType.digitInput,
        value: '3',
        key: '3',
      );
    }
    if (key == LogicalKeyboardKey.digit4 || key == LogicalKeyboardKey.numpad4) {
      return const KeypadAction(
        type: KeypadActionType.digitInput,
        value: '4',
        key: '4',
      );
    }
    if (key == LogicalKeyboardKey.digit5 || key == LogicalKeyboardKey.numpad5) {
      return const KeypadAction(
        type: KeypadActionType.digitInput,
        value: '5',
        key: '5',
      );
    }
    if (key == LogicalKeyboardKey.digit6 || key == LogicalKeyboardKey.numpad6) {
      return const KeypadAction(
        type: KeypadActionType.digitInput,
        value: '6',
        key: '6',
      );
    }
    if (key == LogicalKeyboardKey.digit7 || key == LogicalKeyboardKey.numpad7) {
      return const KeypadAction(
        type: KeypadActionType.digitInput,
        value: '7',
        key: '7',
      );
    }
    if (key == LogicalKeyboardKey.digit8 || key == LogicalKeyboardKey.numpad8) {
      return const KeypadAction(
        type: KeypadActionType.digitInput,
        value: '8',
        key: '8',
      );
    }
    if (key == LogicalKeyboardKey.digit9 || key == LogicalKeyboardKey.numpad9) {
      return const KeypadAction(
        type: KeypadActionType.digitInput,
        value: '9',
        key: '9',
      );
    }

    // Decimal point
    if (key == LogicalKeyboardKey.period || 
        key == LogicalKeyboardKey.numpadDecimal ||
        key == LogicalKeyboardKey.comma) {
      return const KeypadAction(
        type: KeypadActionType.decimalInput,
        key: 'decimal',
      );
    }

    // Backspace
    if (key == LogicalKeyboardKey.backspace) {
      return const KeypadAction(
        type: KeypadActionType.backspace,
        key: 'backspace',
      );
    }

    // Clear (Escape key)
    if (key == LogicalKeyboardKey.escape) {
      return const KeypadAction(
        type: KeypadActionType.clear,
        key: 'clear',
      );
    }

    // Plus/minus toggle (on minus key)
    if (key == LogicalKeyboardKey.minus || key == LogicalKeyboardKey.numpadSubtract) {
      return const KeypadAction(
        type: KeypadActionType.toggleSign,
        key: 'toggleSign',
      );
    }

    return null;
  }

  bool _handleKeyEvent(KeyEvent event) {
    final action = _mapKeyToAction(event);
    if (action != null) {
      widget.onKeypadAction(action);
      return true; // Consume the event
    }
    return false; // Let other widgets handle the event
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: (node, event) {
        return _handleKeyEvent(event) 
            ? KeyEventResult.handled 
            : KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: () {
          // Ensure focus when tapped
          if (widget.enabled) {
            _focusNode.requestFocus();
          }
        },
        child: widget.child,
      ),
    );
  }
}