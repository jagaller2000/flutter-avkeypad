import 'package:flutter/material.dart';
import 'package:avkeypad/avkeypad.dart';
import '../widgets/keypad_demo_base.dart';

/// Decimal keypad demo with decimal point support
class DecimalKeypadDemo extends KeypadDemoPage {
  const DecimalKeypadDemo({super.key});

  @override
  State<DecimalKeypadDemo> createState() => _DecimalKeypadDemoState();
}

class _DecimalKeypadDemoState extends KeypadDemoPageState<DecimalKeypadDemo> {
  @override
  Widget build(BuildContext context) {
    return buildKeypadDemo(
      context: context,
      title: 'Decimal Support',
      description:
          'Numeric keypad with decimal point support. '
          'Allows entering decimal numbers with up to 2 decimal places.',
      keypadDescription: 'Enter currency amount (e.g., 123.45)',
      config: const KeypadConfig(
        showDecimalKey: true,
        maxDecimalPlaces: 2,
        showCancelKey: true,
      ),
    );
  }
}
