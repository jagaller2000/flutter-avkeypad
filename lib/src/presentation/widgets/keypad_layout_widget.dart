import 'package:flutter/material.dart';
import '../../domain/value_objects/keypad_config.dart';
import '../../domain/value_objects/keypad_key.dart';
import '../../domain/value_objects/keypad_state.dart';
import '../constants/design_constants.dart';
import 'keypad_key_widget.dart';

/// Widget that layouts keypad keys in a grid format
class KeypadLayoutWidget extends StatelessWidget {
  const KeypadLayoutWidget({
    super.key,
    required this.layout,
    required this.onKeyPressed,
    required this.state,
    required this.config,
    this.spacing,
    this.runSpacing,
  });

  /// The layout of keys as a 2D array
  final List<List<KeypadKey>> layout;

  /// Callback when a key is pressed
  final ValueChanged<KeypadKey> onKeyPressed;

  /// Current keypad state for determining key enabled states
  final KeypadState state;

  /// Keypad configuration for validation rules
  final KeypadConfig config;

  /// Horizontal spacing between keys (null for theme-based)
  final double? spacing;

  /// Vertical spacing between rows (null for theme-based)
  final double? runSpacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visualDensity = theme.visualDensity;

    // Calculate spacing based on visual density if not provided
    final densityAdjustment = visualDensity.baseSizeAdjustment;
    final effectiveSpacing = KeypadDesignConstants.getEffectiveLayoutSpacing(
      densityAdjustment.dx,
    );
    final effectiveRunSpacing =
        KeypadDesignConstants.getEffectiveLayoutRunSpacing(
          densityAdjustment.dx,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: layout
          .map(
            (row) => _buildKeyRow(
              row,
              spacing ?? effectiveSpacing,
              runSpacing ?? effectiveRunSpacing,
            ),
          )
          .toList(),
    );
  }

  Widget _buildKeyRow(
    List<KeypadKey> row,
    double effectiveSpacing,
    double effectiveRunSpacing,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: effectiveRunSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: row
            .map(
              (key) => Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      effectiveSpacing *
                      KeypadDesignConstants.keyHorizontalPaddingFactor,
                ),
                child: KeypadKeyWidget(
                  keypadKey: key,
                  onPressed: () => onKeyPressed(key),
                  isEnabled: _isKeyEnabled(key),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  bool _isKeyEnabled(KeypadKey key) {
    switch (key.type) {
      case KeypadKeyType.decimal:
        return !state.hasDecimal && config.showDecimalKey;
      case KeypadKeyType.sign:
        return config.allowNegative && state.isNotEmpty;
      case KeypadKeyType.backspace:
        return state.isNotEmpty;
      case KeypadKeyType.confirm:
        return state.isValid && state.isNotEmpty;
      default:
        return true;
    }
  }
}
