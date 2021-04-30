import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireBaseServiceProvider extends ChangeNotifier {
  final dbRef = FirebaseDatabase.instance.reference();
  final locationService = new Location();

  Future<String> getCurrentUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = jsonDecode(prefs.getString('user'));
    return userData['_id'];
  }

  // ============================================================= store user locations in the firebase rtd
  Future<void> storeLocations() async {
    String userId = await getCurrentUserID();
    locationService.onLocationChanged.listen((LocationData currentLocation) {
      dbRef.child(userId).set({
        'longitude': currentLocation.longitude,
        'latitude': currentLocation.latitude
      });
    });
  }
}
