// import 'package:WorkManNow/pages/profile/workman_profile.dart';
import 'package:workmannow/widgets/rating.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen()));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            children: [
              CircleAvatar(
                child: Icon(
                  CupertinoIcons.person_solid,
                  size: 50.0,
                ),
                radius: 40.0,
              ),
              Text(
                'Kimaswa Emma',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Senior software engineer',
                style: TextStyle(),
              ),
              Text(
                '8 years experience',
                style: TextStyle(),
              ),
              Row(
                children: [Rating(count: 5)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
