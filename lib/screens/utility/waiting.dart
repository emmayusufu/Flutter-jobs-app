import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:workmannow/providers/hiring.dart';

class Waiting extends StatefulWidget {
  @override
  _WaitingState createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String _message = message.data['message'];

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
                title: Text(
                  _message == "timeOut"
                      ? 'WorkMan was not able to respond in time please try another, continue to view other similar workmen'
                      : "Workman accepted your hire request",
                  style: TextStyle(fontSize: 14.0),
                ),
                actions: _message == "timeOut"
                    ? <Widget>[
                        TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/home');
                            }),
                        TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/home');
                            }),
                      ]
                    : <Widget>[
                        TextButton(
                            child: Text('Continue'),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/home');
                            }),
                      ]));
      });
    });
  }

  Future<void> _cancelOrder() async {
    Provider.of<HiringProvider>(context,listen: false).cancelHiring();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.delayed(Duration.zero, () {
          return showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                      title: Text(
                        'Are you sure you want to cancel hire request',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      actions: <Widget>[
                        TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            }),
                        TextButton(
                            child: Text('Yes'),
                            onPressed: () async {
                              await _cancelOrder();
                              Navigator.of(context).pop(true);
                            }),
                      ]));
        });
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Lottie.asset(
                  'assets/approve.json',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please wait for Workman to respond to request',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'The hire will automatically be cancelled in the next 5 minutes if workman does not respond',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      textStyle: TextStyle(color: Colors.red),
                      minimumSize: Size(200.0, 45.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.red)),
                    ),
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (_) => HireFinished()));
                    },
                    label: Text('Cancel Hire'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
