import 'package:workmannow/helpers/colors.dart';
import 'package:workmannow/providers/auth.dart';
import 'package:workmannow/providers/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:recase/recase.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  CollectionReference hirings = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        return Scaffold(
          appBar: AppBar(
            title: Text('Hirings'),
            bottom: PreferredSize(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey[300], width: 0.5)),
                ),
              ),
              preferredSize: null,
            ),
          ),
          body: SafeArea(
              child: StreamBuilder<QuerySnapshot>(
            stream: hirings
                .doc(user['_id'])
                .collection('hirings')
                // .orderBy('createdAt', descending: true)
                .where("accepted", isEqualTo: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: SpinKitFadingCircle(
                  color: MyColors.blue,
                  size: 50.0,
                ));
              }
              if (snapshot.data.docs.length == 0) {
                return Center(
                  child: Text('You have no new hirings'),
                );
              }
              return ListView.builder(
                reverse: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  final message = snapshot.data.docs[index];
                  return Card(
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      onTap: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0))),
                            context: context,
                            builder: (context) {
                              return UserContainer(
                                user: message,
                              );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${DateFormat.yMMMEd().add_jms().format(DateTime.fromMillisecondsSinceEpoch(message['createdAt']).toLocal())}',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Job decription',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        message['description'],
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlatButton.icon(
                                  height: 30.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  onPressed: () {
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .acceptHire(
                                            documentRef:
                                                message.reference.path);
                                  },
                                  icon: Icon(
                                    Icons.check,
                                    size: 15.0,
                                  ),
                                  label: Text('Accept'),
                                  color: Colors.green,
                                  textColor: Colors.white,
                                ),
                                FlatButton.icon(
                                  icon: Icon(
                                    CupertinoIcons.clear,
                                    size: 15.0,
                                  ),
                                  height: 30.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  onPressed: () {
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .declineHire(
                                            documentRef:
                                                message.reference.path);
                                  },
                                  label: Text('Decline'),
                                  color: Colors.red,
                                  textColor: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          )),
        );
      },
    );
  }
}

class UserContainer extends StatelessWidget {
  final user;

  UserContainer({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: Colors.blue.withOpacity(0.1), width: 2.0)),
          child: CircleAvatar(
              radius: 65.0,
              backgroundImage: NetworkImage(
                user['clienImage'],
              )),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0.0),
          title: Text(
            user['clientName'],
            style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontSize: 12.0),
          ),
          subtitle: Text(
            'Client\'s name',
            style: TextStyle(
                fontSize: 10.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0.0),
          title: Text(
            user['contact'],
            style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontSize: 12.0),
          ),
          subtitle: Text(
            'Client\'s contact',
            style: TextStyle(
                fontSize: 10.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
          trailing: CircleAvatar(
            child: IconButton(
              onPressed: () {
                launch("tel:${user['contact']}");
              },
              splashRadius: 1.0,
              icon: Icon(Icons.phone),
            ),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0.0),
          title: Text(
            user['location'],
            style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontSize: 12.0),
          ),
          subtitle: Text(
            'Client\'s location',
            style: TextStyle(
                fontSize: 10.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
          trailing: CircleAvatar(
            backgroundColor: Colors.red,
            child: IconButton(
              onPressed: () {},
              splashRadius: 1.0,
              icon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ]),
    ));
  }
}
