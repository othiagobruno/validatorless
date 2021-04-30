import 'package:flutter_test/flutter_test.dart';

import 'package:validatorless/validatorless.dart';

void main() {
  test('validate values', () {
    Validatorless.required('');
  });
}
