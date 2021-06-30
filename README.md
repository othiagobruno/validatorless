# Validatorless

This package provides a means to validate text inputs on the flutter and was inspired by Yup

[Validatorless in pub.dev](https://pub.dev/packages/validatorless)

### how to use

```yaml
dependencies:
  # Use the latest version available. Any is just a placeholder
  validatorless: any
```

```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'User e-mail',
  ),
  validator: Validatorless.multiple([
     Validatorless.email('The field must be an email'),
     Validatorless.required('The field is obligatory')
  ]),
)
```

or use
```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'CPF',
  ),
  validator: Validatorless.cpf('CPF not is valid'),
)
```

### Validatorless functions 

```dart
 Validatorless.required(String)
 Validatorless.email(String)
 Validatorless.min(Number, String)
 Validatorless.max(Number, String)
 Validatorless.number(String)
 Validatorless.cpf(String) 
 Validatorless.cnpj(String) 
 Validatorless.date(String) 
```