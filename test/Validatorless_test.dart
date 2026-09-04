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

  group('cep', () {
    test('accepts CEP with and without hyphen', () {
      final validator = Validatorless.cep('invalid CEP');
      expect(validator('12345678'), isNull);
      expect(validator('12345-678'), isNull);
    });

    test('rejects invalid lengths and formats', () {
      final expectedError = 'invalid CEP';
      final validator = Validatorless.cep(expectedError);
      expect(validator('1234567'), expectedError);
      expect(validator('123456789'), expectedError);
      expect(validator('1234-5678'), expectedError);
      expect(validator('12345_678'), expectedError);
      expect(validator('ABCDEFGH'), expectedError);
      expect(validator('12.345-678'), expectedError);
    });

    test('accepts empty values', () {
      final validator = Validatorless.cep('invalid CEP');
      expect(validator(''), isNull);
      expect(validator(null), isNull);
    });
  });

  group('url', () {
    test('accepts HTTP and HTTPS URLs', () {
      final validator = Validatorless.url('invalid URL');
      expect(validator('https://flutter.dev'), isNull);
      expect(validator('http://example.com'), isNull);
      expect(validator('https://www.example.com/path?q=1'), isNull);
      expect(validator('http://localhost:8080'), isNull);
      expect(validator('https://192.168.0.1'), isNull);
    });

    test('rejects invalid URLs', () {
      final expectedError = 'invalid URL';
      final validator = Validatorless.url(expectedError);
      expect(validator('not a url'), expectedError);
      expect(validator('ftp://example.com'), expectedError);
      expect(validator('example.com'), expectedError);
      expect(validator('https://'), expectedError);
      expect(validator('javascript:alert(1)'), expectedError);
    });

    test('accepts empty values', () {
      final validator = Validatorless.url('invalid URL');
      expect(validator(''), isNull);
      expect(validator(null), isNull);
    });
  });

  group('strongPassword', () {
    test('accepts a password that meets the default rules', () {
      final validator = Validatorless.strongPassword('weak password');
      expect(validator('Abcdef1!'), isNull);
    });

    test('rejects passwords missing required rules', () {
      final expectedError = 'weak password';
      final validator = Validatorless.strongPassword(expectedError);
      expect(validator('Ab1!'), expectedError);
      expect(validator('abcdef1!'), expectedError);
      expect(validator('Abcdefgh!'), expectedError);
      expect(validator('Abcdefg1'), expectedError);
    });

    test('respects a custom minLength', () {
      final expectedError = 'weak password';
      final validator =
          Validatorless.strongPassword(expectedError, minLength: 10);
      expect(validator('Abcdef1!'), expectedError);
      expect(validator('Abcdefgh1!'), isNull);
    });

    test('accepts empty values', () {
      final validator = Validatorless.strongPassword('weak password');
      expect(validator(''), isNull);
      expect(validator(null), isNull);
    });
  });

  group('creditCard', () {
    test('accepts valid card numbers', () {
      final validator = Validatorless.creditCard('invalid card');
      expect(validator('4111111111111111'), isNull);
      expect(validator('5500000000000004'), isNull);
      expect(validator('378282246310005'), isNull);
      expect(validator('4111 1111 1111 1111'), isNull);
      expect(validator('4111-1111-1111-1111'), isNull);
    });

    test('rejects invalid card numbers', () {
      final expectedError = 'invalid card';
      final validator = Validatorless.creditCard(expectedError);
      expect(validator('4111111111111112'), expectedError);
      expect(validator('123'), expectedError);
      expect(validator('0000000000000000'), expectedError);
      expect(validator('abcdefghijklmnop'), expectedError);
    });

    test('accepts empty values', () {
      final validator = Validatorless.creditCard('invalid card');
      expect(validator(''), isNull);
      expect(validator(null), isNull);
    });
  });

  group('placa', () {
    test('accepts old and Mercosul formats', () {
      final validator = Validatorless.placa('invalid plate');
      expect(validator('ABC1234'), isNull);
      expect(validator('ABC-1234'), isNull);
      expect(validator('abc1234'), isNull);
      expect(validator('ABC1D23'), isNull);
      expect(validator('ABC-1D23'), isNull);
      expect(validator('abc1d23'), isNull);
    });

    test('rejects invalid plates', () {
      final expectedError = 'invalid plate';
      final validator = Validatorless.placa(expectedError);
      expect(validator('AB1234'), expectedError);
      expect(validator('ABCD1234'), expectedError);
      expect(validator('ABC123'), expectedError);
      expect(validator('ABC12D3'), expectedError);
      expect(validator('1234567'), expectedError);
      expect(validator('AB-C1234'), expectedError);
    });

    test('accepts empty values', () {
      final validator = Validatorless.placa('invalid plate');
      expect(validator(''), isNull);
      expect(validator(null), isNull);
    });
  });
}
