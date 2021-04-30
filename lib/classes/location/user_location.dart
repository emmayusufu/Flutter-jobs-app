import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';

class UserLocation {
  final userLocation;
  final LatLng coordinates;
  UserLocation({@required this.userLocation, @required this.coordinates});
}
