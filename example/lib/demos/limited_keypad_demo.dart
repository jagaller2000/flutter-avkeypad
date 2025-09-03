import 'package:flutter/material.dart';
import 'package:avkeypad/avkeypad.dart';
import '../widgets/keypad_demo_base.dart';

/// Limited keypad demo with input constraints
class LimitedKeypadDemo extends KeypadDemoPage {
  const LimitedKeypadDemo({super.key});

  @override
  State<LimitedKeypadDemo> createState() => _LimitedKeypadDemoState();
}

class _LimitedKeypadDemoState extends KeypadDemoPageState<LimitedKeypadDemo> {
  @override
  Widget build(BuildContext context) {
    return buildKeypadDemo(
      context: context,
      title: 'Input Constraints',
      description:
          'Demonstrates input validation and constraints. '
          'Limited to 4 digits maximum with 1 decimal place. '
          'Zero values are not allowed, showcasing validation rules.',
      config: const KeypadConfig(
        showDecimalKey: true,
        maxDigits: 4,
        maxDecimalPlaces: 1,
        allowZero: false,
        showBackspaceKey: true,
        showClearKey: true,
        showConfirmKey: true,
        showCancelKey: true,
      ),
    );
  }
}
