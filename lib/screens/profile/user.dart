import 'dart:convert';

import 'package:workmannow/screens/auth/login.dart';
import 'package:workmannow/screens/profile/edit.dart';
import 'package:workmannow/providers/user.dart';
import 'package:workmannow/widgets/chip_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic> user;

  Future<Map<String, dynamic>> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = jsonDecode(prefs.getString('user'));
    return user;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser().then((user) {
      setState(() {
        user = user;
      });
    }).catchError((err) => print('caught error'));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      var user = userProvider.user;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'My profile',
          ),
          bottom: PreferredSize(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.grey[300], width: 0.5)),
              ),
            ),
            preferredSize: Size.zero,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
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
                              backgroundImage: user['profileImage'] != null
                                  ? NetworkImage(
                                      'http://192.168.0.108:3001/' +
                                          user['profileImage']['small'],
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
                              '${user['firstName']} ${user['lastName']}'
                                  .titleCase,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            user['role'] == 'workman'
                                ? Text(
                                    user['profession'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  )
                                : SizedBox(),
                            user['role'] == 'workman'
                                ? SizedBox(
                                    height: 5.0,
                                  )
                                : SizedBox(),
                            Text(
                              user['phoneNumber'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              user['email'],
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
                // ======================================================================= rating card
                user['role'] == 'workman'
                    ? Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${user['rating']}/5',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0),
                                  ),
                                  Text(
                                    'Rating',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 80.0,
                              ),
                              Column(
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0),
                                  ),
                                  Text(
                                    'Jobs completed',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                //============================================================================== hire and price card
                user['role'] == 'workman'
                    ? Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Staring fee',
                                    style: TextStyle(
                                        fontSize: 10.0, color: Colors.grey),
                                  ),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text: "Shs : ",
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontFamily: 'QuickSand',
                                            fontSize: 12),
                                        children: [
                                          TextSpan(
                                              text: user['startingFee'],
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0))
                                        ]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                //============================================================================== about card
                user['role'] == 'workman'
                    ? SizedBox(
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'About',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey),
                                ),
                                Text(
                                  user['aboutSelf'],
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10.0,
                ),
                //============================================================================== specialities card
                user['role'] == 'workman'
                    ? SizedBox(
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Specialities',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                ChipList(
                                  list: [...user['specialities']],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10.0,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    leading: Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: Text('Logout'),
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        // the new route
                        MaterialPageRoute(
                          builder: (BuildContext context) => Login(),
                        ),
                        (Route route) => false,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return EditUserProfile(
                user: user,
              );
            }));
          },
          child: Icon(
            CupertinoIcons.pen,
            size: 30.0,
          ),
          tooltip: 'Edit profile',
        ),
      );
    });
  }
}
