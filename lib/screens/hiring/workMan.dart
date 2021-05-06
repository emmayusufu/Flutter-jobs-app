import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workmannow/helpers/colors.dart';
import 'package:workmannow/providers/hiring.dart';
import 'package:workmannow/providers/user.dart';
import 'package:workmannow/widgets/modals/hiring_details.dart';

class WorkManHirings extends StatefulWidget {
  @override
  _WorkManHiringsState createState() => _WorkManHiringsState();
}

class _WorkManHiringsState extends State<WorkManHirings> {
  CollectionReference hirings =
      FirebaseFirestore.instance.collection('hirings');

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        Map<String, dynamic> user = userProvider.user;
        return Scaffold(
          body: SafeArea(
              child: StreamBuilder(
                stream: hirings
                    .orderBy('createdAt', descending: true)
                    .where("workManId", isEqualTo: user['_id'])
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: SpinKitPouringHourglass(
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
                      var hiring = snapshot.data.docs[index];
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
                                    hiring: snapshot.data.docs[index],
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
                                      '${DateFormat.yMMMEd().add_jms().format(DateTime.fromMillisecondsSinceEpoch(hiring['createdAt']).toLocal())}',
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
                                            'Job description',
                                            style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            hiring['description'],
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
                                    TextButton.icon(
                                      style: TextButton.styleFrom(
                                        elevation: 2.0,
                                        minimumSize: Size(60.0, 30.0),
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0)),
                                        backgroundColor: Colors.green,
                                      ),
                                      onPressed: () {
                                        Provider.of<HiringProvider>(context,
                                            listen: false)
                                            .acceptHire(
                                            documentRef: hiring.reference.path);
                                      },
                                      icon: Icon(
                                        Icons.check,
                                        size: 15.0,
                                      ),
                                      label: Text('Accept'),
                                    ),
                                    TextButton.icon(
                                      icon: Icon(
                                        CupertinoIcons.clear,
                                        size: 15.0,
                                      ),
                                      style: TextButton.styleFrom(
                                        elevation: 2.0,
                                        primary: Colors.white,
                                        minimumSize: Size(60.0, 30.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0)),
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () {
                                        Provider.of<HiringProvider>(context,
                                            listen: false)
                                            .declineHire(
                                            documentRef: hiring.reference.path);
                                      },
                                      label: Text('Decline'),
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
