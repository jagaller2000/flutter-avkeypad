import 'package:flutter/material.dart';
import 'package:avkeypad/avkeypad.dart';
import '../widgets/keypad_demo_base.dart';

/// Step size 2 keypad demo - even numbers only
class StepSize2KeypadDemo extends KeypadDemoPage {
  const StepSize2KeypadDemo({super.key});

  @override
  State<StepSize2KeypadDemo> createState() => _StepSize2KeypadDemoState();
}

class _StepSize2KeypadDemoState
    extends KeypadDemoPageState<StepSize2KeypadDemo> {
  @override
  Widget build(BuildContext context) {
    return buildKeypadDemo(
      context: context,
      title: 'Step Size: Even Numbers',
      description:
          'Only even numbers are allowed (step size = 2). '
          'Try entering numbers like 2, 4, 6, 8, 10, etc. '
          'Odd numbers will be marked as invalid and cannot be confirmed. '
          'Negative even numbers are also supported.',
      config: const KeypadConfig(
        stepSize: 2.0,
        showDecimalKey: false,
        allowNegative: true,
        showSignKey: true,
        showBackspaceKey: true,
        showClearKey: true,
        showConfirmKey: true,
        showCancelKey: true,
      ),
    );
  }
}
