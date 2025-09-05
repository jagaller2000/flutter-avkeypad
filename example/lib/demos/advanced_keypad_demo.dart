import 'package:flutter/material.dart';
import 'package:avkeypad/avkeypad.dart';
import '../widgets/keypad_demo_base.dart';

/// Advanced keypad demo with all features enabled
class AdvancedKeypadDemo extends KeypadDemoPage {
  const AdvancedKeypadDemo({super.key});

  @override
  State<AdvancedKeypadDemo> createState() => _AdvancedKeypadDemoState();
}

class _AdvancedKeypadDemoState extends KeypadDemoPageState<AdvancedKeypadDemo> {
  @override
  Widget build(BuildContext context) {
    return buildKeypadDemo(
      context: context,
      title: 'Advanced Features',
      description:
          'All features enabled: signed numbers, decimal support, '
          'input constraints, and all action buttons. Maximum 6 digits with 3 decimal places. '
          'This demonstrates the full capabilities of the keypad widget.',
      config: const KeypadConfig(
        showSignKey: true,
        allowNegative: true,
        showDecimalKey: true,
        maxDigits: 6,
        maxDecimalPlaces: 3,
        showBackspaceKey: true,
        showClearKey: true,
        
        showCancelKey: true,
      ),
    );
  }
}
