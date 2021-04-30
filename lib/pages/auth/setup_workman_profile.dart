import 'dart:convert';
import 'dart:io';

import 'package:workmannow/classes/auth/profile_setup.dart';
import 'package:workmannow/helpers/colors.dart';
import 'package:workmannow/providers/auth.dart';
import 'package:workmannow/widgets/InputField.dart';
import 'package:workmannow/widgets/dropdown_search.dart';
import 'package:workmannow/widgets/multi_dropdown_search.dart';
import 'package:workmannow/widgets/round_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SetupWorkManProfile extends StatefulWidget {
  @override
  _SetupWorkManProfileState createState() => _SetupWorkManProfileState();
}

class _SetupWorkManProfileState extends State<SetupWorkManProfile> {
  String firstName;
  String lastName;
  DateTime dob;
  String profession;
  String qualification;
  String regionOfOperation;
  String aboutSelf;
  String nin;
  String startingFee;
  File _dpImage;
  File _idFront;
  File _idBack;
  bool loading = false;
  var professionsData;
  List<dynamic> specialities;
  List profesions = [];
  List specialityList = [];

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //function for loading th asset file
  Future<String> _loadData() async {
    return await rootBundle.loadString("assets/professions.json");
  }

  Future getJsonData() async {
    String jsonString = await _loadData();
    var data = jsonDecode(jsonString)['professions'];
    getProfession(data);
    setState(() {
      professionsData = data;
    });
  }

  //function for getting professions
  getProfession(Map items) {
    List list = [];
    for (final key in items.keys) {
      list.add(key);
    }
    list.sort((a, b) => a.compareTo(b));
    setState(() {
      profesions = list;
    });
  }

  //function for getting specialities
  getSpecialities(value) {
    setState(() {
      specialityList = professionsData[value];
    });
  }

