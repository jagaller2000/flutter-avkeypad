import 'package:flutter/material.dart';
import '../../domain/value_objects/keypad_state.dart';
import '../constants/design_constants.dart';

/// Widget that displays the current keypad input and validation status
class KeypadDisplayWidget extends StatelessWidget {
  const KeypadDisplayWidget({
    super.key,
    required this.state,
    this.textStyle,
    this.errorTextStyle,
    this.padding,
    this.decoration,
  });

  /// Current keypad state to display
  final KeypadState state;

  /// Custom text style for the display value
  final TextStyle? textStyle;

  /// Custom text style for error messages
  final TextStyle? errorTextStyle;

  /// Padding around the display content (null for theme-based)
  final EdgeInsets? padding;

  /// Custom decoration for the display container
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visualDensity = theme.visualDensity;

    // Calculate padding based on visual density
    final densityAdjustment = visualDensity.baseSizeAdjustment;
    final effectivePadding = KeypadDesignConstants.getEffectiveDisplayPadding(
      densityAdjustment.dx,
    );

    final defaultPadding = EdgeInsets.all(effectivePadding);

    final defaultDecoration = BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(
        KeypadDesignConstants.displayBorderRadius,
      ),
    );

    final defaultTextStyle = theme.textTheme.headlineMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontFeatures: [const FontFeature.tabularFigures()],
    );

    final defaultErrorTextStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.error,
    );

    return Container(
      width: double.infinity,
      padding: padding ?? defaultPadding,
      decoration: decoration ?? defaultDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(state.displayText, style: textStyle ?? defaultTextStyle),
          if (!state.isValid && state.error != null) ...[
            const SizedBox(height: KeypadDesignConstants.displayErrorSpacing),
            Text(
              state.error!.message,
              style: errorTextStyle ?? defaultErrorTextStyle,
            ),
          ],
        ],
      ),
    );
  }
}
