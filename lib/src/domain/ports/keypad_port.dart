import '../value_objects/keypad_config.dart';
import '../value_objects/keypad_key.dart';

/// Port interface for keypad configuration and layout generation
/// This is the domain boundary - implementations provide different layout strategies
abstract class KeypadPort {
  /// Get the default keypad configuration for this layout strategy
  KeypadConfig getDefaultConfig();

  /// Generate the keypad layout based on configuration
  /// Returns a 2D array representing rows and columns of keys
  List<List<KeypadKey>> getKeypadLayout(KeypadConfig config);

  /// Get localized text for keypad keys
  String getLocalizedKeyText(KeypadKeyType keyType);
}
