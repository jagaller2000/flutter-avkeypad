import '../value_objects/keypad_config.dart';
import '../value_objects/keypad_key.dart';

/// Port interface for keypad configuration and layout
abstract class KeypadPort {
  /// Get the default keypad configuration
  KeypadConfig getDefaultConfig();

  /// Get the layout of keys based on configuration
  List<List<KeypadKey>> getKeypadLayout(KeypadConfig config);

  /// Save user preferences for keypad configuration
  Future<void> saveConfig(KeypadConfig config);

  /// Load user preferences for keypad configuration
  Future<KeypadConfig> loadConfig();

  /// Get localized text for keypad keys
  String getLocalizedKeyText(KeypadKeyType keyType);
}
