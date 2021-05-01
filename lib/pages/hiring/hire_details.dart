import 'dart:convert';

import 'package:workmannow/classes/hire/index.dart';
import 'package:workmannow/helpers/colors.dart';
import 'package:workmannow/pages/hiring/waiting.dart';
import 'package:workmannow/pages/map/address_search.dart';
import 'package:workmannow/providers/auth.dart';
import 'package:workmannow/providers/location.dart';
import 'package:workmannow/providers/user.dart';
import 'package:workmannow/widgets/rounded_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recase/recase.dart';

// class GeoCodes {
//   final String lat;
//   final String long;

//   GeoCodes({@required this.lat, @required this.long});
// }

class HireDetails extends StatefulWidget {
  final workman;
  HireDetails({@required this.workman});
  @override
  _HireDetailsState createState() => _HireDetailsState();
}

class _HireDetailsState extends State<HireDetails> {
  String contact = '';
  bool isContactValid;
  String jobDescription;
  String location;
  Map<String, dynamic> geoCodes;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    Provider.of<LocationProvider>(context, listen: false)
        .getPlaceAddress(locData.latitude, locData.longitude)
        .then((value) {
      setState(() {
        location = value;
        geoCodes = {
          "longitude": locData.longitude,
          "latitude": locData.latitude
        };
      });
    }).catchError((e) {
      print('caught error $e while geocoding');
    });
  }

  Future<Map> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map userData = jsonDecode(prefs.getString('user'));
    return userData;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUserLocation();
    getUser().then((user) {
      setState(() {
        contact = user['phoneNumber'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final workman = widget.workman;
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      Map user = authProvider.user;
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SingleChildScrollView(
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                                backgroundImage: workman['dpImage'] != null
                                    ? NetworkImage(
                                        workman['dpImage'],
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
                                '${workman['lastName']} ${workman['firstName']}'
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                            title: Text(contact),
                            trailing: IconButton(
                                icon: Icon(
                                  CupertinoIcons.pen,
                                  size: 25.0,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(25.0))),
                                      isScrollControlled: true,
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
                                                InternationalPhoneNumberInput(
                                                  inputDecoration:
                                                      InputDecoration(
                                                    hintText: 'Phone number',
                                                    hintStyle: TextStyle(
                                                      fontSize: 13.5,
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 0.0,
                                                            horizontal: 10.0),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    30.0)),
                                                  ),
                                                  onInputChanged:
                                                      (PhoneNumber number) {
                                                    setState(() {
                                                      contact =
                                                          number.phoneNumber;
                                                    });
                                                  },
                                                  onInputValidated:
                                                      (bool value) {
                                                    setState(() {
                                                      isContactValid = value;
                                                    });
                                                  },
                                                  selectorConfig:
                                                      SelectorConfig(
                                                    selectorType:
                                                        PhoneInputSelectorType
                                                            .DIALOG,
                                                    // backgroundColor:
                                                    //     Colors.white,
                                                  ),
                                                  ignoreBlank: false,
                                                  selectorTextStyle: TextStyle(
                                                      color: Colors.black),
                                                  initialValue: PhoneNumber(
                                                      isoCode: 'UG'),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter your phone number';
                                                    } else if (value
                                                        .isNotEmpty) {
                                                      if (!isContactValid) {
                                                        return 'An invalid contact was entered';
                                                      }
                                                    }
                                                    return null;
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
                          Divider(),
                          // ============================================================================== client location
                          ListTile(
                              subtitle: Text('Your location'),
                              leading:
                                  CircleAvatar(child: Icon(Icons.location_on)),
                              title: location == null
                                  ? SpinKitWave(
                                      color: Colors.grey,
                                      size: 20.0,
                                    )
                                  : Text(location),
                              trailing: IconButton(
                                  icon: Icon(
                                    CupertinoIcons.pen,
                                    size: 25.0,
                                  ),
                                  onPressed: location == null
                                      ? null
                                      : () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  fullscreenDialog: true,
                                                  builder: (_) {
                                                    return AddressSearch();
                                                  }))
                                              .then((result) {
                                            if (result == null) {
                                              return;
                                            }
                                            setState(() {
                                              location = result.userLocation;
                                              geoCodes = {
                                                "longitude": result
                                                    .coordinates.longitude,
                                                "latitude":
                                                    result.coordinates.latitude
                                              };
                                            });
                                          }).catchError((e) =>
                                                  print('caught error $e'));
                                        })),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                        labelText: 'A brief description of the job offer',
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
                    cb: location == null || location.isEmpty
                        ? null
                        : () {
                            final FocusScopeNode currentScope =
                                FocusScope.of(context);
                            if (!currentScope.hasPrimaryFocus &&
                                currentScope.hasFocus) {
                              FocusManager.instance.primaryFocus.unfocus();
                            }
                            if (_formKey.currentState.validate()) {
                              _submit(
                                  clientID: user['_id'],
                                  clientImage: user['dpImage'],
                                  workManID: workman['_id'],
                                  clientName:
                                      '${user['firstName']} ${user['lastName']}');
                            }
                          },
                    name: 'Confirm to proceed',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _submit({clientID, workManID, clientName, clientImage}) async {
    EasyLoading.show(
        status: 'Submitting hire request',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
        indicator: SpinKitCircle(
          color: Colors.white,
          size: 50.0,
        ));

    Provider.of<UserProvider>(context, listen: false)
        .hireWorkMan(HireModal(
            jobDescription: jobDescription,
            clientImage: clientImage,
            clientId: clientID,
            workManId: workManID,
            contact: contact,
            location: location,
            clientName: clientName,
            geocodes: geoCodes))
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
    }).catchError((err) {
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
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
