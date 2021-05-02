import 'dart:convert';
import 'package:workmannow/screens/home/widgets/notification_button.dart';
import 'package:workmannow/screens/home/widgets/pending_button.dart';
import 'package:workmannow/screens/home/widgets/search_container.dart';
import 'package:workmannow/providers/user.dart';
import 'package:workmannow/providers/firebase.dart';
import 'package:workmannow/widgets/workman_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final fbm = FirebaseMessaging.instance;

  Future<String> getCurrentUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = jsonDecode(prefs.getString('user'));
    return userData['_id'];
  }

  Future<void> saveTokenToDatabase(String token) async {
    String userId = await getCurrentUserID();
    await FirebaseFirestore.instance.collection('userTokens').doc(userId).set({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }

  @override
  void initState() {
    super.initState();
    fbm.getToken().then((token) async {
      await saveTokenToDatabase(token);
    });
    fbm.onTokenRefresh.listen(saveTokenToDatabase);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    // =====================================storing user locations
    Provider.of<FireBaseServiceProvider>(context, listen: false)
        .storeLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (context, userProvider, child) {
      var user = userProvider.user;
      return Scaffold(
        appBar: AppBar(
          // toolbarHeight: 120.0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/user_profile');
            },
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: CircleAvatar(
                  radius: 70.0,
                  backgroundImage : user['profileImage'] !=null ? NetworkImage('http://192.168.0.108:3001/'+user['profileImage']['thumbnail']) : AssetImage('assets/dp.png')),
            ),
          ),
          title: Text('Home'),
          centerTitle: true,
          actions: [
            PendingButton(),
            user['role'] == "workman" ? NotificationButton() : SizedBox(),
          ],
          bottom: PreferredSize(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: SearchContainer()),
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(50.0)),
        ),
        body: FutureBuilder(
            future: userProvider.fetchAllWorkMen(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              Widget component;
              if (snapshot.connectionState == ConnectionState.waiting) {
                component = SingleChildScrollView(
                  child: SkeletonLoader(
                    builder: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 35,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: 10,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  height: 12,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    items: 10,
                    period: Duration(seconds: 2),
                    highlightColor: Colors.blueGrey,
                    direction: SkeletonDirection.ltr,
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List workmanList = snapshot.data;
                  if (workmanList.isEmpty) {
                    component = Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sentiment_very_dissatisfied,
                            size: 50.0,
                            color: Colors.grey,
                          ),
                          Text('No workmen are currently available'),
                        ],
                      ),
                    );
                  } else if (workmanList.isNotEmpty) {
                    // ============================================= workmen list
                    component = ListView.builder(
                        itemCount: workmanList.length,
                        itemBuilder: (context, index) {
                          var workman = workmanList[index];
                          return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: WorkManTile(
                                workMan: workman,
                                name:
                                    '${workman['firstName']} ${workman['lastName']}',
                                image: workman['profileImage']['small'],
                                about: workman['aboutSelf'],
                                rating: workman['rating'],
                                startFee: workman['startingFee'],
                                profession: workman['profession'],
                              ));
                        });
                  }
                } else if (snapshot.hasError) {
                  component = Center(
                    child: Text('An error occurred while fetching data'),
                  );
                } else if (!snapshot.hasData) {
                  component = Center(
                    child: Text('No data was returned'),
                  );
                }
              }
              return component;
            }),
      );
    });
  }
}
