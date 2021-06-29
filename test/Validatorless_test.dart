import 'package:flutter_test/flutter_test.dart';

import 'package:validatorless/validatorless.dart';

void main() {
  test('validate values', () {
    Validatorless.required('');
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
