import 'package:flutter_test/flutter_test.dart';
import 'package:avkeypad/avkeypad.dart';

void main() {
  group('Domain Errors Tests', () {
    group('DomainError Base Class', () {
      test('should be abstract and provide common interface', () {
        // Create a concrete implementation for testing
        final error = MaxDigitsExceededError(5);

        expect(error, isA<DomainError>());
        expect(error.message, isNotEmpty);
        expect(error.code, isNotNull);
      });

      test('should convert to string using message', () {
        final error = MaxDigitsExceededError(3);

        expect(error.toString(), equals(error.message));
      });
    });

    group('MaxDigitsExceededError', () {
      test('should create error with correct message and code', () {
        const maxDigits = 5;
        final error = MaxDigitsExceededError(maxDigits);

        expect(error.message, equals('Maximum 5 digits allowed'));
        expect(error.code, equals('MAX_DIGITS_EXCEEDED'));
        expect(error.maxDigits, equals(maxDigits));
      });

      test('should handle different max digit values', () {
        final error1 = MaxDigitsExceededError(1);
        final error10 = MaxDigitsExceededError(10);
        final error100 = MaxDigitsExceededError(100);

        expect(error1.message, contains('1 digits'));
        expect(error10.message, contains('10 digits'));
        expect(error100.message, contains('100 digits'));
      });

      test('should have consistent properties', () {
        final error = MaxDigitsExceededError(7);

        expect(error.maxDigits, equals(7));
        expect(error.code, equals('MAX_DIGITS_EXCEEDED'));
        expect(error.message, contains('7'));
      });
    });

    group('MaxDecimalPlacesExceededError', () {
      test('should create error with correct message and code', () {
        const maxDecimalPlaces = 2;
        final error = MaxDecimalPlacesExceededError(maxDecimalPlaces);

        expect(error.message, equals('Maximum 2 decimal places allowed'));
        expect(error.code, equals('MAX_DECIMAL_PLACES_EXCEEDED'));
        expect(error.maxDecimalPlaces, equals(maxDecimalPlaces));
      });

      test('should handle different decimal place values', () {
        final error0 = MaxDecimalPlacesExceededError(0);
        final error2 = MaxDecimalPlacesExceededError(2);
        final error5 = MaxDecimalPlacesExceededError(5);

        expect(error0.message, contains('0 decimal places'));
        expect(error2.message, contains('2 decimal places'));
        expect(error5.message, contains('5 decimal places'));
      });
    });

    group('ZeroNotAllowedError', () {
      test('should create error with correct message and code', () {
        const error = ZeroNotAllowedError();

        expect(error.message, equals('Zero is not allowed'));
        expect(error.code, equals('ZERO_NOT_ALLOWED'));
      });

      test('should be consistent across instances', () {
        const error1 = ZeroNotAllowedError();
        const error2 = ZeroNotAllowedError();

        expect(error1.message, equals(error2.message));
        expect(error1.code, equals(error2.code));
      });
    });

    group('NegativeNotAllowedError', () {
      test('should create error with correct message and code', () {
        const error = NegativeNotAllowedError();

        expect(error.message, equals('Negative numbers are not allowed'));
        expect(error.code, equals('NEGATIVE_NOT_ALLOWED'));
      });

      test('should be consistent across instances', () {
        const error1 = NegativeNotAllowedError();
        const error2 = NegativeNotAllowedError();

        expect(error1.message, equals(error2.message));
        expect(error1.code, equals(error2.code));
      });
    });

    group('InvalidNumberFormatError', () {
      test('should create error with correct message and code', () {
        const error = InvalidNumberFormatError();

        expect(error.message, equals('Invalid number format'));
        expect(error.code, equals('INVALID_NUMBER_FORMAT'));
      });
    });

    group('DecimalNotAllowedError', () {
      test('should create error with correct message and code', () {
        const error = DecimalNotAllowedError();

        expect(error.message, equals('Decimal point is not allowed'));
        expect(error.code, equals('DECIMAL_NOT_ALLOWED'));
      });
    });

    group('SignToggleNotAllowedError', () {
      test('should create error with correct message and code', () {
        const error = SignToggleNotAllowedError();

        expect(error.message, equals('Sign toggle is not allowed'));
        expect(error.code, equals('SIGN_TOGGLE_NOT_ALLOWED'));
      });
    });

    group('DecimalAlreadyExistsError', () {
      test('should create error with correct message and code', () {
        const error = DecimalAlreadyExistsError();

        expect(error.message, equals('Decimal point already exists'));
        expect(error.code, equals('DECIMAL_ALREADY_EXISTS'));
      });
    });

    group('StepSizeViolationError', () {
      test('should create error with correct message and code', () {
        const stepSize = 0.5;
        const value = 1.3;
        final error = StepSizeViolationError(stepSize, value);

        expect(
          error.message,
          equals('Value 1.3 is not a valid multiple of step size 0.5'),
        );
        expect(error.code, equals('STEP_SIZE_VIOLATION'));
        expect(error.stepSize, equals(stepSize));
        expect(error.value, equals(value));
      });

      test('should handle different step sizes and values', () {
        final error1 = StepSizeViolationError(1.0, 2.5);
        final error2 = StepSizeViolationError(0.1, 0.33);
        final error3 = StepSizeViolationError(2.0, 7.0);

        expect(error1.message, contains('1.0'));
        expect(error1.message, contains('2.5'));

        expect(error2.message, contains('0.1'));
        expect(error2.message, contains('0.33'));

        expect(error3.message, contains('2.0'));
        expect(error3.message, contains('7.0'));
      });

      test('should maintain precision for small values', () {
        final error = StepSizeViolationError(0.001, 0.0033);

        expect(error.stepSize, equals(0.001));
        expect(error.value, equals(0.0033));
        expect(error.message, contains('0.001'));
        expect(error.message, contains('0.0033'));
      });
    });

    group('Error Code Uniqueness', () {
      test('should have unique error codes', () {
        final errors = [
          MaxDigitsExceededError(5),
          MaxDecimalPlacesExceededError(2),
          const ZeroNotAllowedError(),
          const NegativeNotAllowedError(),
          const InvalidNumberFormatError(),
          const DecimalNotAllowedError(),
          const SignToggleNotAllowedError(),
          const DecimalAlreadyExistsError(),
          StepSizeViolationError(1.0, 2.0),
        ];

        final codes = errors.map((e) => e.code).toSet();

        expect(codes.length, equals(errors.length));
      });
    });

    group('Error Messages', () {
      test('should have meaningful error messages', () {
        final errors = [
          MaxDigitsExceededError(5),
          MaxDecimalPlacesExceededError(2),
          const ZeroNotAllowedError(),
          const NegativeNotAllowedError(),
          const InvalidNumberFormatError(),
          const DecimalNotAllowedError(),
          const SignToggleNotAllowedError(),
          const DecimalAlreadyExistsError(),
          StepSizeViolationError(1.0, 2.0),
        ];

        for (final error in errors) {
          expect(error.message, isNotEmpty);
          expect(error.message.length, greaterThan(5));
          expect(error.toString(), equals(error.message));
        }
      });
    });

    group('Error Inheritance', () {
      test('should all inherit from DomainError', () {
        final errors = [
          MaxDigitsExceededError(5),
          MaxDecimalPlacesExceededError(2),
          const ZeroNotAllowedError(),
          const NegativeNotAllowedError(),
          const InvalidNumberFormatError(),
          const DecimalNotAllowedError(),
          const SignToggleNotAllowedError(),
          const DecimalAlreadyExistsError(),
          StepSizeViolationError(1.0, 2.0),
        ];

        for (final error in errors) {
          expect(error, isA<DomainError>());
        }
      });
    });

    group('Error Immutability', () {
      test('should have immutable properties', () {
        final error = MaxDigitsExceededError(5);

        // All properties should be final and immutable
        expect(error.maxDigits, equals(5));
        expect(error.message, equals('Maximum 5 digits allowed'));
        expect(error.code, equals('MAX_DIGITS_EXCEEDED'));

        // Cannot modify: error.maxDigits = 10; // Would cause compile error
      });

      test('should handle const constructors', () {
        const error1 = ZeroNotAllowedError();
        const error2 = ZeroNotAllowedError();

        expect(identical(error1, error2), isTrue);
      });
    });
  });
}
