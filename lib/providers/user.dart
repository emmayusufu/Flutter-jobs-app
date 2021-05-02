import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmannow/classes/user/index.dart';

class UserProvider extends ChangeNotifier {
  final String url = "192.168.0.108:3001";
  var _user;

  get user => _user;

  set user(value) {
    _user = value;
    notifyListeners();
  }

  bool get isAuthenticated {
    return _user != null;
  }

  Future<String> login(User loginDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String message;
    try {
      var response = await http.post(Uri.parse('http://$url/api/user_login'),
          body: {
            'phoneNumber': loginDetails.phoneNumber,
            'password': loginDetails.password
          });
      if (response.statusCode == 200) {
        Map res = jsonDecode(response.body);
        if (res['message'] == 'success') {
          await prefs.setString('user', jsonEncode(res['user']));
          message = res['message'];
          user = res['user'];
        } else {
          message = res['message'];
        }
      } else {
        print(response.statusCode);
        message = 'An error occurred';
      }
    } catch (e) {
      print('caught error : $e while logging in');
    }
    return message;
  }

  Future<String> register(User signUpDetails) async {
    String message;
    try {
      var response = await http
          .post(Uri.parse('http://$url/api/user_registration'), body: {
        "email": signUpDetails.email,
        'phoneNumber': signUpDetails.phoneNumber,
        'password': signUpDetails.password
      });
      if (response.statusCode == 200) {
        Map res = jsonDecode(response.body);
        if (res['message'] == 'success') {
          message = res['message'];
        } else {
          message = res['message'];
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('caught error : $e while registering account');
    }
    return message;
  }

  Future<String> verifyOtp(User otp) async {
    String message;
    try {
      var response = await http.post(
          Uri.parse('http://$url/api/otp_verification'),
          body: {"phoneNumber": otp.phoneNumber, "otp": otp.otp});
      if (response.statusCode == 200) {
        Map res = jsonDecode(response.body);
        if (res['message'] == 'success') {
          user = res;
          message = res['message'];
        } else {
          message = res['message'];
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('caught error : $e while verifying otp');
    }
    return message;
  }

// ============================================================================== setting up client profile
  Future<String> setUpClientProfile(User client) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String message;
    var dio = Dio();

    try {
      FormData formData = FormData.fromMap({
        "userId": user['id'],
        "firstName": client.firstName,
        "lastName": client.lastName,
        "profileImage": await MultipartFile.fromFile(client.profileImage.path,
            filename: basename(client.profileImage.path)),
      });
      var response = await dio.post(
        "http://$url/api/setup_client_profile",
        data: formData,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      if (response.statusCode == 200) {
        Map res = response.data;
        if (res['message'] == 'success') {
          await prefs.setString('user', jsonEncode(res['user']));
          message = res['message'];
          user = res['user'];
        } else {
          message = res['message'];
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('caught error $e while setting up client profile');
    }
    return message;
  }

// ============================================================================== setting up workman profile
  Future<String> setUpWorkManProfile(User workman) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String message;
    var dio = Dio();

    try {
      FormData formData = FormData.fromMap({
        "id": user['id'],
        "firstName": workman.firstName,
        "lastName": workman.lastName,
        "regionOfOperation": workman.regionOfOperation,
        "dob": workman.dob,
        "specialities": workman.specialities,
        "nin": workman.nin,
        'aboutSelf': workman.aboutSelf,
        "profession": workman.profession,
        "qualification": workman.qualification,
        "startingFee": workman.startingFee,
        "profileImage": await MultipartFile.fromFile(workman.profileImage.path,
            filename: basename(workman.profileImage.path)),
        "idBack": await MultipartFile.fromFile(workman.idBackImage.path,
            filename: basename(workman.idBackImage.path)),
        "idFront": await MultipartFile.fromFile(workman.idFrontImage.path,
            filename: basename(workman.idFrontImage.path)),
      });
      var response = await dio.post(
        "http://$url/api/setup_workman_profile",
        data: formData,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      if (response.statusCode == 200) {
        Map res = response.data;
        message = res['message'];
        await prefs.setString('user', jsonEncode(res['user']));
        message = res['message'];
        user = res['user'];
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('caught error $e while setting up workman profile');
    }
    return message;
  }

  Future<List> fetchAllWorkMen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = jsonDecode(prefs.getString('user'));
    final userId = userData['_id'];
    List workmen;
    try {
      var response = await http.get(Uri.parse(
          'http://$url/api/users?fields=firstName,lastName,rating,profileImage,aboutSelf,startingFee,profession&role=workman&userId=$userId'));
      if (response.statusCode == 200) {
        workmen = jsonDecode(response.body)['users'];
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('caught error : $e while fetching all workmen');
    }
    return workmen;
  }

  // ==================================================================================== future function for updating user profile
  Future<String> updateUserProfile(User workman) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String message;
    var dio = Dio();
    try {
      FormData formData = FormData.fromMap({
        'userId': user['_id'],
        "regionOfOperation": workman.regionOfOperation,
        "specialities": workman.specialities,
        'aboutSelf': workman.aboutSelf,
        "profession": workman.profession,
        "qualification": workman.qualification,
        "startingFee": workman.startingFee,
        'dob': workman.dob,
        "role": workman.role,
        'nin': workman.nin,
        "profileImage": workman.profileImage != null
            ? await MultipartFile.fromFile(workman.profileImage.path,
                filename: basename(workman.profileImage.path))
            : null,
        "idBackImage": workman.idBackImage != null
            ? await MultipartFile.fromFile(workman.idBackImage.path,
                filename: basename(workman.idBackImage.path))
            : null,
        "idFrontImage": workman.idFrontImage != null
            ? await MultipartFile.fromFile(workman.idFrontImage.path,
                filename: basename(workman.idFrontImage.path))
            : null,
      });
      var response = await dio.post(
        "http://$url/api/update_user_profile",
        data: formData,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      if (response.statusCode == 200) {
        Map res = response.data;
        message = res['message'];
        await prefs.setString('user', jsonEncode(res['user']));
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('caught error $e while setting up workman profile');
    }
    return message;
  }

// ============================================================================== logging out
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    user = null;
  }

  Future<void> tryAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      final userData = jsonDecode(prefs.getString('user'));
      user = userData;
    }
  }
}
