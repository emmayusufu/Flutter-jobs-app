import 'package:workmannow/providers/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingButton extends StatefulWidget {
  @override
  _PendingButtonState createState() => _PendingButtonState();
}

class _PendingButtonState extends State<PendingButton> {
  CollectionReference hirings = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, authProvider, child) {
        final Map user = authProvider.user;
        return StreamBuilder<QuerySnapshot>(
            stream: hirings
                .doc(user['_id'])
                .collection('hirings')
                .where("accepted", isEqualTo: true)
                // .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('error');
                return NewWidget(
                  count: 0,
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return NewWidget(
                  count: 0,
                );
              }
              return NewWidget(
                count: snapshot.data.docs.length,
              );
            });
      },
    );
  }
}

class NewWidget extends StatelessWidget {
  final int count;
  const NewWidget({Key key, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
            splashRadius: 1.0,
            icon: Icon(CupertinoIcons.clock_fill),
            onPressed: () {
              Navigator.pushNamed(context, '/pending_hirings');
            }),
        new Positioned(
          right: 12,
          top: 10,
          child: new Container(
              padding: EdgeInsets.all(1),
              decoration: new BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              )),
        ),
      ],
    );
  }
}
