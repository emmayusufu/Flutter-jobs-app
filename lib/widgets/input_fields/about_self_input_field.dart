import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutSelfInputField extends StatelessWidget {

  final Function onChanged;
  final TextEditingController controller;

  AboutSelfInputField({
    @required this.onChanged,
    this.controller
});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 5,
      maxLength: 200,
      inputFormatters: [
        new LengthLimitingTextInputFormatter(200),
      ],
      style:
      TextStyle(color: Colors.blue, fontSize: 13.0),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 10.0),
        hintText: 'About your self',
        hintStyle:
        TextStyle(color: Colors.blue, fontSize: 13.0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              20.0,
            ),
            borderSide: BorderSide(
              color: Colors.blue[100],
            )),
      ),
      onChanged: onChanged,
      validator:  (String value) {
        if (value.isEmpty) {
          return 'About yourself field is empty';
        }
        return null;
      }
      ,
    );
  }
}
