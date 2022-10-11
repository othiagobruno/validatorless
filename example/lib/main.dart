import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

void main() {
  final formKey = GlobalKey<FormState>();

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Hello World'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
              ),
              validator: Validatorless.multiple([
                Validatorless.required('Name is required'),
                Validatorless.min(3, 'Name must be at least 3 characters'),
                Validatorless.max(20, 'Name must be at most 20 characters'),
              ]),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              validator: Validatorless.multiple([
                Validatorless.required('Email is required'),
                Validatorless.email('Invalid email'),
              ]),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              validator: Validatorless.multiple([
                Validatorless.required('Password is required'),
                Validatorless.min(6, 'Password must be at least 6 characters'),
                Validatorless.max(20, 'Password must be at most 20 characters'),
              ]),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  print('Valid');
                } else {
                  print('Invalid');
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    ),
  ));
}
