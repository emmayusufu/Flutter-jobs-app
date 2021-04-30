import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:workmannow/classes/auth/login.dart';
import 'package:workmannow/helpers/colors.dart';
import 'package:workmannow/providers/auth.dart';
import 'package:workmannow/widgets/InputField.dart';
import 'package:workmannow/widgets/round_button.dart';
import 'package:workmannow/widgets/phone_input_field.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phoneNumber;
  String password;
  bool loading = false;
  bool isPhoneNumberValid;
  String initialCountry = 'UG';
  PhoneNumber number = PhoneNumber(isoCode: 'UG');

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var onTapRegister;

  @override
  void initState() {
    super.initState();
    onTapRegister = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(context).pushNamed('/registration');
      };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/fig.png',
                      height: 150.0,
                    ),
                  ),
                  Text(
                    'WorkManNow',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  PhoneInputField(
                    number: number,
                    onInputChanged: (PhoneNumber number) {
                      setState(() {
                        phoneNumber = number.phoneNumber;
                      });
                    },
                    onInputValidated: (bool value) {
                      setState(() {
                        isPhoneNumberValid = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (value.isNotEmpty) {
                        if (!isPhoneNumberValid) {
                          return 'An invalid phone number was entered';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  InputField(
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Password field must not be empty';
                      }
                      return null;
                    },
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password',
                    cb: (text) {
                      setState(() {
                        password = text;
                      });
                    },
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: RoundButton(
                        cb: () {
                          if (_formKey.currentState.validate()) {
                            _submit();
                          }
                        },
                        name: 'Login'),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Quicksand',
                            fontSize: 13),
                        children: [
                          TextSpan(
                              text: " Sign Up",
                              recognizer: onTapRegister,
                              style: TextStyle(
                                color: MyColors.blue,
                                fontWeight: FontWeight.w400,
                              ))
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    EasyLoading.show(
        status: 'logging in ...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
        indicator: SpinKitCircle(
          color: Colors.white,
          size: 50.0,
        ));
    Provider.of<AuthProvider>(_scaffoldKey.currentContext, listen: false)
        .login(LoginModal(phoneNumber: phoneNumber, password: password))
        .then((String message) async {
      if (message == 'success') {
        if (mounted) {
          await EasyLoading.dismiss();
          Navigator.popAndPushNamed(_scaffoldKey.currentContext, '/home');
        }
      } else if (message == 'phoneNumber_not_registered') {
        await EasyLoading.dismiss();
        _showSnackBar('Phone number not registered');
      } else if (message == 'account_not_valid') {
        await EasyLoading.dismiss();
        _showSnackBar('Account has not been validated');
      } else if (message == 'wrong_password') {
        await EasyLoading.dismiss();
        _showSnackBar('A wrong password was entered');
      } else {
        await EasyLoading.dismiss();
        _showSnackBar('Something went wrong');
      }
    }).catchError((e) async {
      await EasyLoading.dismiss();
      print('caught error : $e');
    });
  }

  _showSnackBar(String text) {
    final snackbar = SnackBar(
      duration: Duration(seconds: 1),
      content: Text(
        '$text',
        style: TextStyle(fontFamily: 'Quicksand'),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
