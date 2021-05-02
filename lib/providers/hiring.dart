import 'dart:convert';
import 'package:workmannow/classes/hiring/index.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class HiringProvider extends ChangeNotifier {
  final String url = "192.168.0.108:3001";

  Future<String> getCurrentUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = jsonDecode(prefs.getString('user'));
    return userData['_id'];
  }

  Future<String> hireWorkMan(Hiring hireDetails) async {
    String message;
    try {
      var response = await http
          .post(Uri.parse('https://$url/hire/${hireDetails.workManId}'), body: {
        'clientID': hireDetails.clientId,
        'description': hireDetails.jobDescription,
        'clientName': hireDetails.clientName,
        'location': hireDetails.location,
        'contact': hireDetails.contact,
        "clientImage": hireDetails.clientImage,
        "geocodes": jsonEncode(hireDetails.geocodes)
      });
      if (response.statusCode == 200) {
        Map res = convert.jsonDecode(response.body);
        message = res['message'];
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('caught error : $e while hiring workman');
    }
    return message;
  }

  Future<String> completeHire(
      {String documentRef, double workManRating, String review}) async {
    String message;
    try {
      var response = await http.post(Uri.parse('https://$url/complete_hiring'),
          body: {
            "docRef": documentRef,
            "workManRating": workManRating,
            "review": review
          });
      if (response.statusCode == 200) {
        Map res = convert.jsonDecode(response.body);
        if (res['message'] == 'success') {
          message = res['message'];
        } else {
          message = res['message'];
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('caught error : $e while accepting hire');
    }
    return message;
  }

  Future<String> acceptHire({documentRef}) async {
    String message;
    try {
      var response = await http.post(Uri.parse('https://$url/accept_hiring'),
          body: {"docRef": documentRef});
      if (response.statusCode == 200) {
        Map res = convert.jsonDecode(response.body);
        if (res['message'] == 'success') {
          message = res['message'];
        } else {
          message = res['message'];
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('caught error : $e while accepting hire');
    }
    return message;
  }

  Future<String> declineHire({documentRef}) async {
    String message;
    try {
      var response = await http.post(Uri.parse('https://$url/decline_hiring'),
          body: {"docRef": documentRef});
      if (response.statusCode == 200) {
        Map res = convert.jsonDecode(response.body);
        if (res['message'] == 'success') {
          message = res['message'];
        } else {
          message = res['message'];
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('caught error : $e while declining hire');
    }
    return message;
  }
}
