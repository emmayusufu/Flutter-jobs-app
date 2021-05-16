import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workmannow/helpers/colors.dart';
import 'package:workmannow/providers/user.dart';
import 'package:workmannow/screens/hiring/hiring_finished.dart';
import 'package:workmannow/widgets/modals/hiring_details.dart';

class ClientHirings extends StatefulWidget {
  @override
  _ClientHiringsState createState() => _ClientHiringsState();
}

class _ClientHiringsState extends State<ClientHirings> {
  CollectionReference hirings =
  FirebaseFirestore.instance.collection('hirings');

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, authProvider, child) {
        Map<String, dynamic> user = authProvider.user;
        return Scaffold(
          appBar: AppBar(
            title:Text('Client Hirings')
          ),
          body: SafeArea(
              child: StreamBuilder<QuerySnapshot>(
                stream: hirings
                    .where("clientId", isEqualTo: user['_id'])
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder:
                    (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
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
                      child: Text('You have no ongoing hirings'),
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
                                  return HiringDetailsModal(
                                    hiring: message,
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
                                      '${DateFormat.yMMMEd().add_jms().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              message['createdAt'])
                                              .toLocal())}',
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
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Job description',
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      style: TextButton.styleFrom(
                                        elevation: 2.0,
                                        minimumSize: Size(80.0, 30.0),
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0)),
                                        backgroundColor: Colors.green,
                                      ),
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                              return HiringFinished(
                                                docRef: message.reference.path,
                                              );
                                            }));
                                      },
                                      icon: Icon(
                                        Icons.check,
                                        size: 15.0,
                                      ),
                                      label: Text('Completed'),
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
