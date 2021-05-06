import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';
import 'package:workmannow/classes/user/index.dart';
import 'package:workmannow/helpers/colors.dart';
import 'package:workmannow/screens/auth/choose_account_type.dart';
import 'package:workmannow/providers/user.dart';
import 'package:workmannow/widgets/buttons/rounded_button.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  OTPScreen({@required this.phoneNumber});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String otp;
  bool loading = false;

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
      child: Builder(
        builder: (BuildContext context) => Scaffold(
          key: _scaffoldKey,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Verify phone number',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'Code was sent to',
                        style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Quicksand',
                            fontSize: 13),
                        children: [
                          TextSpan(
                              text: "  ${widget.phoneNumber}",
                              style: TextStyle(
                                color: MyColors.blue,
                                fontWeight: FontWeight.bold,
                              ))
                        ]),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Form(
                    key: _formKey,
                    child: PinInputTextFormField(
                      validator: (value) {
                        if (value.length < 5) {
                          return 'Empty fields';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {
                          otp = value;
                        });
                      },
                      pinLength: 5,
                    ),
                  ),
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
                        name: 'Verify and create account'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
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
        status: 'Verifying OTP',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
        indicator: SpinKitPouringHourglass(
          color: Colors.white,
          size: 50.0,
        ));
    Provider.of<UserProvider>(context, listen: false)
        .verifyOtp(User(phoneNumber: widget.phoneNumber, otp: otp))
        .then((String message) async {
      if (message == 'success') {
        if (mounted) {
          await EasyLoading.dismiss();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ChooseAccountType()));
        }
      } else if (message == 'wrong_otp') {
        await EasyLoading.dismiss();
        _showSnackBar('Entered a wrong OTP');
      } else {
        await EasyLoading.dismiss();
        _showSnackBar('Something went wrong');
      }
    }).catchError((e) async {
      await EasyLoading.dismiss();
      print('caught error $e');
    });
  }
}
