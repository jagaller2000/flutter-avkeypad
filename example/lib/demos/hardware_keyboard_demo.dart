import 'package:flutter/material.dart';
import 'package:avkeypad/avkeypad.dart';
import '../widgets/keypad_demo_base.dart';

/// Hardware keyboard demo showing keyboard input support
class HardwareKeyboardDemo extends KeypadDemoPage {
  const HardwareKeyboardDemo({super.key});

  @override
  State<HardwareKeyboardDemo> createState() => _HardwareKeyboardDemoState();
}

class _HardwareKeyboardDemoState extends KeypadDemoPageState<HardwareKeyboardDemo> {
  bool _hardwareKeyboardEnabled = true;

  @override
  Widget build(BuildContext context) {
    return buildKeypadDemo(
      context: context,
      title: 'Hardware Keyboard Support',
      description:
          'This keypad supports both touch and hardware keyboard input. '
          'Try using your physical keyboard:\n'
          '• Number keys (0-9) for digits\n'
          '• Period (.) or comma (,) for decimal\n'
          '• Backspace to delete\n'
          '• Escape to clear all\n'
          '• Minus (-) to toggle sign\n\n'
          'Click on the keypad to focus it for keyboard input.',
      config: const KeypadConfig(
        showDecimalKey: true,
        showSignKey: true,
        showCancelKey: false,
        allowNegative: true,
        maxDigits: 8,
        maxDecimalPlaces: 3,
      ),
      enableHardwareKeyboard: _hardwareKeyboardEnabled,
      additionalControls: [
        SwitchListTile(
          title: const Text('Hardware Keyboard'),
          subtitle: const Text('Enable/disable keyboard input'),
          value: _hardwareKeyboardEnabled,
          onChanged: (value) {
            setState(() {
              _hardwareKeyboardEnabled = value;
            });
          },
        ),
        if (!_hardwareKeyboardEnabled)
          const ListTile(
            leading: Icon(Icons.info_outline, color: Colors.orange),
            title: Text('Hardware keyboard disabled'),
            subtitle: Text('Only touch input will work'),
            dense: true,
          ),
      ],
    );
  }
}