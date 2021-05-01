import 'dart:convert';

import 'package:workmannow/classes/auth/update_account.dart';
import 'package:workmannow/classes/hire/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:path/path.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final String url = "192.168.0.108:3001";

  Future<String> getCurrentUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = jsonDecode(prefs.getString('user'));
    return userData['_id'];
  }

  Future<List> fetchAllWorkMen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = jsonDecode(prefs.getString('user'));
    final userId = userData['_id'];
    List workmen;
    try {
      var response = await http
          .get(Uri.parse('http://$url/api/users?fields=firstName,lastName,rating,profileImage,aboutSelf,startingFee,profession&role=workman&userId=$userId'));
      if (response.statusCode == 200) {
        workmen = convert.jsonDecode(response.body)['users'];
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('caught error : $e while fetching all workmen');
    }
    return workmen;
  }

//  ============================================ future function for hiring a workmen
  Future<String> hireWorkMan(HireModal hireDetails) async {
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

  // ==================================================================================== future function for updating user acount
  Future<String> updateWorkManProfile(UpdateWorkManProfile workman) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = jsonDecode(prefs.getString('user'));
    final userId = userData['_id'];
    String message;
    var dio = Dio();

    try {
      FormData formData = FormData.fromMap({
        "areaOfOperation": workman.areaOfOperation,
        "specialities": workman.specialities,
        'aboutSelf': workman.aboutSelf,
        "profession": workman.profession,
        "qualification": workman.qualification,
        "startingFee": workman.startingFee,
        'workman': '${workman.workMan}',
        'client': '${workman.client}',
        'nin': workman.nin,
        "dpImage": workman.dpImage != null
            ? await MultipartFile.fromFile(workman.dpImage.path,
                filename: basename(workman.dpImage.path))
            : null,
        "idBack": workman.idBack != null
            ? await MultipartFile.fromFile(workman.idBack.path,
                filename: basename(workman.idBack.path))
            : null,
        "idFront": workman.idFront != null
            ? await MultipartFile.fromFile(workman.idFront.path,
                filename: basename(workman.idFront.path))
            : null,
      });
      var response = await dio.post(
        "https://$url/updateProfile/$userId",
        data: formData,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      if (response.statusCode == 200) {
        Map res = response.data;
        message = res['message'];
        await prefs.setString('user', convert.jsonEncode(res['user']));

        // user = res['user'];
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('caught error $e while setting up workman profile');
    }
    return message;
  }

// ==================================================================================== function for completing hire
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

// ==================================================================================== function for completing hire
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

// ==================================================================================== function for completing hire
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
