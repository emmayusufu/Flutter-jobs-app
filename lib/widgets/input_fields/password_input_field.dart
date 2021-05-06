import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PasswordInputField extends StatelessWidget {
  final Function onChanged;

  PasswordInputField({@required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.blue, fontSize: 13.0),
      onChanged: onChanged,
      obscureText: true,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          hintText: 'Password',
          hintStyle: TextStyle(color: Colors.blue),
          floatingLabelBehavior: FloatingLabelBehavior.auto),
      validator: (value) {
        if (value.isEmpty) {
          return 'Password field must not be empty';
        }
        return null;
      },
    );
  }
}
