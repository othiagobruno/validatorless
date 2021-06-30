import 'package:flutter_test/flutter_test.dart';

import 'package:validatorless/validatorless.dart';

void main() {
  group('required', () {
    test("rejects when it's empty", () {
      final expectedError = 'this field can not be empty';
      final validator = Validatorless.required(expectedError);
      final error = validator('');
      expect(error, expectedError);
    });

    test("rejects when it's null", () {
      final expectedError = 'this field can not be empty';
      final validator = Validatorless.required(expectedError);
      final error = validator(null);
      expect(error, expectedError);
    });

    test("accepts when it's not empty", () {
      final validator = Validatorless.required('this field can not be empty');
      final error = validator('valid text');
      expect(error, isNull);
    });
  });

  group('date', () {
    test('accepts ISO 8601 formatted dates', () {
      final validator = Validatorless.date('invalid date');
      expect(validator("2012-02-27"), isNull);
      expect(validator("2012-02-27 13:27:00"), isNull);
      expect(validator("2012-02-27 13:27:00.123456789z"), isNull);
      expect(validator("2012-02-27 13:27:00,123456789z"), isNull);
      expect(validator("20120227 13:27:00"), isNull);
      expect(validator("20120227T132700"), isNull);
      expect(validator("20120227"), isNull);
      expect(validator("+20120227"), isNull);
      expect(validator("2012-02-27T14Z"), isNull);
      expect(validator("2012-02-27T14+00:00"), isNull);
      expect(validator("-123450101 00:00:00 Z"), isNull);
      expect(validator("2002-02-27T14:00:00-0500"), isNull);
    });

    test('rejects dates othen than ISO dates', () {
      final validator = Validatorless.date('invalid date');
      expect(validator("27/02/2012"), isNotNull);
      expect(validator("2012/02/27"), isNotNull);
    });
  });

  group('betwen', () {
    group('accepts', () {
      test('when its between the limits', () {
        final validator = Validatorless.between(3, 6, 'must have between 3 and 6');
        final error = validator('12345');
        expect(error, isNull);
      });

      test("when it's at the upper limit", () {
        final validator = Validatorless.between(3, 6, 'must have between 3 and 6');
        final error = validator('123456');
        expect(error, isNull);
      });

      test("when it's at the lower limit", () {
        final validator = Validatorless.between(3, 6, 'must have between 3 and 6');
        final error = validator('123');
        expect(error, isNull);
      });
    });
    
    group('rejects', () {
      test("rejects when it's bellow the lower limit", () {
        final expectedError = 'must have between 3 and 6';
        final validator = Validatorless.between(3, 6, expectedError);
        final error = validator('12');
        expect(error, expectedError);
      });

      test("rejects when it's above the upper limit", () {
        final expectedError = 'must have between 3 and 6';
        final validator = Validatorless.between(3, 6, expectedError);
        final error = validator('1234567');
        expect(error, expectedError);
      });
    });
  });
}
