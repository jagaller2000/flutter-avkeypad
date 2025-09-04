import 'package:flutter_test/flutter_test.dart';

// Import all widget test files
import 'presentation/widgets/keypad_key_widget_test.dart' as keypad_key_tests;
import 'presentation/widgets/keypad_display_widget_test.dart'
    as keypad_display_tests;
// Note: Additional widget tests can be imported here as they are completed

void main() {
  group('All Widget Tests', () {
    group('KeypadKeyWidget Tests', keypad_key_tests.main);
    group('KeypadDisplayWidget Tests', keypad_display_tests.main);
    // Additional widget test groups can be added here
  });
}
