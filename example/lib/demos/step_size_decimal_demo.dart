import 'package:flutter/material.dart';
import 'package:avkeypad/avkeypad.dart';
import '../widgets/keypad_demo_base.dart';

/// Step size 0.1 keypad demo - decimal tenths only
class StepSizeDecimalKeypadDemo extends KeypadDemoPage {
  const StepSizeDecimalKeypadDemo({super.key});

  @override
  State<StepSizeDecimalKeypadDemo> createState() =>
      _StepSizeDecimalKeypadDemoState();
}

class _StepSizeDecimalKeypadDemoState
    extends KeypadDemoPageState<StepSizeDecimalKeypadDemo> {
  @override
  Widget build(BuildContext context) {
    return buildKeypadDemo(
      context: context,
      title: 'Step Size: 0.1 Increments',
      description:
          'Only values in 0.1 increments are allowed (step size = 0.1). '
          'Try entering numbers like 0.1, 0.2, 1.5, 2.7, etc. '
          'Values like 0.15 or 1.23 will be marked as invalid. '
          'Perfect for applications requiring tenth-precision input.',
      config: const KeypadConfig(
        stepSize: 0.1,
        showDecimalKey: true,
        maxDecimalPlaces: 1,
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
