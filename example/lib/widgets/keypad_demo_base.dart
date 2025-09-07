import 'package:flutter/material.dart';
import 'package:avkeypad/avkeypad.dart';
import '../constants/demo_design_constants.dart';

/// Base class for all keypad demo pages
abstract class KeypadDemoPage extends StatefulWidget {
  const KeypadDemoPage({super.key});
}

/// Base state class for keypad demo pages with common functionality
abstract class KeypadDemoPageState<T extends KeypadDemoPage> extends State<T> {
  String _currentValue = '';
  String _message = 'Ready for input';

  void onValueChanged(String value) {
    setState(() {
      _currentValue = value;
      _message = 'Current: $_currentValue';
    });
  }

  void onCancel() {
    setState(() {
      _currentValue = '';
      _message = 'Cancelled - Ready for input';
    });
  }

  /// Build the demo page with the given configuration
  Widget buildKeypadDemo({
    required BuildContext context,
    required String title,
    required String description,
    required KeypadConfig config,
    bool enableHardwareKeyboard = true,
    bool autofocus = true,
    List<Widget> additionalControls = const [],
  }) {
    final theme = Theme.of(context);
    final visualDensity = theme.visualDensity;

    // Calculate spacing based on visual density
    final densityAdjustment = visualDensity.baseSizeAdjustment;

    // Use conservative adjustments to prevent overflow
    final effectivePadding = DemoDesignConstants.getEffectiveDemoPadding(
      densityAdjustment.dx,
    );
    final effectiveSpacing = DemoDesignConstants.getEffectiveDemoSpacing(
      densityAdjustment.dx,
    );
    final effectiveSmallSpacing =
        DemoDesignConstants.getEffectiveDemoSmallSpacing(densityAdjustment.dx);

    return Padding(
      padding: EdgeInsets.all(effectivePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and description - More compact
          Flexible(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(effectivePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: effectiveSmallSpacing),
                    Text(description, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: effectiveSpacing),

          // Status display - More compact
          Flexible(
            child: Card(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: EdgeInsets.all(effectivePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: effectiveSmallSpacing),
                    Text(_message),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: effectiveSpacing),

          // Additional controls (if any)
          if (additionalControls.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(effectivePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Controls',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: effectiveSmallSpacing),
                    ...additionalControls,
                  ],
                ),
              ),
            ),
            SizedBox(height: effectiveSpacing),
          ],

          // Keypad - Give it most of the space
          Expanded(
            flex: 3,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: NumericKeypad(
                  config: config,
                  onValueChanged: onValueChanged,
                  onCancel: onCancel,
                  enableHardwareKeyboard: enableHardwareKeyboard,
                  autofocus: autofocus,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
