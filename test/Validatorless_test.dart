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
}
