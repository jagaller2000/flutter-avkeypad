import 'package:flutter/material.dart';

/// Design constants for the presentation layer
///
/// This file centralizes all magic numbers used for sizes, paddings, margins,
/// and other design values throughout the keypad widgets.
class KeypadDesignConstants {
  @visibleForTesting
  KeypadDesignConstants(); // Constructor marked as visible for testing only

  // =============================================================================
  // KEY SIZING AND SPACING
  // =============================================================================

  /// Base size for keypad keys
  static const double keyBaseSize = 56.0;

  /// Base padding for keypad keys
  static const double keyBasePadding = 8.0;

  /// Border radius for keypad keys
  static const double keyBorderRadius = 8.0;

  // =============================================================================
  // DISPLAY AREA
  // =============================================================================

  /// Base padding for the display area
  static const double displayBasePadding = 16.0;

  /// Border radius for the display area
  static const double displayBorderRadius = 8.0;

  /// Spacing between display value and error message
  static const double displayErrorSpacing = 4.0;

  // =============================================================================
  // LAYOUT SPACING
  // =============================================================================

  /// Base spacing between keys in the layout
  static const double layoutBaseSpacing = 8.0;

  // =============================================================================
  // CONTAINER STYLING
  // =============================================================================

  /// Base padding for the keypad container
  static const double containerBasePadding = 16.0;

  /// Base margin for elements within the container
  static const double containerBaseMargin = 16.0;

  /// Border radius for the keypad container
  static const double containerBorderRadius = 16.0;

  /// Border width for the keypad container
  static const double containerBorderWidth = 1.0;

  // =============================================================================
  // VISUAL DENSITY SCALING FACTORS
  // =============================================================================

  /// Scaling factor for key size based on visual density
  static const double keySizeScaleFactor = 0.8;

  /// Scaling factor for key padding based on visual density
  static const double keyPaddingScaleFactor = 0.3;

  /// Scaling factor for display padding based on visual density
  static const double displayPaddingScaleFactor = 0.5;

  /// Scaling factor for layout spacing based on visual density
  static const double layoutSpacingScaleFactor = 0.3;

  /// Scaling factor for container padding based on visual density
  static const double containerPaddingScaleFactor = 0.5;

  /// Scaling factor for container margin based on visual density
  static const double containerMarginScaleFactor = 0.3;

  /// Scaling factor for layout run spacing based on visual density
  static const double layoutRunSpacingScaleFactor = 0.5;

  /// Scaling factor for horizontal key padding (half of spacing)
  static const double keyHorizontalPaddingFactor = 0.5;

  // =============================================================================
  // VISUAL DENSITY LIMITS
  // =============================================================================

  /// Maximum adjustment for key size
  static const double keySizeMaxAdjustment = 8.0;

  /// Maximum adjustment for key padding
  static const double keyPaddingMaxAdjustment = 2.0;

  /// Maximum adjustment for display padding
  static const double displayPaddingMaxAdjustment = 4.0;

  /// Maximum adjustment for layout spacing
  static const double layoutSpacingMaxAdjustment = 2.0;

  /// Maximum adjustment for container padding
  static const double containerPaddingMaxAdjustment = 4.0;

  /// Maximum adjustment for container margin
  static const double containerMarginMaxAdjustment = 4.0;

  // =============================================================================
  // FONT WEIGHTS
  // =============================================================================

  /// Font weight for key text
  static const keyFontWeight = FontWeight.w500;

  // =============================================================================
  // HELPER METHODS
  // =============================================================================

  /// Calculate effective key size based on visual density
  static double getEffectiveKeySize(double densityAdjustment) {
    return keyBaseSize +
        (densityAdjustment * keySizeScaleFactor).clamp(
          -keySizeMaxAdjustment,
          keySizeMaxAdjustment,
        );
  }

  /// Calculate effective key padding based on visual density
  static double getEffectiveKeyPadding(double densityAdjustment) {
    return keyBasePadding +
        (densityAdjustment * keyPaddingScaleFactor).clamp(
          -keyPaddingMaxAdjustment,
          keyPaddingMaxAdjustment,
        );
  }

  /// Calculate effective display padding based on visual density
  static double getEffectiveDisplayPadding(double densityAdjustment) {
    return displayBasePadding +
        (densityAdjustment * displayPaddingScaleFactor).clamp(
          -displayPaddingMaxAdjustment,
          displayPaddingMaxAdjustment,
        );
  }

  /// Calculate effective layout spacing based on visual density
  static double getEffectiveLayoutSpacing(double densityAdjustment) {
    return layoutBaseSpacing +
        (densityAdjustment * layoutSpacingScaleFactor).clamp(
          -layoutSpacingMaxAdjustment,
          layoutSpacingMaxAdjustment,
        );
  }

  /// Calculate effective container padding based on visual density
  static double getEffectiveContainerPadding(double densityAdjustment) {
    return containerBasePadding +
        (densityAdjustment * containerPaddingScaleFactor).clamp(
          -containerPaddingMaxAdjustment,
          containerPaddingMaxAdjustment,
        );
  }

  /// Calculate effective container margin based on visual density
  static double getEffectiveContainerMargin(double densityAdjustment) {
    return containerBaseMargin +
        (densityAdjustment * containerMarginScaleFactor).clamp(
          -containerMarginMaxAdjustment,
          containerMarginMaxAdjustment,
        );
  }

  /// Calculate effective layout run spacing based on visual density
  static double getEffectiveLayoutRunSpacing(double densityAdjustment) {
    return layoutBaseSpacing +
        (densityAdjustment * layoutRunSpacingScaleFactor);
  }
}
