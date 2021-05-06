import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmannow/classes/hiring/index.dart';
import 'package:workmannow/helpers/colors.dart';
import 'package:workmannow/providers/hiring.dart';
import 'package:workmannow/providers/user.dart';
import 'package:workmannow/screens/utility/waiting.dart';
import 'package:workmannow/widgets/buttons/rounded_button.dart';
import 'package:workmannow/widgets/input_fields/phone_input_field.dart';

class HiringDetails extends StatefulWidget {
  final workman;

  HiringDetails({@required this.workman});

  @override
  _HiringDetailsState createState() => _HiringDetailsState();
}

class _HiringDetailsState extends State<HiringDetails> {
  String phoneNumber = '';
  bool isContactValid;
  String jobDescription;
  String location;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Map> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map userData = jsonDecode(prefs.getString('user'));
    return userData;
  }

  @override
  void initState() {
    super.initState();
    getUser().then((user) {
      setState(() {
        phoneNumber = user['phoneNumber'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final workman = widget.workman;
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      Map user = userProvider.user;
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
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: MyColors.blue),
            title: Text(
              'Workman profile',
              style: TextStyle(color: MyColors.blue),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'WorkMan details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 5.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.grey[200], width: 2.0)),
                            child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage: workman['profileImage'] != null
                                    ? NetworkImage(
                                        'http://192.168.43.77:3001/' +
                                            workman['profileImage']['medium'],
                                      )
                                    : AssetImage('assets/dp.png')),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${workman['firstName']} ${workman['lastName']}'
                                    .titleCase,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                '${workman['profession']}'.sentenceCase,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Your(Client) details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45),
                        ),
                      ),
                    ],
                  ),
                  Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 5.0),
                      child: Column(
                        children: [
                          // ============================================================================== client contact
                          ListTile(
                            subtitle: Text('Your contact'),
                            leading: CircleAvatar(child: Icon(Icons.phone)),
                            title: Text(phoneNumber),
                            trailing: IconButton(
                                icon: Icon(
                                  CupertinoIcons.pen,
                                  size: 25.0,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 40.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                PhoneInputField(
                                                  onChanged:
                                                      (PhoneNumber number) {
                                                    setState(() {
                                                      phoneNumber =
                                                          number.completeNumber;
                                                    });
                                                  },
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  // child:
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Job description',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45),
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      style: TextStyle(color: Colors.blue, fontSize: 14.0),
                      maxLines: 5,
                      maxLength: 200,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(200),
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        hintText: 'A brief description of the job offer',
                        hintStyle:
                            TextStyle(color: Colors.blue, fontSize: 14.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                            borderSide: BorderSide(
                              color: Colors.blue[100],
                            )),
                      ),
                      onChanged: (value) {
                        setState(() {
                          jobDescription = value;
                        });
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Job description is empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RoundedButton(
                    onPressed: () {
                      final FocusScopeNode currentScope =
                          FocusScope.of(context);
                      if (!currentScope.hasPrimaryFocus &&
                          currentScope.hasFocus) {
                        FocusManager.instance.primaryFocus.unfocus();
                      }
                      if (_formKey.currentState.validate()) {
                        _submit(
                            clientId: user['_id'],
                            clientImage: jsonEncode(user['profileImage']),
                            workManId: workman['_id'],
                            workManPhoneNumber: workman['phoneNumber'],
                            clientName:
                                '${user['firstName']} ${user['lastName']}');
                      }
                    },
                    name: 'Confirm to proceed',
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _submit(
      {String clientId,
      String workManId,
      String workManPhoneNumber,
      String clientName,
      String clientImage}) async {
    EasyLoading.show(
        status: 'Submitting hire request',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
        indicator: SpinKitPouringHourglass(
          color: Colors.white,
          size: 50.0,
        ));

    Provider.of<HiringProvider>(context, listen: false)
        .hireWorkMan(Hiring(
      jobDescription: jobDescription,
      clientImage: clientImage,
      clientId: clientId,
      workManId: workManId,
      clientPhoneNumber: phoneNumber,
      workManPhoneNumber: workManPhoneNumber,
      clientName: clientName,
    ))
        .then((String message) async {
      if (message == 'success') {
        if (mounted) {
          await EasyLoading.dismiss();
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return Waiting();
          }));
        }
      } else {
        await EasyLoading.dismiss();
        _showSnackBar('Something went wrong');
      }
    }).catchError((err) async {
      await EasyLoading.dismiss();
      _showSnackBar('Something went wrong');
      print(err);
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
