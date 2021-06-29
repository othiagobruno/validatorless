import 'package:flutter_test/flutter_test.dart';

import 'package:validatorless/validatorless.dart';

void main() {
  test('validate values', () {
    Validatorless.required('');
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
}
