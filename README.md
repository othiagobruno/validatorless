# Validatorless

This package provides a means to validate text inputs on the flutter and was inspired by Yup

### how to use
import Validatorless

```
TextFormField(
  decoration: InputDecoration(
    labelText: 'User e-mail',
  ),
  validator: Validatorless.multiple([
     Validatorless.email('The field must be an email')
     Validatorless.required('The field is obligatory')
   ]),
)```