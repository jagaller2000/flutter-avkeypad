import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

// Mock implementation of KeypadPort for testing
class MockKeypadPort implements KeypadPort {
  List<List<KeypadKey>>? _mockLayout;

  void setMockLayout(List<List<KeypadKey>> layout) {
    _mockLayout = layout;
  }

  @override
  KeypadConfig getDefaultConfig() {
    return const KeypadConfig();
  }

  @override
  List<List<KeypadKey>> getKeypadLayout(KeypadConfig config) {
    if (_mockLayout != null) {
      return _mockLayout!;
    }
    // Return empty layout as default
    return [];
  }

  @override
  String getLocalizedKeyText(KeypadKeyType keyType) {
    switch (keyType) {
      case KeypadKeyType.clear:
        return 'Clear';
      case KeypadKeyType.backspace:
        return 'Backspace';
      case KeypadKeyType.custom:
        return 'Confirm';
      case KeypadKeyType.cancel:
        return 'Cancel';
      default:
        return keyType.toString();
    }
  }
}

void main() {
  group('GenerateKeypadLayoutUseCase Tests', () {
    late GenerateKeypadLayoutUseCase useCase;
    late MockKeypadPort mockPort;

    setUp(() {
      mockPort = MockKeypadPort();
      useCase = GenerateKeypadLayoutUseCase(mockPort);
    });

    group('Port Integration', () {
      test('should delegate to port for layout generation', () {
        final mockLayout = [
          [const KeypadKey(value: '1', type: KeypadKeyType.digit)],
          [const KeypadKey(value: '2', type: KeypadKeyType.digit)],
        ];
        mockPort.setMockLayout(mockLayout);

        const config = KeypadConfig();
        final result = useCase(config);

        expect(result, equals(mockLayout));
        expect(result.length, equals(2));
      });

      test('should handle empty layout from port', () {
        mockPort.setMockLayout([]);

        const config = KeypadConfig();
        final result = useCase(config);

        expect(result, isEmpty);
      });

      test('should pass config to port correctly', () {
        final mockLayout = [
          [const KeypadKey(value: 'test', type: KeypadKeyType.custom)],
        ];
        mockPort.setMockLayout(mockLayout);

        const customConfig = KeypadConfig(maxDigits: 5, allowNegative: true);
        final result = useCase(customConfig);

        expect(result, equals(mockLayout));
      });
    });

    group('Standard Layout Generation', () {
      test('should generate basic 3x4 numeric layout', () {
        const config = KeypadConfig();
        final result = useCase.generateStandardLayout(config);

        // Should have digit rows (1-9) plus bottom row
        expect(result.length, greaterThanOrEqualTo(4));

        // First row: 1, 2, 3
        expect(result[0].length, equals(3));
        expect(result[0][0].value, equals('1'));
        expect(result[0][1].value, equals('2'));
        expect(result[0][2].value, equals('3'));

        // Second row: 4, 5, 6
        expect(result[1][0].value, equals('4'));
        expect(result[1][1].value, equals('5'));
        expect(result[1][2].value, equals('6'));

        // Third row: 7, 8, 9
        expect(result[2][0].value, equals('7'));
        expect(result[2][1].value, equals('8'));
        expect(result[2][2].value, equals('9'));
      });

      test('should include zero in bottom row', () {
        const config = KeypadConfig();
        final result = useCase.generateStandardLayout(config);

        // Find zero in the layout
        bool zeroFound = false;
        for (final row in result) {
          for (final key in row) {
            if (key.value == '0' && key.type == KeypadKeyType.digit) {
              zeroFound = true;
              break;
            }
          }
        }

        expect(zeroFound, isTrue);
      });

      test('should include decimal key when enabled', () {
        const config = KeypadConfig(showDecimalKey: true);
        final result = useCase.generateStandardLayout(config);

        bool decimalFound = false;
        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.decimal) {
              decimalFound = true;
              expect(key.value, equals('.'));
              expect(key.displayText, equals('.'));
              break;
            }
          }
        }

        expect(decimalFound, isTrue);
      });

      test('should exclude decimal key when disabled', () {
        const config = KeypadConfig(showDecimalKey: false);
        final result = useCase.generateStandardLayout(config);

        bool decimalFound = false;
        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.decimal) {
              decimalFound = true;
              break;
            }
          }
        }

        expect(decimalFound, isFalse);
      });

      test('should include sign key when enabled', () {
        const config = KeypadConfig(showSignKey: true);
        final result = useCase.generateStandardLayout(config);

        bool signFound = false;
        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.sign) {
              signFound = true;
              expect(key.value, equals('±'));
              expect(key.displayText, equals('±'));
              break;
            }
          }
        }

        expect(signFound, isTrue);
      });

      test('should exclude sign key when disabled', () {
        const config = KeypadConfig(showSignKey: false);
        final result = useCase.generateStandardLayout(config);

        bool signFound = false;
        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.sign) {
              signFound = true;
              break;
            }
          }
        }

        expect(signFound, isFalse);
      });
    });

    group('Action Keys Layout', () {
      test('should include backspace key when enabled', () {
        const config = KeypadConfig(showBackspaceKey: true);
        final result = useCase.generateStandardLayout(config);

        bool backspaceFound = false;
        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.backspace) {
              backspaceFound = true;
              expect(key.value, equals('backspace'));
              expect(key.displayText, equals('⌫'));
              break;
            }
          }
        }

        expect(backspaceFound, isTrue);
      });

      test('should include clear key when enabled', () {
        const config = KeypadConfig(showClearKey: true);
        final result = useCase.generateStandardLayout(config);

        bool clearFound = false;
        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.clear) {
              clearFound = true;
              expect(key.value, equals('clear'));
              expect(key.displayText, equals('C'));
              break;
            }
          }
        }

        expect(clearFound, isTrue);
      });

      test('should include confirm key when enabled', () {
        const config = KeypadConfig();
        final result = useCase.generateStandardLayout(config);

        bool confirmFound = false;
        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.custom) {
              confirmFound = true;
              expect(key.value, equals('confirm'));
              expect(key.displayText, equals('✓'));
              break;
            }
          }
        }

        expect(confirmFound, isTrue);
      });

      test('should include cancel key when enabled', () {
        const config = KeypadConfig(showCancelKey: true);
        final result = useCase.generateStandardLayout(config);

        bool cancelFound = false;
        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.cancel) {
              cancelFound = true;
              expect(key.value, equals('cancel'));
              expect(key.displayText, equals('✕'));
              break;
            }
          }
        }

        expect(cancelFound, isTrue);
      });

      test('should exclude action keys when disabled', () {
        const config = KeypadConfig(
          showBackspaceKey: false,
          showClearKey: false,
          
          showCancelKey: false,
        );
        final result = useCase.generateStandardLayout(config);

        bool actionKeyFound = false;
        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.backspace ||
                key.type == KeypadKeyType.clear ||
                key.type == KeypadKeyType.custom ||
                key.type == KeypadKeyType.cancel) {
              actionKeyFound = true;
              break;
            }
          }
        }

        expect(actionKeyFound, isFalse);
      });

      test('should create action row only when needed', () {
        const configWithoutActions = KeypadConfig(
          showBackspaceKey: false,
          showClearKey: false,
          
          showCancelKey: false,
          customKeys: [],
        );
        final resultWithoutActions = useCase.generateStandardLayout(
          configWithoutActions,
        );

        const configWithActions = KeypadConfig(showClearKey: true);
        final resultWithActions = useCase.generateStandardLayout(
          configWithActions,
        );

        // Layout with actions should have more rows
        expect(
          resultWithActions.length,
          greaterThan(resultWithoutActions.length),
        );
      });
    });

    group('Custom Keys Integration', () {
      test('should include custom keys in action row', () {
        final customKeys = [
          const KeypadKey(
            value: 'pi',
            type: KeypadKeyType.custom,
            displayText: 'π',
          ),
          const KeypadKey(
            value: 'euler',
            type: KeypadKeyType.custom,
            displayText: 'e',
          ),
        ];
        final config = KeypadConfig(customKeys: customKeys);
        final result = useCase.generateStandardLayout(config);

        bool piFound = false;
        bool eulerFound = false;

        for (final row in result) {
          for (final key in row) {
            if (key.value == 'pi' && key.displayText == 'π') {
              piFound = true;
            }
            if (key.value == 'euler' && key.displayText == 'e') {
              eulerFound = true;
            }
          }
        }

        expect(piFound, isTrue);
        expect(eulerFound, isTrue);
      });

      test('should handle empty custom keys list', () {
        const config = KeypadConfig(customKeys: []);
        final result = useCase.generateStandardLayout(config);

        // Should not crash and should generate normal layout
        expect(result, isNotEmpty);
        expect(result[0].length, equals(3)); // First row should have 3 digits
      });

      test('should handle many custom keys', () {
        final manyCustomKeys = List.generate(
          10,
          (i) => KeypadKey(
            value: 'custom$i',
            type: KeypadKeyType.custom,
            displayText: 'C$i',
          ),
        );
        final config = KeypadConfig(customKeys: manyCustomKeys);
        final result = useCase.generateStandardLayout(config);

        int customKeysFound = 0;
        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.custom) {
              customKeysFound++;
            }
          }
        }

        expect(customKeysFound, equals(10));
      });
    });

    group('Custom Decimal Separator', () {
      test('should use custom decimal separator', () {
        const config = KeypadConfig(
          showDecimalKey: true,
          decimalSeparator: ',',
        );
        final result = useCase.generateStandardLayout(config);

        bool customDecimalFound = false;
        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.decimal) {
              customDecimalFound = true;
              expect(key.value, equals(','));
              expect(key.displayText, equals(','));
              break;
            }
          }
        }

        expect(customDecimalFound, isTrue);
      });

      test('should handle unusual decimal separators', () {
        const config = KeypadConfig(
          showDecimalKey: true,
          decimalSeparator: '·',
        );
        final result = useCase.generateStandardLayout(config);

        bool unusualDecimalFound = false;
        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.decimal) {
              unusualDecimalFound = true;
              expect(key.value, equals('·'));
              expect(key.displayText, equals('·'));
              break;
            }
          }
        }

        expect(unusualDecimalFound, isTrue);
      });
    });

    group('Layout Structure Validation', () {
      test('should maintain consistent digit key properties', () {
        const config = KeypadConfig();
        final result = useCase.generateStandardLayout(config);

        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.digit) {
              expect(key.isEnabled, isTrue);
              expect(key.value, matches(r'^\d$')); // Single digit
              expect(
                key.display,
                equals(key.value),
              ); // Display equals value for digits
            }
          }
        }
      });

      test('should have all digits 0-9 present', () {
        const config = KeypadConfig();
        final result = useCase.generateStandardLayout(config);

        final foundDigits = <String>{};
        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.digit) {
              foundDigits.add(key.value);
            }
          }
        }

        expect(foundDigits.length, equals(10));
        for (int i = 0; i <= 9; i++) {
          expect(foundDigits.contains(i.toString()), isTrue);
        }
      });

      test('should maintain proper row structure', () {
        const config = KeypadConfig();
        final result = useCase.generateStandardLayout(config);

        expect(result.length, greaterThanOrEqualTo(4)); // At least 4 rows
        expect(result[0].length, equals(3)); // First row: 1,2,3
        expect(result[1].length, equals(3)); // Second row: 4,5,6
        expect(result[2].length, equals(3)); // Third row: 7,8,9
        expect(
          result[3].isNotEmpty,
          isTrue,
        ); // Bottom row with 0 and other keys
      });
    });

    group('Complex Configuration Scenarios', () {
      test('should handle full-featured configuration', () {
        final customKeys = [
          const KeypadKey(
            value: 'sqrt',
            type: KeypadKeyType.custom,
            displayText: '√',
          ),
        ];
        final config = KeypadConfig(
          showDecimalKey: true,
          showSignKey: true,
          showClearKey: true,
          showBackspaceKey: true,
          
          showCancelKey: true,
          customKeys: customKeys,
          decimalSeparator: ',',
        );
        final result = useCase.generateStandardLayout(config);

        // Should have all features
        final keyTypes = <KeypadKeyType>{};
        for (final row in result) {
          for (final key in row) {
            keyTypes.add(key.type);
          }
        }

        expect(keyTypes.contains(KeypadKeyType.digit), isTrue);
        expect(keyTypes.contains(KeypadKeyType.decimal), isTrue);
        expect(keyTypes.contains(KeypadKeyType.sign), isTrue);
        expect(keyTypes.contains(KeypadKeyType.clear), isTrue);
        expect(keyTypes.contains(KeypadKeyType.backspace), isTrue);
        expect(keyTypes.contains(KeypadKeyType.custom), isTrue);
        expect(keyTypes.contains(KeypadKeyType.cancel), isTrue);
        expect(keyTypes.contains(KeypadKeyType.custom), isTrue);
      });

      test('should handle minimal configuration', () {
        const config = KeypadConfig(
          showDecimalKey: false,
          showSignKey: false,
          showClearKey: false,
          showBackspaceKey: false,
          
          showCancelKey: false,
          customKeys: [],
        );
        final result = useCase.generateStandardLayout(config);

        // Should only have digits
        final keyTypes = <KeypadKeyType>{};
        for (final row in result) {
          for (final key in row) {
            keyTypes.add(key.type);
          }
        }

        expect(keyTypes.contains(KeypadKeyType.digit), isTrue);
        expect(keyTypes.length, equals(1)); // Only digits
      });
    });

    group('Use Case Behavior', () {
      test('should be deterministic', () {
        const config = KeypadConfig(showDecimalKey: true, showSignKey: true);

        final result1 = useCase.generateStandardLayout(config);
        final result2 = useCase.generateStandardLayout(config);

        expect(result1.length, equals(result2.length));
        for (int i = 0; i < result1.length; i++) {
          expect(result1[i].length, equals(result2[i].length));
          for (int j = 0; j < result1[i].length; j++) {
            expect(result1[i][j], equals(result2[i][j]));
          }
        }
      });

      test('should not modify input config', () {
        const originalConfig = KeypadConfig(showDecimalKey: true, maxDigits: 5);

        useCase.generateStandardLayout(originalConfig);

        // Original config should remain unchanged
        expect(originalConfig.showDecimalKey, isTrue);
        expect(originalConfig.maxDigits, equals(5));
      });

      test('should be pure and stateless', () {
        const config1 = KeypadConfig(showSignKey: true);
        const config2 = KeypadConfig(showSignKey: false);

        final result1 = useCase.generateStandardLayout(config1);
        final result2 = useCase.generateStandardLayout(config2);

        // Results should be different based on config
        expect(result1, isNot(equals(result2)));

        // But calling again with same config should yield same result
        final result1Again = useCase.generateStandardLayout(config1);
        expect(result1, equals(result1Again));
      });
    });

    group('Edge Cases', () {
      test('should handle null custom keys gracefully', () {
        // This tests the default empty list in KeypadConfig
        const config = KeypadConfig();

        expect(() => useCase.generateStandardLayout(config), returnsNormally);
        final result = useCase.generateStandardLayout(config);
        expect(result, isNotEmpty);
      });

      test('should handle very long decimal separator', () {
        const config = KeypadConfig(
          showDecimalKey: true,
          decimalSeparator: 'DECIMAL_POINT',
        );
        final result = useCase.generateStandardLayout(config);

        bool longDecimalFound = false;
        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.decimal) {
              longDecimalFound = true;
              expect(key.value, equals('DECIMAL_POINT'));
              expect(key.displayText, equals('DECIMAL_POINT'));
              break;
            }
          }
        }

        expect(longDecimalFound, isTrue);
      });

      test('should handle empty decimal separator', () {
        const config = KeypadConfig(showDecimalKey: true, decimalSeparator: '');
        final result = useCase.generateStandardLayout(config);

        bool emptyDecimalFound = false;
        for (final row in result) {
          for (final key in row) {
            if (key.type == KeypadKeyType.decimal) {
              emptyDecimalFound = true;
              expect(key.value, equals(''));
              expect(key.displayText, equals(''));
              break;
            }
          }
        }

        expect(emptyDecimalFound, isTrue);
      });
    });
  });
}
