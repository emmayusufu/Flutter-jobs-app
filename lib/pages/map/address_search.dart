import 'dart:async';
import 'dart:math';
import 'package:workmannow/classes/location/user_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = 'AIzaSyDu9bVeiHL5Y_i_G0IrjGE4TNdJ7X6U4hI';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

final searchScaffoldKey = GlobalKey<ScaffoldState>();

Future<PlacesDetailsResponse> displayPrediction(
    Prediction p, ScaffoldState scaffold) async {
  PlacesDetailsResponse detail;
  if (p != null) {
    detail = await _places.getDetailsByPlaceId(p.placeId);
  } else
    detail = null;
  return detail;
}

class AddressSearch extends PlacesAutocompleteWidget {
  AddressSearch()
      : super(
          apiKey: kGoogleApiKey,
          sessionToken: Uuid().generateV4(),
          language: "en",
          components: [Component(Component.country, "ug")],
        );

  @override
  _AddressSearchState createState() => _AddressSearchState();
}

class _AddressSearchState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: searchScaffoldKey,
        appBar: AppBar(
          toolbarHeight: 100,
          bottom: PreferredSize(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: AppBarPlacesAutoCompleteTextField(
                  textDecoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Search address'),
                ),
              ),
              preferredSize: Size.fromHeight(50.0)),
        ),
        body: PlacesAutocompleteResult(
          onTap: (p) {
            final FocusScopeNode currentScope = FocusScope.of(context);
            if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
              FocusManager.instance.primaryFocus.unfocus();
            }
            displayPrediction(p, searchScaffoldKey.currentState).then((value) {
              if (value != null) {
                final lat = value.result.geometry.location.lat;
                final lng = value.result.geometry.location.lng;

                if (mounted) {
                  Navigator.of(context).pop(UserLocation(
                      userLocation: p.description,
                      coordinates: LatLng(lat, lng)));
                }
              }
            }).catchError((e) => {print('caught error: $e')});
          },
          logo: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [Text('No location searched')],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ));
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
      // searchScaffoldKey.currentState.showSnackBar(
      //   SnackBar(content: Text("Got answer")),
      // );
    }
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
