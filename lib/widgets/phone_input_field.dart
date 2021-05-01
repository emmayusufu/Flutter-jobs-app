import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneInputField extends StatelessWidget {
  final onChanged;

  PhoneInputField(
      {@required this.onChanged,});


  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      initialCountryCode: 'UG',
      decoration: InputDecoration(
        hintText: 'Phone Number',
        hintStyle: TextStyle(fontSize: 13.0, color: Colors.blue),
      ),
      onChanged: onChanged,
      keyboardType: TextInputType.phone,
      style: TextStyle(color: Colors.blue, fontSize: 13.0),
      autoValidate: false,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your number';
        }else if(value.isNotEmpty){
          if(value.length!=9){
            return 'Missing digits';
          }
        }
        return null;
      },
    );
  }
}
