import 'package:flutter/material.dart';
import '../../domain/domain.dart';
import '../constants/design_constants.dart';
import 'keypad_key_widget.dart';

/// A compact keypad widget that integrates action buttons around the display area
class CompactKeypadWidget extends StatelessWidget {
  const CompactKeypadWidget({
    super.key,
    required this.keypadPort,
    required this.config,
    required this.currentValue,
    this.onKeyPressed,
    this.onValueChanged,
  });

  final KeypadPort keypadPort;
  final KeypadConfig config;
  final String currentValue;
  final void Function(KeypadKey)? onKeyPressed;
  final void Function(String)? onValueChanged;

  @override
  Widget build(BuildContext context) {
    final layout = keypadPort.getKeypadLayout(config);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Extract action buttons from the layout
    final actionButtons = _extractActionButtons(layout);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display row with action buttons on sides
        _buildDisplayRow(context, actionButtons, colorScheme),
        const SizedBox(height: KeypadDesignConstants.spacing),
        // Digit grid
        _buildDigitGrid(context, layout, colorScheme),
      ],
    );
  }

  /// Extract action buttons (confirm and backspace) from the layout
  Map<String, KeypadKey?> _extractActionButtons(List<List<KeypadKey>> layout) {
    KeypadKey? confirmButton;
    KeypadKey? backspaceButton;

    // Look through all rows to find action buttons
    for (final row in layout) {
      for (final key in row) {
        if (key.type == KeypadKeyType.confirm) {
          confirmButton = key;
        } else if (key.type == KeypadKeyType.backspace) {
          backspaceButton = key;
        }
      }
    }

    return {'confirm': confirmButton, 'backspace': backspaceButton};
  }

  Widget _buildDisplayRow(
    BuildContext context,
    Map<String, KeypadKey?> actionButtons,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        // Confirm button (left side)
        if (actionButtons['confirm'] != null)
          _buildActionButton(context, actionButtons['confirm']!, colorScheme)
        else
          const SizedBox(width: KeypadDesignConstants.actionButtonSize),

        const SizedBox(width: KeypadDesignConstants.spacing),

        // Display area
        Expanded(child: _buildDisplayArea(context, colorScheme)),

        const SizedBox(width: KeypadDesignConstants.spacing),

        // Backspace button (right side)
        if (actionButtons['backspace'] != null)
          _buildActionButton(context, actionButtons['backspace']!, colorScheme)
        else
          const SizedBox(width: KeypadDesignConstants.actionButtonSize),
      ],
    );
  }

  Widget _buildDisplayArea(BuildContext context, ColorScheme colorScheme) {
    return Container(
      height: KeypadDesignConstants.displayHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: KeypadDesignConstants.spacing,
        vertical: KeypadDesignConstants.spacing / 2,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(KeypadDesignConstants.borderRadius),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          currentValue.isEmpty ? '0' : currentValue,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    KeypadKey key,
    ColorScheme colorScheme,
  ) {
    return SizedBox(
      width: KeypadDesignConstants.actionButtonSize,
      height: KeypadDesignConstants.actionButtonSize,
      child: KeypadKeyWidget(
        key: ValueKey('compact_action_${key.value}'),
        keypadKey: key,
        onPressed: () => onKeyPressed?.call(key),
        isCompact: true,
      ),
    );
  }

  Widget _buildDigitGrid(
    BuildContext context,
    List<List<KeypadKey>> layout,
    ColorScheme colorScheme,
  ) {
    // Filter out action keys (keep only digit rows)
    final digitRows = layout
        .where(
          (row) => row.any(
            (key) =>
                key.type == KeypadKeyType.digit ||
                key.type == KeypadKeyType.decimal ||
                key.type == KeypadKeyType.clear ||
                key.type == KeypadKeyType.sign,
          ),
        )
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: digitRows.map((row) => _buildDigitRow(context, row)).toList(),
    );
  }

  Widget _buildDigitRow(BuildContext context, List<KeypadKey> row) {
    return Padding(
      padding: const EdgeInsets.only(bottom: KeypadDesignConstants.spacing / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: row.map((key) => _buildDigitKey(context, key)).toList(),
      ),
    );
  }

  Widget _buildDigitKey(BuildContext context, KeypadKey key) {
    return KeypadKeyWidget(
      key: ValueKey('compact_digit_${key.value}'),
      keypadKey: key,
      onPressed: () => onKeyPressed?.call(key),
    );
  }
}
