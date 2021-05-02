import 'dart:convert';
import 'dart:io';
import 'package:workmannow/classes/user/index.dart';
import 'package:workmannow/helpers/colors.dart';
import 'package:workmannow/providers/user.dart';
import 'package:workmannow/widgets/input_field.dart';
import 'package:workmannow/widgets/dropdown_search.dart';
import 'package:workmannow/widgets/multi_dropdown_search.dart';
import 'package:workmannow/widgets/rounded_button.dart';
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
import 'package:recase/recase.dart';

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
  File profileImage;
  File idFrontImage;
  File idBackImage;
  bool loading = false;
  var professionsData;
  List<dynamic> specialities;
  List<String> professions = [];
  List specialityList = [];

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //function for loading th asset file
  Future<String> _loadData() async {
    return await rootBundle.loadString("assets/professions.json");
  }

  Future<List<String>> getProfessionsList() async {
    String jsonString = await _loadData();
    Map<String, dynamic> professionsMap = jsonDecode(jsonString)['professions'];
    List<String> list = [];
    for (final key in professionsMap.keys) {
      list.add(key.sentenceCase);
    }
    list.sort((a, b) => a.compareTo(b));
    return list;
  }

  Future<void> getSpecialitiesList(String value) async {
    String jsonString = await _loadData();
    Map<String, dynamic> professionsMap = jsonDecode(jsonString)['professions'];
    setState(() {
      specialityList = professionsMap[value.toLowerCase()];
    });
  }

  @override
  void initState() {
    super.initState();
    getProfessionsList().then((List<String> list) {
      setState(() {
        professions = list;
      });
    }).catchError((e) => print(e));
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
                              backgroundImage: idBackImage != null
                                  ? FileImage(idBackImage)
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
                              onPressed: getProfileImage,
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
                      onChanged: (String value) {
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
                      onChanged: (String value) {
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
                      onChanged: (String value) {
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
                             Icon(
                                  CupertinoIcons.calendar,
                                  color: Colors.grey,
                                ),
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
                        items: professions,
                        onChanged: (value) async{
                          if (value != null) {
                            await getSpecialitiesList(value);
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
                        onChanged: (value) {
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
                        onChanged: (value) {
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
                      onChanged: (value) {
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
                    idFrontImage == null
                        ? InkWell(
                            onTap: getIdFrontImage,
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
                              idFrontImage,
                              fit: BoxFit.cover,
                              height: 220,
                              width: 250.0,
                            ),
                          ),
                    SizedBox(
                      height: 40.0,
                    ),
                    // ============================================================= back picture of id
                    idBackImage == null
                        ? InkWell(
                            onTap: getIdBackImage,
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
                              idBackImage,
                              fit: BoxFit.cover,
                              height: 220,
                              width: 250.0,
                            )),
                    SizedBox(
                      height: 20.0,
                    ),
                    RoundedButton(
                      onPressed: () {
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

  Future getProfileImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        if (pickedImage != null) {
          idBackImage = File(pickedImage.path);
        }
      });
    }
  }

  Future getIdFrontImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        if (pickedImage != null) {
          idFrontImage = File(pickedImage.path);
        }
      });
    }
  }

  Future getIdBackImage() async {
    final pickedImage = await picker.getImage(
        source: ImageSource.camera, maxWidth: 600, maxHeight: 600);
    if (pickedImage != null) {
      setState(() {
        if (pickedImage != null) {
          idBackImage = File(pickedImage.path);
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
        status: 'Setting up your profile ...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
        indicator: SpinKitCircle(
          color: Colors.white,
          size: 50.0,
        ));
    Provider.of<UserProvider>(_scaffoldKey.currentContext, listen: false)
        .setUpWorkManProfile(User(
            profileImage: profileImage,
            firstName: firstName,
            lastName: lastName,
            regionOfOperation: regionOfOperation,
            dob: dob,
            specialities: specialities,
            idBackImage: idBackImage,
            idFrontImage: idFrontImage,
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