  @override
  void initState() {
    super.initState();
    getJsonData();
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
        appBar: AppBar(
          title: Text(
            'Setup Your WorkMan Profile',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    // ===================================================== profile dp
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: new Border.all(
                              color: Colors.blue.withOpacity(0.1),
                              width: 2.0,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                              radius: 80.0,
                              backgroundImage: _dpImage != null
                                  ? FileImage(_dpImage)
                                  : AssetImage('assets/dp.png')),
                        ),
                        Positioned(
                          bottom: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                                border: new Border.all(
                                  color: Colors.grey[200],
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
                    // ===================================================== first name
                    InputField(
                      labelText: 'First name',
                      prefixIcon: Icon(Icons.person),
                      cb: (String value) {
                        setState(() {
                          firstName = value;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'First name is empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    // ===================================================== last name
                    InputField(
                      labelText: 'Last name',
                      prefixIcon: Icon(Icons.person),
                      cb: (String value) {
                        setState(() {
                          lastName = value;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Last name is empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    // ===================================================== national identification number
                    InputField(
                      labelText: 'National Identification Card Number',
                      prefixIcon: Icon(CupertinoIcons.creditcard),
                      cb: (String value) {
                        setState(() {
                          nin = value;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'NIN is empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    // ===================================================== date of birth container
                    InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: dob == null ? DateTime.now() : dob,
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now())
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              dob = value;
                            });
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30.0),
                            border:
                                Border.all(color: Colors.blue[100], width: 1)),
                        child: Row(
                          children: [
                            IconButton(
                                icon: Icon(
                                  CupertinoIcons.calendar,
                                  color: Colors.grey,
                                ),
                                onPressed: () {}),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              dob == null
                                  ? 'Date of birth'
                                  : '${DateFormat.yMMMEd().format(dob)}',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 13.0),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    // ============================================================= profession
                    DropDownSearch(
                        popUpTitle: 'Professions',
                        items: [...profesions],
                        cb: (value) {
                          if (value != null) {
                            getSpecialities(value);
                          }
                          setState(() {
                            profession = value;
                          });
                        },
                        value: profession,
                        hint: 'Profession'),
                    SizedBox(
                      height: 40.0,
                    ),
                    DropDownSearch(
                        items: ['Degree', 'Masters'],
                        cb: (value) {
                          setState(() {
                            qualification = value;
                          });
                        },
                        value: qualification,
                        hint: 'Qualifications'),
                    SizedBox(
                      height: 40.0,
                    ),
                    // ============================================================= specialities
                    MultiDropDown(
                        items: [...specialityList],
                        cb: (value) {
                          setState(() {
                            specialities = value;
                          });
                        }),
                    SizedBox(
                      height: 40.0,
                    ),
                    // ============================================================= region of operation
                    DropDownSearch(
                        items: [
                          'Central',
                          'Eastern',
                          'Western',
                          'Northern',
                          'Southern'
                        ],
                        cb: (value) {
                          setState(() {
                            regionOfOperation = value;
                          });
                        },
                        value: regionOfOperation,
                        hint: 'Region of operation'),
                    SizedBox(
                      height: 40.0,
                    ),
                    // ============================================================= starting fee
                    InputField(
                      inputFormatters: [
                        TextInputMask(
                            mask: '999,999,999,999,999', reverse: true)
                      ],
                      labelText: 'Staring fee',
                      prefixIcon: Icon(Icons.money),
                      cb: (value) {
                        setState(() {
                          startingFee = value;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Starting fee is empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    // ============================================================= about yourself
                    TextFormField(
                      maxLines: 5,
                      maxLength: 200,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(200),
                      ],
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 15.0),
                          labelText: 'About your self',
                          prefixIcon:
                              Icon(CupertinoIcons.pen, color: Colors.blue),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                              borderSide: BorderSide(
                                color: Colors.blue[100],
                              )),
                          fillColor: Colors.blue.withOpacity(0.1),
                          filled: true),
                      onChanged: (value) {
                        setState(() {
                          aboutSelf = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    // ============================================================= front picture of id
                    _idFront == null
                        ? InkWell(
                            onTap: getIdFront,
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                            ),
                            splashColor: Colors.transparent,
                            child: DottedBorder(
                              dashPattern: [6],
                              color: Colors.blue,
                              borderType: BorderType.RRect,
                              radius: Radius.circular(10),
                              child: Container(
                                  height: 220,
                                  width: 250.0,
                                  color: Colors.blue.withOpacity(0.1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 40.0,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        'Front Picture of National ID',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13.0, color: Colors.blue),
                                      )
                                    ],
                                  )),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.file(
                              _idFront,
                              fit: BoxFit.cover,
                              height: 220,
                              width: 250.0,
                            ),
                          ),
                    SizedBox(
                      height: 40.0,
                    ),
                    // ============================================================= back picture of id
                    _idBack == null
                        ? InkWell(
                            onTap: getIdBack,
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                            ),
                            splashColor: Colors.transparent,
                            child: DottedBorder(
                              dashPattern: [6],
                              color: Colors.blue,
                              borderType: BorderType.RRect,
                              radius: Radius.circular(10),
                              child: Container(
                                  color: Colors.blue.withOpacity(0.1),
                                  height: 220,
                                  width: 250.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        color: Colors.blue,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        'Back Picture of National ID',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13.0, color: Colors.blue),
                                      )
                                    ],
                                  )),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.file(
                              _idBack,
                              fit: BoxFit.cover,
                              height: 220,
                              width: 250.0,
                            )),
                    SizedBox(
                      height: 20.0,
                    ),
                    RoundButton(
                      cb: () {
                        if (_formKey.currentState.validate()) {
                          _submit();
                        }
                      },
                      name: 'Submit',
                    )
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
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        if (pickedFile != null) {
          _dpImage = File(pickedFile.path);
        }
      });
    }
  }

  Future getIdFront() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        if (pickedFile != null) {
          _idFront = File(pickedFile.path);
        }
      });
    }
  }

  Future getIdBack() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxWidth: 600, maxHeight: 600);
    if (pickedFile != null) {
      setState(() {
        if (pickedFile != null) {
          _idBack = File(pickedFile.path);
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
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Future _submit() async {
    EasyLoading.show(
        status: 'Setting up your profile ...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
        indicator: SpinKitCircle(
          color: Colors.white,
          size: 50.0,
        ));
    Provider.of<AuthProvider>(_scaffoldKey.currentContext, listen: false)
        .setUpWorkManProfile(WorkManProfile(
            dpImage: _dpImage,
            firstName: firstName,
            lastName: lastName,
            areaOfOperation: regionOfOperation,
            dob: dob,
            specialities: specialities,
            idBack: _idBack,
            idFront: _idFront,
            nin: nin,
            profession: profession,
            qualification: qualification,
            startingFee: startingFee,
            aboutSelf: aboutSelf))
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
