// ignore: library_names
library validatorless;

import 'package:flutter/widgets.dart'
    show FormFieldValidator, TextEditingController;
import 'package:validatorless/cnpj.dart';
import 'package:validatorless/cpf.dart';

class Validatorless {
  Validatorless._();

  /// ```dart
  ///  Validatorless.required('filed is required')
  /// ```
  static FormFieldValidator required(String m) {
    return (v) {
      if (v?.isEmpty ?? true) return m;
      return null;
    };
  }

  /// ```dart
  ///  Validatorless.numbersBetweenInterval(1, 10, 'enter a value between min and max')
  /// ```
  static FormFieldValidator numbersBetweenInterval(
    double min,
    double max,
    String message,
  ) {
    return (v) {
      if (v?.isEmpty ?? true) return message;
      if (double.tryParse(v) == null) return message;
      if (double.parse(v) < min || double.parse(v) > max) return message;
      return null;
    };
  }

  /// ```dart
  ///  Validatorless.numbersBetweenInterval(1, 10, 'enter a value between min and max not included')
  /// ```
  static FormFieldValidator numbersBetweenIntervalNotIncluded(
    double min,
    double max,
    String message,
  ) {
    return (v) {
      if (v?.isEmpty ?? true) return message;
      if (double.tryParse(v) == null) return message;
      if (double.parse(v) <= min || double.parse(v) >= max) return message;
      return null;
    };
  }

  /// ```dart
  ///  Validatorless.regex(RegExp(r'^[a-zA-Z]+$'), 'only letters')
  /// ```
  static FormFieldValidator regex(RegExp reg, String message) {
    return (v) {
      if (reg.hasMatch(v)) return null;
      return message;
    };
  }

  /// ```dart
  ///  Validatorless.onlyCharacters('only characters')
  /// ```
  static FormFieldValidator onlyCharacters(String message) {
    return (v) {
      if (RegExp(r'^[a-zA-Z]+$').hasMatch(v)) return null;
      return message;
    };
  }

  /// ```dart
  ///  Validatorless.min(4, 'field min 4')
  /// ```
  static FormFieldValidator<String> min(int min, String m) {
    return (v) {
      if (v?.isEmpty ?? true) return null;
      if ((v?.length ?? 0) < min) return m;
      return null;
    };
  }

  /// ```dart
  /// Validatorless.max(4, 'field max 4')
  /// ```
  static FormFieldValidator<String> max(int max, String m) {
    return (v) {
      if (v?.isEmpty ?? true) return null;
      if ((v?.length ?? 0) > max) return m;
      return null;
    };
  }

  /// ```dart
  /// Validatorless.between(6, 10, 'password must have between 6 and 10 digits')
  /// ```
  static FormFieldValidator<String> between(
    int minimumLength,
    int maximumLength,
    String errorMessage,
  ) {
    assert(minimumLength < maximumLength);
    return multiple([
      min(minimumLength, errorMessage),
      max(maximumLength, errorMessage),
    ]);
  }

  /// ```dart
  ///  Validatorless.number('Value not a number')
  /// ```
  static FormFieldValidator<String> number(String m) {
    return (v) {
      if (v?.isEmpty ?? true) return null;
      if (double.tryParse(v!) != null)
        return null;
      else
        return m;
    };
  }

  /// ```dart
  ///  Validatorless.email('Value is not email')
  /// ```
  static FormFieldValidator<String> email(String m) {
    return (v) {
      if (v?.isEmpty ?? true) return null;
      final emailRegex = RegExp(
          r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
      if (emailRegex.hasMatch(v!)) return null;
      return m;
    };
  }

  /// ```dart
  ///  Validatorless.cpfOrCnpj('This CPF is not valid', 'This CNPJ is not valid')
  /// ```
  static FormFieldValidator<String> cpfOrCnpj(String mCpf, String mCnpj) {
    return (v) {
      if (v?.isEmpty ?? true) return null;

      const int cpfMaxLength = 11;
      final strippedValue = CNPJValidator.strip(v!);

      if (strippedValue.length <= cpfMaxLength) {
        if (CpfValidator.isValid(v!))
          return null;
        else
          return mCpf;
      } else {
        if (CNPJValidator.isValid(v!))
          return null;
        else
          return mCnpj;
      }
    };
  }

  /// ```dart
  ///  Validatorless.cpf('This CPF is not valid')
  /// ```
  static FormFieldValidator<String> cpf(String m) {
    return (v) {
      if (v?.isEmpty ?? true) return null;
      if (CpfValidator.isValid(v!))
        return null;
      else
        return m;
    };
  }

  /// ```dart
  ///  Validatorless.cnpj('This CNPJ is not valid')
  /// ```
  static FormFieldValidator<String> cnpj(String m) {
    return (v) {
      if (v?.isEmpty ?? true) return null;
      if (CNPJValidator.isValid(v!))
        return null;
      else
        return m;
    };
  }

  /// ```dart
  ///  Validatorless.multiple([
  ///    Validatorless.email('Value is not email')
  ///    Validatorless.max(4, 'field max 4')
  ///  ])
  /// ```
  static FormFieldValidator<String> multiple(
      List<FormFieldValidator<String>> v) {
    return (value) {
      for (final validator in v) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  /// ```dart
  /// Validatorless.date('invalid date')
  /// ```
  static FormFieldValidator<String> date(String errorMessage) {
    return (value) {
      final date = DateTime.tryParse(value ?? '');
      if (date == null) {
        return errorMessage;
      }
      return null;
    };
  }

  /// ```dart
  /// Validatorless.compare(inputController, 'Passwords do not match')
  /// ```
  static FormFieldValidator<String> compare(
      TextEditingController? controller, String message) {
    return (value) {
      final textCompare = controller?.text ?? '';
      if (value == null || textCompare != value) {
        return message;
      }
      return null;
    };
  }

  /// ```dart
  ///  Validatorless.length(4, 'field must have 4 characters')
  /// ```
  static FormFieldValidator<String> length(int length, String m) {
    return (v) {
      if (v?.isEmpty ?? true) return null;
      if ((v?.length ?? 0) != length) return m;
      return null;
    };
  }
}
