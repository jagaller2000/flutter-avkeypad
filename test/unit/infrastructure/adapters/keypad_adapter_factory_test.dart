import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/src/infrastructure/adapters/keypad_adapter_factory.dart';
import 'package:avkeypad/src/infrastructure/adapters/traditional_keypad_adapter.dart';
import 'package:avkeypad/src/infrastructure/adapters/compact_keypad_adapter.dart';

void main() {
  group('KeypadAdapterFactory', () {
    test('creates traditional adapter correctly', () {
      // Act
      final adapter = KeypadAdapterFactory.createAdapter(
        KeypadLayoutStrategy.traditional,
      );

      // Assert
      expect(adapter, isA<TraditionalKeypadAdapter>());
    });

    test('creates compact adapter correctly', () {
      // Act
      final adapter = KeypadAdapterFactory.createAdapter(
        KeypadLayoutStrategy.compact,
      );

      // Assert
      expect(adapter, isA<CompactKeypadAdapter>());
    });

    test('getDefaultAdapter returns traditional adapter', () {
      // Act
      final adapter = KeypadAdapterFactory.getDefaultAdapter();

      // Assert
      expect(adapter, isA<TraditionalKeypadAdapter>());
    });

    test('getAllStrategies returns all available strategies', () {
      // Act
      final strategies = KeypadAdapterFactory.getAllStrategies();

      // Assert
      expect(strategies, contains(KeypadLayoutStrategy.traditional));
      expect(strategies, contains(KeypadLayoutStrategy.compact));
      expect(strategies.length, equals(2));
    });

    test('getStrategyDescription returns correct descriptions', () {
      // Act & Assert
      expect(
        KeypadAdapterFactory.getStrategyDescription(
          KeypadLayoutStrategy.traditional,
        ),
        equals(
          'Traditional layout with action keys in a separate row at the bottom',
        ),
      );

      expect(
        KeypadAdapterFactory.getStrategyDescription(
          KeypadLayoutStrategy.compact,
        ),
        equals(
          'Compact layout with action keys integrated around the display area',
        ),
      );
    });
  });
}
