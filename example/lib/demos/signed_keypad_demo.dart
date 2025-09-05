import 'package:flutter/material.dart';
import 'package:avkeypad/avkeypad.dart';
import '../widgets/keypad_demo_base.dart';

/// Signed keypad demo with positive/negative number support
class SignedKeypadDemo extends KeypadDemoPage {
  const SignedKeypadDemo({super.key});

  @override
  State<SignedKeypadDemo> createState() => _SignedKeypadDemoState();
}

class _SignedKeypadDemoState extends KeypadDemoPageState<SignedKeypadDemo> {
  @override
  Widget build(BuildContext context) {
    return buildKeypadDemo(
      context: context,
      title: 'Signed Numbers',
      description:
          'Keypad with support for both positive and negative numbers. '
          'Use the +/- button to toggle between positive and negative values. '
          'Also includes decimal support for complete numeric input.',
      config: const KeypadConfig(
        showSignKey: true,
        allowNegative: true,
        showDecimalKey: true,
        
        showCancelKey: true,
      ),
    );
  }
}
