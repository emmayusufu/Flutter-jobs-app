import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneInputField extends StatelessWidget {
  final onInputChanged;
  final onInputValidated;
  final number;
  final validator;

  PhoneInputField(
      {@required this.onInputChanged,
      @required this.onInputValidated,
      @required this.number,
      @required this.validator});
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      textStyle: TextStyle(color: Colors.blue, fontSize: 13.0),
      inputDecoration: InputDecoration(
        hintText: 'Phone number',
        hintStyle: TextStyle(fontSize: 13.0, color: Colors.blue),
        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      onInputChanged: onInputChanged,
      onInputValidated: onInputValidated,
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.DIALOG,
        // backgroundColor: Colors.white,
      ),
      ignoreBlank: false,
      selectorTextStyle: TextStyle(color: Colors.black45),
      initialValue: number,
      validator: validator,
    );
  }
}
