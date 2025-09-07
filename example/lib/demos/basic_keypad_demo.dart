import 'package:flutter/material.dart';
import 'package:avkeypad/avkeypad.dart';
import '../widgets/keypad_demo_base.dart';

/// Basic keypad demo with minimal configuration
class BasicKeypadDemo extends KeypadDemoPage {
  const BasicKeypadDemo({super.key});

  @override
  State<BasicKeypadDemo> createState() => _BasicKeypadDemoState();
}

class _BasicKeypadDemoState extends KeypadDemoPageState<BasicKeypadDemo> {
  @override
  Widget build(BuildContext context) {
    return buildKeypadDemo(
      context: context,
      title: 'Basic Keypad',
      description:
          'A simple numeric keypad with only the essential features. '
          'Supports basic number input with backspace and clear functionality.',
      keypadDescription: 'Enter a whole number',
      config: const KeypadConfig(
        showDecimalKey: false,
        showSignKey: false,
        showCancelKey: false,
      ),
    );
  }
}
