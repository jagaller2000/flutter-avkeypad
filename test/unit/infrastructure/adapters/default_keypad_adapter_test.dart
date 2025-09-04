import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/src/domain/ports/keypad_port.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_config.dart';
import 'package:avkeypad/src/domain/value_objects/keypad_key.dart';
import 'package:avkeypad/src/infrastructure/adapters/default_keypad_adapter.dart';

void main() {
  group('DefaultKeypadAdapter', () {
    late DefaultKeypadAdapter adapter;

    setUp(() {
      adapter = DefaultKeypadAdapter();
    });

    group('getDefaultConfig', () {
      test('should return a default KeypadConfig instance', () {
        // Act
        final config = adapter.getDefaultConfig();

        // Assert
        expect(config, isA<KeypadConfig>());
        expect(config.showDecimalKey, isTrue);
        expect(config.showBackspaceKey, isTrue);
        expect(config.showClearKey, isTrue);
        expect(config.showConfirmKey, isFalse);
        expect(config.showCancelKey, isFalse);
        expect(config.showSignKey, isFalse);
        expect(config.decimalSeparator, '.');
        expect(config.customKeys, isEmpty);
      });

      test(
        'should return the same default configuration on multiple calls',
        () {
          // Act
          final config1 = adapter.getDefaultConfig();
          final config2 = adapter.getDefaultConfig();

          // Assert
          expect(config1, equals(config2));
        },
      );
    });

    group('getKeypadLayout', () {
      test('should return basic 3x3 digit grid with default config', () {
        // Arrange
        final config = adapter.getDefaultConfig();

        // Act
        final layout = adapter.getKeypadLayout(config);

        // Assert
        expect(layout.length, greaterThanOrEqualTo(4)); // At least 4 rows

        // First row: 1, 2, 3
        expect(layout[0].length, 3);
        expect(
          layout[0][0],
          const KeypadKey(value: '1', type: KeypadKeyType.digit),
        );
        expect(
          layout[0][1],
          const KeypadKey(value: '2', type: KeypadKeyType.digit),
        );
        expect(
          layout[0][2],
          const KeypadKey(value: '3', type: KeypadKeyType.digit),
        );

        // Second row: 4, 5, 6
        expect(layout[1].length, 3);
        expect(
          layout[1][0],
          const KeypadKey(value: '4', type: KeypadKeyType.digit),
        );
        expect(
          layout[1][1],
          const KeypadKey(value: '5', type: KeypadKeyType.digit),
        );
        expect(
          layout[1][2],
          const KeypadKey(value: '6', type: KeypadKeyType.digit),
        );

        // Third row: 7, 8, 9
        expect(layout[2].length, 3);
        expect(
          layout[2][0],
          const KeypadKey(value: '7', type: KeypadKeyType.digit),
        );
        expect(
          layout[2][1],
          const KeypadKey(value: '8', type: KeypadKeyType.digit),
        );
        expect(
          layout[2][2],
          const KeypadKey(value: '9', type: KeypadKeyType.digit),
        );
      });

      test(
        'should include zero and decimal key in bottom row with default config',
        () {
          // Arrange
          final config = adapter.getDefaultConfig();

          // Act
          final layout = adapter.getKeypadLayout(config);

          // Assert
          final bottomRow = layout[3]; // Fourth row (bottom row with digits)
          expect(
            bottomRow,
            contains(const KeypadKey(value: '0', type: KeypadKeyType.digit)),
          );
          expect(
            bottomRow,
            contains(
              KeypadKey(
                value: config.decimalSeparator,
                type: KeypadKeyType.decimal,
                displayText: config.decimalSeparator,
              ),
            ),
          );
        },
      );

      test('should include action keys when enabled in config', () {
        // Arrange
        final config = const KeypadConfig(
          showBackspaceKey: true,
          showClearKey: true,
          showConfirmKey: true,
          showCancelKey: true,
        );

        // Act
        final layout = adapter.getKeypadLayout(config);

        // Assert
        expect(layout.length, 5); // 3 digit rows + 1 bottom row + 1 action row

        final actionRow = layout.last;
        expect(
          actionRow,
          contains(
            const KeypadKey(
              value: 'backspace',
              type: KeypadKeyType.backspace,
              displayText: '⌫',
            ),
          ),
        );
        expect(
          actionRow,
          contains(
            const KeypadKey(
              value: 'clear',
              type: KeypadKeyType.clear,
              displayText: 'C',
            ),
          ),
        );
        expect(
          actionRow,
          contains(
            const KeypadKey(
              value: 'confirm',
              type: KeypadKeyType.confirm,
              displayText: '✓',
            ),
          ),
        );
        expect(
          actionRow,
          contains(
            const KeypadKey(
              value: 'cancel',
              type: KeypadKeyType.cancel,
              displayText: '✕',
            ),
          ),
        );
      });

      test('should include sign key when enabled in config', () {
        // Arrange
        final config = const KeypadConfig(showSignKey: true);

        // Act
        final layout = adapter.getKeypadLayout(config);

        // Assert
        final bottomRow = layout[3];
        expect(
          bottomRow,
          contains(
            const KeypadKey(
              value: '±',
              type: KeypadKeyType.sign,
              displayText: '±',
            ),
          ),
        );
      });

      test('should exclude decimal key when disabled in config', () {
        // Arrange
        final config = const KeypadConfig(showDecimalKey: false);

        // Act
        final layout = adapter.getKeypadLayout(config);

        // Assert
        final bottomRow = layout[3];
        expect(
          bottomRow.where((key) => key.type == KeypadKeyType.decimal),
          isEmpty,
        );
      });

      test('should use custom decimal separator from config', () {
        // Arrange
        final config = const KeypadConfig(
          showDecimalKey: true,
          decimalSeparator: ',',
        );

        // Act
        final layout = adapter.getKeypadLayout(config);

        // Assert
        final bottomRow = layout[3];
        expect(
          bottomRow,
          contains(
            const KeypadKey(
              value: ',',
              type: KeypadKeyType.decimal,
              displayText: ',',
            ),
          ),
        );
      });

      test('should include custom keys in action row', () {
        // Arrange
        const customKey1 = KeypadKey(
          value: 'custom1',
          type: KeypadKeyType.custom,
          displayText: 'C1',
        );
        const customKey2 = KeypadKey(
          value: 'custom2',
          type: KeypadKeyType.custom,
          displayText: 'C2',
        );
        final config = KeypadConfig(customKeys: [customKey1, customKey2]);

        // Act
        final layout = adapter.getKeypadLayout(config);

        // Assert
        final actionRow = layout.last;
        expect(actionRow, contains(customKey1));
        expect(actionRow, contains(customKey2));
      });

      test('should not create action row when no action keys are enabled', () {
        // Arrange
        final config = const KeypadConfig(
          showBackspaceKey: false,
          showClearKey: false,
          showConfirmKey: false,
          showCancelKey: false,
          customKeys: [],
        );

        // Act
        final layout = adapter.getKeypadLayout(config);

        // Assert
        expect(layout.length, 4); // Only digit rows + bottom row
      });

      test(
        'should handle configuration with only some action keys enabled',
        () {
          // Arrange
          final config = const KeypadConfig(
            showBackspaceKey: true,
            showClearKey: false,
            showConfirmKey: true,
            showCancelKey: false,
          );

          // Act
          final layout = adapter.getKeypadLayout(config);

          // Assert
          expect(
            layout.length,
            5,
          ); // 3 digit rows + 1 bottom row + 1 action row

          final actionRow = layout.last;
          expect(
            actionRow,
            contains(
              const KeypadKey(
                value: 'backspace',
                type: KeypadKeyType.backspace,
                displayText: '⌫',
              ),
            ),
          );
          expect(
            actionRow,
            contains(
              const KeypadKey(
                value: 'confirm',
                type: KeypadKeyType.confirm,
                displayText: '✓',
              ),
            ),
          );
          expect(
            actionRow.where((key) => key.type == KeypadKeyType.clear),
            isEmpty,
          );
          expect(
            actionRow.where((key) => key.type == KeypadKeyType.cancel),
            isEmpty,
          );
        },
      );

      test(
        'should maintain consistent digit layout regardless of configuration',
        () {
          // Arrange
          final configs = [
            const KeypadConfig(),
            const KeypadConfig(showDecimalKey: false, showSignKey: true),
            const KeypadConfig(showBackspaceKey: false, showClearKey: false),
            KeypadConfig(
              customKeys: [
                const KeypadKey(value: 'test', type: KeypadKeyType.custom),
              ],
            ),
          ];

          for (final config in configs) {
            // Act
            final layout = adapter.getKeypadLayout(config);

            // Assert
            expect(layout.length, greaterThanOrEqualTo(4));

            // Verify first three rows are always the same
            expect(layout[0][0].value, '1');
            expect(layout[0][1].value, '2');
            expect(layout[0][2].value, '3');
            expect(layout[1][0].value, '4');
            expect(layout[1][1].value, '5');
            expect(layout[1][2].value, '6');
            expect(layout[2][0].value, '7');
            expect(layout[2][1].value, '8');
            expect(layout[2][2].value, '9');

            // Verify zero is always in bottom row
            final bottomRow = layout[3];
            expect(
              bottomRow,
              contains(const KeypadKey(value: '0', type: KeypadKeyType.digit)),
            );
          }
        },
      );
    });

    group('saveConfig', () {
      test('should complete without error', () async {
        // Arrange
        final config = adapter.getDefaultConfig();

        // Act & Assert
        expect(() async => await adapter.saveConfig(config), returnsNormally);
      });

      test('should simulate async operation with delay', () async {
        // Arrange
        final config = adapter.getDefaultConfig();
        final stopwatch = Stopwatch()..start();

        // Act
        await adapter.saveConfig(config);
        stopwatch.stop();

        // Assert
        expect(
          stopwatch.elapsedMilliseconds,
          greaterThanOrEqualTo(90),
        ); // Allow some margin
      });

      test('should accept any valid KeypadConfig', () async {
        // Arrange
        final configs = [
          const KeypadConfig(),
          const KeypadConfig(showDecimalKey: false),
          const KeypadConfig(showSignKey: true, decimalSeparator: ','),
          KeypadConfig(
            customKeys: [
              const KeypadKey(value: 'test', type: KeypadKeyType.custom),
            ],
          ),
        ];

        // Act & Assert
        for (final config in configs) {
          expect(() async => await adapter.saveConfig(config), returnsNormally);
        }
      });
    });

    group('loadConfig', () {
      test('should return default config', () async {
        // Act
        final loadedConfig = await adapter.loadConfig();
        final defaultConfig = adapter.getDefaultConfig();

        // Assert
        expect(loadedConfig, equals(defaultConfig));
      });

      test('should simulate async operation with delay', () async {
        // Arrange
        final stopwatch = Stopwatch()..start();

        // Act
        await adapter.loadConfig();
        stopwatch.stop();

        // Assert
        expect(
          stopwatch.elapsedMilliseconds,
          greaterThanOrEqualTo(90),
        ); // Allow some margin
      });

      test('should return consistent config on multiple calls', () async {
        // Act
        final config1 = await adapter.loadConfig();
        final config2 = await adapter.loadConfig();

        // Assert
        expect(config1, equals(config2));
      });
    });

    group('getLocalizedKeyText', () {
      test('should return correct text for digit key type', () {
        // Act
        final text = adapter.getLocalizedKeyText(KeypadKeyType.digit);

        // Assert
        expect(text, 'Digit');
      });

      test('should return correct text for decimal key type', () {
        // Act
        final text = adapter.getLocalizedKeyText(KeypadKeyType.decimal);

        // Assert
        expect(text, 'Decimal');
      });

      test('should return correct text for backspace key type', () {
        // Act
        final text = adapter.getLocalizedKeyText(KeypadKeyType.backspace);

        // Assert
        expect(text, 'Delete');
      });

      test('should return correct text for clear key type', () {
        // Act
        final text = adapter.getLocalizedKeyText(KeypadKeyType.clear);

        // Assert
        expect(text, 'Clear');
      });

      test('should return correct text for confirm key type', () {
        // Act
        final text = adapter.getLocalizedKeyText(KeypadKeyType.confirm);

        // Assert
        expect(text, 'Confirm');
      });

      test('should return correct text for cancel key type', () {
        // Act
        final text = adapter.getLocalizedKeyText(KeypadKeyType.cancel);

        // Assert
        expect(text, 'Cancel');
      });

      test('should return correct text for sign key type', () {
        // Act
        final text = adapter.getLocalizedKeyText(KeypadKeyType.sign);

        // Assert
        expect(text, 'Sign');
      });

      test('should return correct text for custom key type', () {
        // Act
        final text = adapter.getLocalizedKeyText(KeypadKeyType.custom);

        // Assert
        expect(text, 'Custom');
      });

      test('should handle all KeypadKeyType enum values', () {
        // Arrange
        final expectedTexts = {
          KeypadKeyType.digit: 'Digit',
          KeypadKeyType.decimal: 'Decimal',
          KeypadKeyType.backspace: 'Delete',
          KeypadKeyType.clear: 'Clear',
          KeypadKeyType.confirm: 'Confirm',
          KeypadKeyType.cancel: 'Cancel',
          KeypadKeyType.sign: 'Sign',
          KeypadKeyType.custom: 'Custom',
        };

        // Act & Assert
        for (final entry in expectedTexts.entries) {
          final text = adapter.getLocalizedKeyText(entry.key);
          expect(text, entry.value, reason: 'Failed for ${entry.key}');
        }
      });
    });

    group('interface compliance', () {
      test('should implement KeypadPort interface', () {
        // Assert
        expect(adapter, isA<KeypadPort>());
      });

      test('should provide all required KeypadPort methods', () {
        // Assert
        expect(adapter.getDefaultConfig, isA<KeypadConfig Function()>());
        expect(
          adapter.getKeypadLayout,
          isA<List<List<KeypadKey>> Function(KeypadConfig)>(),
        );
        expect(adapter.saveConfig, isA<Future<void> Function(KeypadConfig)>());
        expect(adapter.loadConfig, isA<Future<KeypadConfig> Function()>());
        expect(
          adapter.getLocalizedKeyText,
          isA<String Function(KeypadKeyType)>(),
        );
      });
    });

    group('edge cases and error handling', () {
      test('should handle empty custom keys list', () {
        // Arrange
        final config = const KeypadConfig(customKeys: []);

        // Act
        final layout = adapter.getKeypadLayout(config);

        // Assert
        expect(() => layout, returnsNormally);
        expect(layout, isNotEmpty);
      });

      test('should handle configuration with all flags disabled', () {
        // Arrange
        final config = const KeypadConfig(
          showDecimalKey: false,
          showBackspaceKey: false,
          showClearKey: false,
          showConfirmKey: false,
          showCancelKey: false,
          showSignKey: false,
          customKeys: [],
        );

        // Act
        final layout = adapter.getKeypadLayout(config);

        // Assert
        expect(
          layout.length,
          4,
        ); // 3 digit rows + 1 bottom row (with just zero)
        final bottomRow = layout[3];
        expect(bottomRow.length, 1); // Only zero
        expect(
          bottomRow[0],
          const KeypadKey(value: '0', type: KeypadKeyType.digit),
        );
      });

      test('should handle multiple custom keys of different types', () {
        // Arrange
        const customKeys = [
          KeypadKey(
            value: 'custom1',
            type: KeypadKeyType.custom,
            displayText: 'C1',
          ),
          KeypadKey(
            value: 'custom2',
            type: KeypadKeyType.custom,
            displayText: 'C2',
          ),
          KeypadKey(
            value: 'custom3',
            type: KeypadKeyType.custom,
            displayText: 'C3',
          ),
        ];
        final config = KeypadConfig(
          showBackspaceKey: true,
          customKeys: customKeys,
        );

        // Act
        final layout = adapter.getKeypadLayout(config);

        // Assert
        final actionRow = layout.last;
        expect(actionRow, contains(customKeys[0]));
        expect(actionRow, contains(customKeys[1]));
        expect(actionRow, contains(customKeys[2]));
        expect(
          actionRow,
          contains(
            const KeypadKey(
              value: 'backspace',
              type: KeypadKeyType.backspace,
              displayText: '⌫',
            ),
          ),
        );
      });
    });

    group('performance and consistency', () {
      test('should generate layout quickly for complex configurations', () {
        // Arrange
        final complexConfig = KeypadConfig(
          showDecimalKey: true,
          showBackspaceKey: true,
          showClearKey: true,
          showConfirmKey: true,
          showCancelKey: true,
          showSignKey: true,
          decimalSeparator: ',',
          customKeys: List.generate(
            5,
            (index) => KeypadKey(
              value: 'custom$index',
              type: KeypadKeyType.custom,
              displayText: 'C$index',
            ),
          ),
        );
        final stopwatch = Stopwatch()..start();

        // Act
        final layout = adapter.getKeypadLayout(complexConfig);
        stopwatch.stop();

        // Assert
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(100),
        ); // Should be very fast
        expect(layout, isNotEmpty);
        expect(layout.length, 5); // All rows present
      });

      test('should return immutable layout structure', () {
        // Arrange
        final config = adapter.getDefaultConfig();

        // Act
        final layout1 = adapter.getKeypadLayout(config);
        final layout2 = adapter.getKeypadLayout(config);

        // Assert
        expect(layout1, equals(layout2));
        expect(identical(layout1, layout2), isFalse); // Different instances
      });
    });
  });
}
