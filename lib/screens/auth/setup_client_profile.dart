import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:workmannow/classes/user/index.dart';
import 'package:workmannow/helpers/colors.dart';
import 'package:workmannow/providers/user.dart';
import 'package:workmannow/widgets/input_field.dart';
import 'package:workmannow/widgets/rounded_button.dart';

class SetUpClientProfile extends StatefulWidget {
  @override
  _SetUpClientProfileState createState() => _SetUpClientProfileState();
}

class _SetUpClientProfileState extends State<SetUpClientProfile> {
  String firstName;
  String lastName;
  File profileImage;

  final picker = ImagePicker();
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
          centerTitle: true,
          title: Text(
            'Setup Client Profile',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    // =========================================================================================== client profile picture
                    Stack(
                      children: [
                        CircleAvatar(
                            radius: 80.0,
                            backgroundImage: profileImage != null
                                ? FileImage(profileImage)
                                : AssetImage('assets/dp.png')),
                        Positioned(
                          bottom: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                                border: new Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                                shape: BoxShape.circle,
                                color: MyColors.blue),
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                size: 30.0,
                                color: Colors.white,
                              ),
                              onPressed: getDp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    InputField(
                      labelText: 'First name',
                      prefixIcon: Icon(Icons.person),
                      onChanged: (String value) {
                        setState(() {
                          firstName = value;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'First name must not be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    InputField(
                      labelText: 'Last name',
                      prefixIcon: Icon(Icons.person),
                      onChanged: (String value) {
                        setState(() {
                          lastName = value;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Last name must not be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    RoundedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _submit();
                          }
                        },
                        name: 'Submit')
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getDp() async {
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        if (pickedImage != null) {
          profileImage = File(pickedImage.path);
        }
      });
    }
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

  Future _submit() async {
    EasyLoading.show(
        status: 'Setting up profile',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
        indicator: SpinKitPouringHourglass(
          color: Colors.white,
          size: 50.0,
        ));
    Provider.of<UserProvider>(_scaffoldKey.currentContext, listen: false)
        .setUpClientProfile(User(
            profileImage: profileImage,
            firstName: firstName,
            lastName: lastName))
        .then((String message) async {
      if (message == 'success') {
        if (mounted) {
          await EasyLoading.dismiss();
          Navigator.popAndPushNamed(_scaffoldKey.currentContext, '/home');
        }
      } else {
        await EasyLoading.dismiss();
        _showSnackBar('Something went wrong');
      }
    }).catchError((e) async {
      await EasyLoading.dismiss();
      print('caught error : $e');
    });
  }
}
