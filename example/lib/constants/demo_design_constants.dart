/// Design constants for the demo application
///
/// This file centralizes all magic numbers used for spacing and layout
/// in the demo app, separate from the keypad widget constants.
class DemoDesignConstants {
  DemoDesignConstants._(); // Private constructor to prevent instantiation

  // =============================================================================
  // DEMO LAYOUT CONSTANTS
  // =============================================================================

  /// Base padding for demo screens
  static const double basePadding = 16.0;

  /// Base spacing for demo elements
  static const double baseSpacing = 16.0;

  /// Small spacing for demo elements
  static const double smallSpacing = 8.0;

  // =============================================================================
  // VISUAL DENSITY SCALING FACTORS FOR DEMO
  // =============================================================================

  /// Scaling factor for demo padding based on visual density
  static const double demoPaddingScaleFactor = 0.5;

  /// Scaling factor for demo spacing based on visual density
  static const double demoSpacingScaleFactor = 0.5;

  /// Scaling factor for demo small spacing based on visual density
  static const double demoSmallSpacingScaleFactor = 0.25;

  // =============================================================================
  // VISUAL DENSITY LIMITS FOR DEMO
  // =============================================================================

  /// Maximum adjustment for demo padding
  static const double demoPaddingMaxAdjustment = 4.0;

  /// Maximum adjustment for demo spacing
  static const double demoSpacingMaxAdjustment = 4.0;

  /// Maximum adjustment for demo small spacing
  static const double demoSmallSpacingMaxAdjustment = 2.0;

  // =============================================================================
  // HELPER METHODS
  // =============================================================================

  /// Calculate effective demo padding based on visual density
  static double getEffectiveDemoPadding(double densityAdjustment) {
    return basePadding +
        (densityAdjustment * demoPaddingScaleFactor).clamp(
          -demoPaddingMaxAdjustment,
          demoPaddingMaxAdjustment,
        );
  }

  /// Calculate effective demo spacing based on visual density
  static double getEffectiveDemoSpacing(double densityAdjustment) {
    return baseSpacing +
        (densityAdjustment * demoSpacingScaleFactor).clamp(
          -demoSpacingMaxAdjustment,
          demoSpacingMaxAdjustment,
        );
  }

  /// Calculate effective demo small spacing based on visual density
  static double getEffectiveDemoSmallSpacing(double densityAdjustment) {
    return smallSpacing +
        (densityAdjustment * demoSmallSpacingScaleFactor).clamp(
          -demoSmallSpacingMaxAdjustment,
          demoSmallSpacingMaxAdjustment,
        );
  }
}
