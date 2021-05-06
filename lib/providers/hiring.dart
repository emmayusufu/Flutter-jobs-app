import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:workmannow/classes/hiring/index.dart';

class HiringProvider extends ChangeNotifier {
  final String url = "192.168.43.77:3001";

  Future<String> hireWorkMan(Hiring hiringDetails) async {
    String message;
    try {
      var response =
          await http.post(Uri.parse('http://$url/api/hire_workman'), body: {
        'clientId': hiringDetails.clientId,
        'workManId': hiringDetails.workManId,
        'description': hiringDetails.jobDescription,
        'clientName': hiringDetails.clientName,
        'workManPhoneNumber': hiringDetails.workManPhoneNumber,
        'clientPhoneNumber': hiringDetails.clientPhoneNumber,
        "clientImage": hiringDetails.clientImage,
      });
      if (response.statusCode == 200) {
        Map res = convert.jsonDecode(response.body);
        message = res['message'];
      } else {
        message = "failed";
        print(response.statusCode);
      }
    } on NoSuchMethodError catch (err) {
      throw (err);
    }
    return message;
  }

  Future<String> completeHire(
      {String documentRef, double workManRating, String review}) async {
    String message;
    try {
      var response = await http
          .post(Uri.parse('http://$url/api/complete_hiring'), body: {
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
      var response = await http.post(Uri.parse('http://$url/api/accept_hiring'),
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
      var response = await http.post(
          Uri.parse('http://$url/api/decline_hiring'),
          body: {"docRef": documentRef});
      if (response.statusCode == 200) {
        Map res = convert.jsonDecode(response.body);
        if (res['message'] == 'success') {
          message = res['message'];
        } else {
          message = res['message'];
        }
      } else {
        throw (response.statusCode);
      }
    } catch (e) {
      print('caught error : $e while declining hire');
    }
    return message;
  }
}
