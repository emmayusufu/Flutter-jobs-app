import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:workmannow/classes/auth/signup.dart';
import 'package:workmannow/helpers/colors.dart';
import 'package:workmannow/pages/auth/terms_of_service.dart';
import 'package:workmannow/providers/auth.dart';
import 'package:workmannow/widgets/InputField.dart';
import 'package:workmannow/widgets/phone_input_field.dart';
import 'package:workmannow/widgets/round_button.dart';
import 'package:workmannow/pages/auth/otp_screen.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String contact;
  String email;
  String password;
  bool loading = false;
  bool isContactValid;
  bool termsOfService = false;
  String initialCountry = 'UG';
  PhoneNumber number = PhoneNumber(isoCode: 'UG');

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          appBar: AppBar(
            title: Text('Create account'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PhoneInputField(
                        onInputChanged: (PhoneNumber number) {
                          setState(() {
                            contact = number.phoneNumber;
                          });
                        },
                        onInputValidated: (bool value) {
                          setState(() {
                            isContactValid = value;
                          });
                        },
                        number: number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your phone number';
                          } else if (value.isNotEmpty) {
                            if (!isContactValid) {
                              return 'An invalid contact was entered';
                            }
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      InputField(
                        prefixIcon: Icon(
                          CupertinoIcons.mail_solid,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Email must not be empty';
                          }
                          return null;
                        },
                        labelText: 'Email',
                        cb: (text) {
                          setState(() {
                            email = text;
                          });
                        },
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      InputField(
                        helperText: 'Password should have a minimum of 6 chars',
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Password field must not be empty';
                          } else if (value.isNotEmpty) {
                            if (value.length < 6) {
                              return 'Password should be at least 6 characters';
                            }
                          }
                          return null;
                        },
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        cb: (text) {
                          setState(() {
                            password = text;
                          });
                        },
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Text(
                        'By creating an account you agree to our',
                        textAlign: TextAlign.center,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => TermsOfService()));
                          },
                          child: Text(
                            'terms of service and privacy',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: MyColors.blue),
                          )),
                      SizedBox(
                        height: 50.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50.0,
                        ),
                        child: RoundButton(
                            cb: () {
                              if (_formKey.currentState.validate()) {
                                _submit(context);
                              }
                            },
                            name: 'Register'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  _showSnackBar(String text) {
    final snackbar = SnackBar(
      duration: Duration(seconds: 3),
      content: Text(
        '$text',
        style: TextStyle(fontFamily: 'Quicksand'),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future _submit(context) async {
    EasyLoading.show(
        status: 'Registering account ...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
        indicator: SpinKitCircle(
          color: Colors.white,
          size: 50.0,
        ));
    Provider.of<AuthProvider>(context, listen: false)
        .signup(
            SignUpModal(email: email, password: password, phoneNumber: contact))
        .then((String message) async {
      if (message == 'success') {
        if (mounted) {
          await EasyLoading.dismiss();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => OTP(
                    contact: contact,
                  )));
        }
      } else if (message == 'phone_number_exists') {
        await EasyLoading.dismiss();
        _showSnackBar('Phone number already exists');
      } else {
        await EasyLoading.dismiss();
        _showSnackBar('Something went wrong');
      }
    }).catchError((e) async {
      await EasyLoading.dismiss();
      {
        print('caught error $e');
      }
    });
  }
}
