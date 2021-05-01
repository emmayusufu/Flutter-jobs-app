import 'dart:convert';
import 'dart:io';
import 'package:workmannow/classes/auth/update_account.dart';
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
import 'package:provider/provider.dart';

class EditUserProfile extends StatefulWidget {
  final user;

  EditUserProfile({this.user});

  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  // ################################################################################################ state keys
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // ################################################################################################ controllers
  var _ninController = TextEditingController();
  var _startingFeeController = TextEditingController();
  var _aboutSelfController = TextEditingController();

  final picker = ImagePicker();
  bool workMan;
  String profession;
  String nin;
  String qualification;
  String startingFee;
  String aboutSelf;
  File _dpImage;
  File _idBack;
  File _idFront;
  Map user;

  String regionOfOperation;
  var professionsData;
  List<dynamic> specialities = [];
  List profesions = [];
  List specialityList = [];

  //function for loading th asset file
  Future<String> _loadData() async {
    return await rootBundle.loadString("assets/professions.json");
  }

  Future<void> getJsonData() async {
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
  getSpecialities(String value) {
    setState(() {
      specialityList = professionsData[value.toLowerCase()];
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      user = widget.user;
      workMan = widget.user['workman'];
    });
    if (widget.user['workman']) {
      _ninController.text = widget.user['nin'];
      _startingFeeController.text = widget.user['startingFee'];
      _aboutSelfController.text = widget.user['aboutSelf'];
      setState(() {
        profession = widget.user['profession'];
        nin = widget.user['nin'];
        qualification = widget.user['qualification'];
        startingFee = widget.user['startingFee'];
        aboutSelf = widget.user['aboutSelf'];
        regionOfOperation = widget.user['areaOfOperation'];
        specialities = widget.user['specialities'];
      });
      getJsonData().then((v) {
        getSpecialities(profession);
      });
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
                    // ===================================================== profile dp
                    user['dpImage'] != null
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
                                    backgroundImage:
                                        NetworkImage(user['dpImage'])),
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
                                    backgroundImage: _dpImage == null
                                        ? AssetImage('assets/dp.png')
                                        : FileImage(_dpImage)),
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
                      height: 10.0,
                    ),
                    // ===================================================== workman status
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('WorkMan'),
                            subtitle:
                                Text('status (${workMan ? 'On' : 'Off'})'),
                            trailing: Switch(
                              value: workMan,
                              onChanged: (bool value) {
                                setState(() {
                                  workMan = value;
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
                    workMan
                        ? DropDownSearch(
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
                            hint: 'Profession')
                        : SizedBox(),
                    workMan
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    workMan
                        ? DropDownSearch(
                            items: ['Degree', 'Masters'],
                            cb: (value) {
                              setState(() {
                                qualification = value;
                              });
                            },
                            value: qualification,
                            hint: 'Qualifications')
                        : SizedBox(),
                    workMan
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    // ============================================================= region of operation
                    workMan
                        ? DropDownSearch(
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
                            hint: 'Region of operation')
                        : SizedBox(),
                    workMan
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    // ============================================================= specialities
                    workMan
                        ? MultiDropDown(
                            initialValue: [...specialities],
                            items: [...specialityList],
                            cb: (value) {
                              setState(() {
                                specialities = value;
                              });
                            })
                        : SizedBox(),
                    workMan
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    // ============================================================= national identity card number
                    workMan
                        ? InputField(
                            controller: _ninController,
                            labelText: 'National Identification Card Number',
                            cb: (String value) {
                              setState(() {
                                nin = value;
                              });
                            },
                            validator: workMan
                                ? (value) {
                                    if (value.isEmpty) {
                                      return 'NIN is empty';
                                    }
                                    return null;
                                  }
                                : null,
                          )
                        : SizedBox(),
                    workMan
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    workMan
                        ? InputField(
                            controller: _startingFeeController,
                            inputFormatters: [
                              TextInputMask(
                                  mask: '999,999,999,999,999', reverse: true)
                            ],
                            labelText: 'Staring fee',
                            cb: (value) {
                              setState(() {
                                startingFee = value;
                              });
                            },
                            validator: workMan
                                ? (value) {
                                    if (value.isEmpty) {
                                      return 'Starting fee is empty';
                                    }
                                    return null;
                                  }
                                : null,
                          )
                        : SizedBox(),
                    workMan
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    // ============================================================== about yourself
                    workMan
                        ? TextFormField(
                            controller: _aboutSelfController,
                            maxLines: 5,
                            maxLength: 200,
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(200),
                            ],
                            style:
                                TextStyle(color: Colors.blue, fontSize: 13.0),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              hintText: 'About your self',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    20.0,
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.blue[100],
                                  )),
                            ),
                            onChanged: (value) {
                              setState(() {
                                aboutSelf = value;
                              });
                            },
                            validator: workMan
                                ? (String value) {
                                    if (value.isEmpty) {
                                      return 'About yourself field is empty';
                                    }
                                    return null;
                                  }
                                : null,
                          )
                        : SizedBox(),
                    user['client']
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    // ============================================================= front picture of id
                    user['client']
                        ? workMan
                            ? _idFront == null
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
                                      _idFront,
                                      fit: BoxFit.cover,
                                      height: 220,
                                      width: 250.0,
                                    ),
                                  )
                            : SizedBox()
                        : SizedBox(),
                    user['client']
                        ? SizedBox(
                            height: 40.0,
                          )
                        : SizedBox(),
                    // ============================================================= back picture of id
                    user['client']
                        ? workMan
                            ? _idBack == null
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
                                      _idBack,
                                      fit: BoxFit.cover,
                                      height: 220,
                                      width: 250.0,
                                    ))
                            : SizedBox()
                        : SizedBox(),
                    SizedBox(
                      height: 20.0,
                    ),
                    RoundedButton(
                      cb: () {
                        if (workMan == true) {
                        } else if (workMan == false) {}
                        _submit();
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

// =============================================================== getting front id image
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

// =============================================================== getting back id image
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
        .updateWorkManProfile(UpdateWorkManProfile(
            nin: nin == null || nin.isEmpty ? null : null,
            dpImage: _dpImage,
            idBack: _idBack,
            idFront: _idFront,
            areaOfOperation:
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
            workMan: workMan,
            client: workMan ? false : true))
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
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
