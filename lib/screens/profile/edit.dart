import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:workmannow/classes/user/index.dart';
import 'package:workmannow/helpers/colors.dart';
import 'package:workmannow/providers/user.dart';
import 'package:workmannow/widgets/input_fields/input_field.dart';
import 'package:workmannow/widgets/input_fields/dropdown_search.dart';
import 'package:workmannow/widgets/input_fields/multi_dropdown_search.dart';
import 'package:workmannow/widgets/buttons/rounded_button.dart';
import 'package:workmannow/widgets/input_fields/about_self_input_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

class EditUserProfile extends StatefulWidget {
  final user;

  EditUserProfile({this.user});

  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _ninController = TextEditingController();
  var _startingFeeController = TextEditingController();
  var _aboutSelfController = TextEditingController();

  final picker = ImagePicker();
  bool isWorkMan;
  String profession;
  String nin;
  String qualification;
  String startingFee;
  String aboutSelf;
  File profileImage;
  File idBackImage;
  File idFrontImage;
  DateTime dob;
  Map<String, dynamic> user;

  String regionOfOperation;
  var professionsData;
  List<dynamic> specialities = [];
  List<String> professions = [];
  List<dynamic> specialityList = [];

  //function for loading th asset file
  Future<String> _loadData() async {
    return await rootBundle.loadString("assets/professions.json");
  }

  Future<void> getJsonData() async {
    String jsonString = await _loadData();
    Map<String, dynamic> professions = jsonDecode(jsonString)['professions'];
    // getProfessionsList(professions);
    setState(() {
      professionsData = professions;
    });
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
    setState(() {
      user = widget.user;
      isWorkMan = widget.user['role'] == 'workman';
    });
    if (isWorkMan) {
      _ninController.text = user['nin'];
      _startingFeeController.text = user['startingFee'];
      _aboutSelfController.text = user['aboutSelf'];
      setState(() {
        profession = user['profession'];
        nin = user['nin'];
        qualification = user['qualification'];
        startingFee = user['startingFee'];
        aboutSelf = user['aboutSelf'];
        regionOfOperation = user['regionOfOperation'];
        specialities = user['specialities'];
        dob = DateTime.parse(user['dob']);
      });
      getJsonData().then((v) {
        getSpecialitiesList(profession);
      });
    } else if (!isWorkMan) {
      getProfessionsList().then((List<String> list) {
        setState(() {
          professions = list;
        });
      }).catchError((e) => print(e));
    }
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
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: MyColors.blue),
          title: Text(
            'Edit profile',
            style: TextStyle(color: MyColors.blue),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    // ===================================================== profile profileImage
                    user['profileImage'] != null
                        ? Stack(
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
                                    backgroundImage: NetworkImage(
                                        'http://192.168.43.77:3001/' +
                                            user['profileImage']['medium'])),
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
                          )
                        : Stack(
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
                                    backgroundImage: profileImage == null
                                        ? AssetImage('assets/dp.png')
                                        : FileImage(profileImage)),
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
                      height: 10.0,
                    ),
                    // ===================================================== workman status
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('WorkMan'),
                            subtitle:
                                Text('status (${isWorkMan ? 'On' : 'Off'})'),
                            trailing: Switch(
                              value: isWorkMan,
                              onChanged: (bool value) {
                                setState(() {
                                  isWorkMan = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    // ============================================================= profession
                    isWorkMan
                        ? DropDownSearch(
                            items: professions,
                            onChanged: (value) async {
                              if (value != null) {
                                await getSpecialitiesList(value);
                              }
                              setState(() {
                                profession = value;
                              });
                            },
                            value: profession,
                            hint: 'Profession')
                        : SizedBox(),
                    isWorkMan
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    isWorkMan
                        ? DropDownSearch(
                            items: ['Degree', 'Masters'],
                            onChanged: (value) {
                              setState(() {
                                qualification = value;
                              });
                            },
                            value: qualification,
                            hint: 'Qualifications')
                        : SizedBox(),
                    isWorkMan
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    // ============================================================= region of operation
                    isWorkMan
                        ? DropDownSearch(
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
                            hint: 'Region of operation')
                        : SizedBox(),
                    isWorkMan
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    // ============================================================= specialities
                    isWorkMan
                        ? MultiDropDown(
                            initialValue: specialities,
                            items: specialityList,
                            cb: (List<dynamic> value) {
                              setState(() {
                                specialities = value;
                              });
                            })
                        : SizedBox(),
                    isWorkMan
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    // ============================================================= national identity card number
                    isWorkMan
                        ? InputField(
                            controller: _ninController,
                            labelText: 'National Identification Card Number',
                            onChanged: (String value) {
                              setState(() {
                                nin = value;
                              });
                            },
                            validator: isWorkMan
                                ? (value) {
                                    if (value.isEmpty) {
                                      return 'NIN is empty';
                                    }
                                    return null;
                                  }
                                : null,
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 40.0,
                    ),
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
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30.0),
                            border:
                                Border.all(color: Colors.blue[100], width: 1)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10.0,
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
                    isWorkMan
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    isWorkMan
                        ? InputField(
                            controller: _startingFeeController,
                            inputFormatters: [
                              TextInputMask(
                                  mask: '999,999,999,999,999', reverse: true)
                            ],
                            labelText: 'Staring fee',
                            onChanged: (value) {
                              setState(() {
                                startingFee = value;
                              });
                            },
                            validator: isWorkMan
                                ? (value) {
                                    if (value.isEmpty) {
                                      return 'Starting fee is empty';
                                    }
                                    return null;
                                  }
                                : null,
                          )
                        : SizedBox(),
                    isWorkMan
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    // ============================================================== about yourself
                    isWorkMan
                        ? AboutSelfInputField(
                            controller: _aboutSelfController,
                            onChanged: (value) {
                              setState(() {
                                aboutSelf = value;
                              });
                            },
                          )
                        : SizedBox(),
                    user['role'] == 'client'
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    // ============================================================= front picture of id
                    user['role'] == 'client'
                        ? isWorkMan
                            ? idFrontImage == null
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                    fontSize: 13.0,
                                                    color: Colors.blue),
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
                                  )
                            : SizedBox()
                        : SizedBox(),
                    user['role'] == 'client'
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    // ============================================================= back picture of id
                    user['role'] == 'client'
                        ? isWorkMan
                            ? idBackImage == null
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                    fontSize: 13.0,
                                                    color: Colors.blue),
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
                                    ))
                            : SizedBox()
                        : SizedBox(),
                    isWorkMan
                        ? SizedBox(
                            height: 20.0,
                          )
                        : SizedBox(),
                    RoundedButton(
                      onPressed: () {
                        if (user['role'] != 'workman' && isWorkMan == true) {
                          if (idFrontImage != null && idFrontImage != null) {
                            _submit();
                          } else {
                            _showSnackBar('Missing ID images');
                          }
                        } else if (user['role'] == 'workman') {
                          _submit();
                        }
                      },
                      name: 'Save Changes',
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

// =============================================================== getting dp image
  Future getProfileImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        if (pickedImage != null) {
          profileImage = File(pickedImage.path);
        }
      });
    }
  }

