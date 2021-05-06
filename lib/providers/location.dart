import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const GOOGLE_MAPS_API_KEY = 'AIzaSyDu9bVeiHL5Y_i_G0IrjGE4TNdJ7X6U4hI';

class LocationProvider extends ChangeNotifier {
  Location location = new Location();

  bool _locationEnabled = true;

  get isLocationEnable => _locationEnabled;

  set locationEnabled(bool value) {
    locationEnabled = value;
    notifyListeners();
  }

  Future<String> getPlaceAddress(double lat, double lng) async {
    final url =
        Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_MAPS_API_KEY');
    final response = await http.get(url);
    return convert.jsonDecode(response.body)['results'][0]['formatted_address'];
  }
}
