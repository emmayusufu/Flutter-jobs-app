import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LocationNotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/locationOff.json',
                fit: BoxFit.cover,
              ),
              Text(
                'Turn On Location',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.blueGrey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
