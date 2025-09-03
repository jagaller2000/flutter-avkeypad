import 'package:flutter/material.dart';
import '../../domain/entities/keypad_session.dart';
import '../../domain/usecases/generate_keypad_layout_usecase.dart';
import '../../domain/value_objects/keypad_config.dart';
import '../../domain/value_objects/keypad_key.dart';
import '../../infrastructure/adapters/default_keypad_adapter.dart';
import '../constants/design_constants.dart';
import 'keypad_display_widget.dart';
import 'keypad_layout_widget.dart';

/// A container widget that manages the entire keypad interface
class KeypadContainerWidget extends StatelessWidget {
  const KeypadContainerWidget({
    super.key,
    required this.session,
    required this.config,
    required this.onKeyPressed,
    this.padding,
    this.decoration,
    this.displayMargin,
  });

  /// The keypad session managing state
  final KeypadSession session;

  /// Configuration for the keypad
  final KeypadConfig config;

  /// Callback when a key is pressed
  final ValueChanged<KeypadKey> onKeyPressed;

  /// Padding around the entire keypad (null for theme-based)
  final EdgeInsets? padding;

  /// Custom decoration for the keypad container
  final BoxDecoration? decoration;

  /// Margin between display and keys (null for theme-based)
  final EdgeInsets? displayMargin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visualDensity = theme.visualDensity;
    final adapter = DefaultKeypadAdapter();
    final layoutUseCase = GenerateKeypadLayoutUseCase(adapter);
    final layout = layoutUseCase.generateStandardLayout(config);

    // Calculate spacing based on visual density
    final densityAdjustment = visualDensity.baseSizeAdjustment;
    // Use more conservative adjustments to prevent overflow
    final effectivePadding = KeypadDesignConstants.getEffectiveContainerPadding(
      densityAdjustment.dx,
    );
    final effectiveMargin = KeypadDesignConstants.getEffectiveContainerMargin(
      densityAdjustment.dx,
    );

    final defaultPadding = EdgeInsets.all(effectivePadding);
    final defaultDisplayMargin = EdgeInsets.only(bottom: effectiveMargin);

    final defaultDecoration = BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(
        KeypadDesignConstants.containerBorderRadius,
      ),
      border: Border.all(
        color: theme.colorScheme.outline,
        width: KeypadDesignConstants.containerBorderWidth,
      ),
    );

    return Container(
      padding: padding ?? defaultPadding,
      decoration: decoration ?? defaultDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display area
          Container(
            margin: displayMargin ?? defaultDisplayMargin,
            child: KeypadDisplayWidget(state: session.currentState),
          ),

          // Keypad layout
          KeypadLayoutWidget(
            layout: layout,
            onKeyPressed: onKeyPressed,
            state: session.currentState,
            config: config,
          ),
        ],
      ),
    );
  }
}
