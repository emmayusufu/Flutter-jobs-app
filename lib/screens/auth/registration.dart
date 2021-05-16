import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:workmannow/classes/user/index.dart';
import 'package:workmannow/helpers/colors.dart';
import 'package:workmannow/providers/user.dart';
import 'package:workmannow/screens/auth/otp_screen.dart';
import 'package:workmannow/screens/auth/terms_of_service.dart';
import 'package:workmannow/widgets/buttons/rounded_button.dart';
import 'package:workmannow/widgets/input_fields/input_field.dart';
import 'package:workmannow/widgets/input_fields/password_input_field.dart';
import 'package:workmannow/widgets/input_fields/phone_input_field.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String phoneNumber;
  String email;
  String password;
  bool loading = false;
  bool termsOfService = false;

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
                      PhoneInputField(onChanged: (PhoneNumber value) {
                        setState(() {
                          phoneNumber = value.completeNumber;
                        });
                      }),
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
                        onChanged: (text) {
                          setState(() {
                            email = text;
                          });
                        },
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      PasswordInputField(
                        onChanged: (String value) {
                          setState(() {
                            password = value;
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
                      GestureDetector(
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
                        child: RoundedButton(
                            onPressed: () {
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
        status: 'Registering account',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
        indicator: SpinKitPouringHourglass(
          color: Colors.white,
          size: 50.0,
        ));
    Provider.of<UserProvider>(context, listen: false)
        .register(
            User(email: email, password: password, phoneNumber: phoneNumber))
        .then((String message) async {
      switch (message) {
        case 'success':
          {
            if (mounted) {
              await EasyLoading.dismiss();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => OTPScreen(
                        phoneNumber: phoneNumber,
                      )));
            }
          }
          break;
        case 'phone_number_already_number_exists':
          {
            await EasyLoading.dismiss();
            _showSnackBar('Phone number already exists');
          }
          break;
        default:
          {
            await EasyLoading.dismiss();
            _showSnackBar('Something went wrong');
          }
          break;
      }
    }).catchError((err) async {
      await EasyLoading.dismiss();
      {
        throw (err);
      }
    });
  }
}
