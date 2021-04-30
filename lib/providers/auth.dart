import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:workmannow/classes/auth/login.dart';
import 'package:workmannow/classes/auth/otp.dart';
import 'package:workmannow/classes/auth/profile_setup.dart';
import 'package:workmannow/classes/auth/signup.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final String url = "192.168.43.77:3001";

  var _user;

  get user => _user;

  set user(value) {
    _user = value;
    notifyListeners();
  }

  bool get isAuthenticated {
    return _user != null;
  }

  Future<String> login(LoginModal loginDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String message;
    try {
      var response = await http.post(Uri.parse('http://$url/api/user_login'), body: {
        'phoneNumber': loginDetails.phoneNumber,
        'password': loginDetails.password
      });
      if (response.statusCode == 200) {
        Map res = convert.jsonDecode(response.body);
        if (res['message'] == 'success') {
          await prefs.setString('user', convert.jsonEncode(res['user']));
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

  Future<String> signup(SignUpModal signUpDetails) async {
    String message;
    try {
      var response = await http.post(Uri.parse('http://$url/api/user_registration'), body: {
        "email": signUpDetails.email,
        'phoneNumber': signUpDetails.phoneNumber,
        'password': signUpDetails.password
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
      print('caught error : $e while registering account');
    }
    return message;
  }

  Future<String> verifyOtp(OTPModal otp) async {
    String message;
    try {
      var response = await http.post(Uri.parse('http://$url/verify_otp'),
          body: {"phoneNumber": otp.phoneNumber, "otp": otp.otp});
      if (response.statusCode == 200) {
        Map res = convert.jsonDecode(response.body);
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
  Future<String> setUpClientProfile(ClientProfile client) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String message;
    var dio = Dio();

    try {
      FormData formData = FormData.fromMap({
        "id": user['id'],
        "firstName": client.firstName,
        "lastName": client.lastName,
        "dpImage": await MultipartFile.fromFile(client.dpImage.path,
            filename: basename(client.dpImage.path)),
      });
      var response = await dio.post(
        "https://$url/setup_client_profile",
        data: formData,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      if (response.statusCode == 200) {
        Map res = response.data;
        if (res['message'] == 'success') {
          await prefs.setString('user', convert.jsonEncode(res['user']));
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
  Future<String> setUpWorkManProfile(WorkManProfile workman) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String message;
    var dio = Dio();

    try {
      FormData formData = FormData.fromMap({
        "id": user['id'],
        "firstName": workman.firstName,
        "lastName": workman.lastName,
        "areaOfOperation": workman.areaOfOperation,
        "dob": workman.dob,
        "specialities": workman.specialities,
        "nin": workman.nin,
        'aboutSelf': workman.aboutSelf,
        "profession": workman.profession,
        "qualification": workman.qualification,
        "startingFee": workman.startingFee,
        "dpImage": await MultipartFile.fromFile(workman.dpImage.path,
            filename: basename(workman.dpImage.path)),
        "idBack": await MultipartFile.fromFile(workman.idBack.path,
            filename: basename(workman.idBack.path)),
        "idFront": await MultipartFile.fromFile(workman.idFront.path,
            filename: basename(workman.idFront.path)),
      });
      var response = await dio.post(
        "https://$url/setup_workman_profile",
        data: formData,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      if (response.statusCode == 200) {
        Map res = response.data;
        message = res['message'];
        await prefs.setString('user', convert.jsonEncode(res['user']));
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

// ============================================================================== logging out
  Future logout() async {
    user = null;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  Future tryAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      final userData = convert.jsonDecode(prefs.getString('user'));
      user = userData;
    }
  }
}