// =============================================================== getting front id image
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

// =============================================================== getting back id image
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

// =============================================================== submitting changes
  Future _submit() async {
    EasyLoading.show(
        status: 'Updating your profile ...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
        indicator: SpinKitCircle(
          color: Colors.white,
          size: 50.0,
        ));
    Provider.of<UserProvider>(context, listen: false)
        .updateUserProfile(User(
            nin: nin == null || nin.isEmpty ? null : nin,
            profileImage: profileImage,
            idBackImage: idBackImage,
            idFrontImage: idFrontImage,
            dob: dob == null ? null : dob,
            regionOfOperation:
                regionOfOperation == null || regionOfOperation.isEmpty
                    ? null
                    : regionOfOperation,
            specialities: specialities == null || specialities.isEmpty
                ? null
                : specialities,
            profession:
                profession == null || profession.isEmpty ? null : profession,
            qualification: qualification == null || qualification.isEmpty
                ? null
                : qualification,
            aboutSelf:
                aboutSelf == null || aboutSelf.isEmpty ? null : aboutSelf,
            startingFee:
                startingFee == null || startingFee.isEmpty ? null : startingFee,
            role: isWorkMan ? 'workman' : 'client'))
        .then((String message) async {
      if (message == 'success') {
        if (mounted) {
          await EasyLoading.dismiss();
          Navigator.pop(context);
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

// =============================================================== function for calling snackbar
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
