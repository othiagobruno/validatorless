// ignore: library_names
library validatorless;

import 'package:flutter/widgets.dart' show FormFieldValidator;
import 'package:validatorless/cnpj.dart';
import 'package:validatorless/cpf.dart';

class Validatorless {
  // Validatorless.require('filed is required')
  static FormFieldValidator required(String m) {
    return (v) {
      if (v?.isEmpty) return m;
      return null;
    };
  }

  // Validatorless.min(4, 'field min 4')
  static FormFieldValidator<String> min(double min, String m) {
    return (v) {
      if (v?.isEmpty ?? false) return null;
      if ((v?.length ?? 0) < min) return m;
      return null;
    };
  }

  // Validatorless.max(4, 'field max 4')
  static FormFieldValidator<String> max(double max, String m) {
    return (v) {
      if (v?.isEmpty ?? false) return null;
      if ((v?.length ?? 0) > max) return m;
      return null;
    };
  }

  // Validatorless.number('Value not a number')
  static FormFieldValidator<String> number(String m) {
    return (v) {
      if (v?.isEmpty ?? false) return null;
      if (double.tryParse(v!) != null)
        return null;
      else
        return m;
    };
  }

  // Validatorless.email('Value is not email')
  static FormFieldValidator<String> email(String m) {
    return (v) {
      if (v?.isEmpty ?? false) return null;
      final emailRegex = RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
      if (emailRegex.hasMatch(v!)) return null;
      return m;
    };
  }

  // Validatorless.cpf('This CPF is not valid')
  static FormFieldValidator<String> cpf(String m) {
    return (v) {
      if (v?.isEmpty ?? false) return null;
      if (CpfValidator.isValid(v!))
        return null;
      else
        return m;
    };
  }

  // Validatorless.cnpj('This CNPJ is not valid')
  static FormFieldValidator<String> cnpj(String m) {
    return (v) {
      if (v?.isEmpty ?? false) return null;
      if (CNPJValidator.isValid(v!))
        return null;
      else
        return m;
    };
  }

  // Validatorless.multiple([
  //   Validatorless.email('Value is not email')
  //   Validatorless.max(4, 'field max 4')
  // ])
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
}
