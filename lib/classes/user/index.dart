import 'dart:io';

class User {
  String firstName;
  String lastName;
  final String profession;
  final String qualification;
  final List<dynamic> specialities;
  final String aboutSelf;
  final String startingFee;
  final String nin;
  final String role;
  final String regionOfOperation;
  final String phoneNumber;
  final File profileImage;
  final File idBackImage;
  final String otp;
  final String password;
  final DateTime dob;
  final File idFrontImage;
  final String email;

  User({
      this.firstName,
      this.lastName,
      this.otp,
      this.email,
      this.phoneNumber,
      this.specialities,
      this.profession,
      this.password,
      this.regionOfOperation,
      this.qualification,
      this.role,
      this.profileImage,
      this.aboutSelf,
      this.nin,
      this.dob,
      this.startingFee,
      this.idBackImage,
      this.idFrontImage});
}
