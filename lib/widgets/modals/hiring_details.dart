import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HiringDetailsModal extends StatefulWidget {
  final hiring;

  HiringDetailsModal({this.hiring});

  @override
  _HiringDetailsModalState createState() => _HiringDetailsModalState();
}

class _HiringDetailsModalState extends State<HiringDetailsModal> {
  var hiring;

  @override
  void initState() {
    super.initState();
    hiring = widget.hiring;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: Colors.blue.withOpacity(0.1), width: 2.0)),
          child: CircleAvatar(
              radius: 65.0,
              backgroundImage: NetworkImage(
                'http://192.168.43.77:3001/' + hiring['clientImage']['small'],
              )),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0.0),
          title: Text(
            hiring['clientName'],
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
            hiring['phoneNumber'],
            style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontSize: 12.0),
          ),
          subtitle: Text(
            'Client\'s phoneNumber',
            style: TextStyle(
                fontSize: 10.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
          trailing: CircleAvatar(
            child: IconButton(
              onPressed: () {
                launch("tel:${hiring['phoneNumber']}");
              },
              splashRadius: 1.0,
              icon: Icon(Icons.phone),
            ),
          ),
        ),
        // ListTile(
        //   contentPadding: EdgeInsets.symmetric(vertical: 0.0),
        //   title: Text(
        //     user['location'],
        //     style: TextStyle(
        //         color: Colors.blueGrey,
        //         fontWeight: FontWeight.bold,
        //         fontSize: 12.0),
        //   ),
        //   subtitle: Text(
        //     'Client\'s location',
        //     style: TextStyle(
        //         fontSize: 10.0,
        //         color: Colors.grey,
        //         fontWeight: FontWeight.bold),
        //   ),
        //   trailing: CircleAvatar(
        //     backgroundColor: Colors.red,
        //     child: IconButton(
        //       onPressed: () {},
        //       splashRadius: 1.0,
        //       icon: Icon(
        //         Icons.location_on,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
      ]),
    );
  }
}
