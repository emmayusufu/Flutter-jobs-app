import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final bool obscureText;
  final Icon prefixIcon;
  final String labelText;
  final Function validator;
  final String helperText;
  final Function onChanged;
  final inputFormatters;
  final prefix;
  final TextEditingController controller;

  InputField(
      {this.obscureText,
      this.prefixIcon,
      this.labelText,
      this.validator,
      this.helperText,
      this.inputFormatters,
      this.prefix,
      this.controller,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.blue, fontSize: 13.0),
      inputFormatters: inputFormatters,
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText == null ? false : obscureText,
      decoration: InputDecoration(
          helperText: helperText,
          prefixIcon: prefixIcon,
          hintText: labelText,
          hintStyle: TextStyle(color: Colors.blue),
          prefix: prefix,
          floatingLabelBehavior: FloatingLabelBehavior.auto),
      validator: validator,
    );
  }
}
