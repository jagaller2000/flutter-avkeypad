import 'package:flutter/material.dart';
import '../../domain/value_objects/keypad_key.dart';
import '../constants/design_constants.dart';

/// A single keypad key widget
class KeypadKeyWidget extends StatelessWidget {
  const KeypadKeyWidget({
    super.key,
    required this.keypadKey,
    required this.onPressed,
    this.isEnabled = true,
    this.isCompact = false,
  });

  /// The keypad key data
  final KeypadKey keypadKey;

  /// Callback when the key is pressed
  final VoidCallback onPressed;

  /// Whether the key is enabled
  final bool isEnabled;

  /// Whether this key is in compact mode (smaller size for action buttons)
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visualDensity = theme.visualDensity;
    final effectiveEnabled = isEnabled && keypadKey.isEnabled;

    // Calculate size and padding based on visual density and compact mode
    final densityAdjustment = visualDensity.baseSizeAdjustment;

    // Use conservative adjustments to prevent overflow
    final effectiveSize = isCompact
        ? KeypadDesignConstants.actionButtonSize
        : KeypadDesignConstants.getEffectiveKeySize(densityAdjustment.dx);

    final effectivePadding = isCompact
        ? KeypadDesignConstants.keyBasePadding * 0.75
        : KeypadDesignConstants.getEffectiveKeyPadding(densityAdjustment.dx);

    return FilledButton(
      onPressed: effectiveEnabled ? onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: _getKeyColor(keypadKey.type, theme),
        foregroundColor: _getKeyTextColor(keypadKey.type, theme),
        minimumSize: Size.square(effectiveSize),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            KeypadDesignConstants.keyBorderRadius,
          ),
        ),
        padding: EdgeInsets.all(effectivePadding),
        visualDensity: visualDensity,
      ),
      child: FittedBox(
        child: Text(
          keypadKey.display,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: KeypadDesignConstants.keyFontWeight,
          ),
        ),
      ),
    );
  }

  Color? _getKeyColor(KeypadKeyType type, ThemeData theme) {
    switch (type) {
      case KeypadKeyType.digit:
      case KeypadKeyType.decimal:
        return theme.colorScheme.primaryContainer;
      case KeypadKeyType.backspace:
      case KeypadKeyType.clear:
        return theme.colorScheme.errorContainer;
      case KeypadKeyType.confirm:
        return theme.colorScheme.primaryContainer;
      case KeypadKeyType.cancel:
        return theme.colorScheme.errorContainer;
      default:
        return theme.colorScheme.secondaryContainer;
    }
  }

  Color? _getKeyTextColor(KeypadKeyType type, ThemeData theme) {
    switch (type) {
      case KeypadKeyType.digit:
      case KeypadKeyType.decimal:
        return theme.colorScheme.onPrimaryContainer;
      case KeypadKeyType.backspace:
      case KeypadKeyType.clear:
        return theme.colorScheme.onErrorContainer;
      case KeypadKeyType.confirm:
        return theme.colorScheme.onPrimaryContainer;
      case KeypadKeyType.cancel:
        return theme.colorScheme.onErrorContainer;
      default:
        return theme.colorScheme.onSecondaryContainer;
    }
  }
}
