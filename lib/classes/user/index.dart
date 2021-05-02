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
  final File profileImage;
  final File idBackImage;
  final DateTime dob;
  final File idFrontImage;

  User({
      this.firstName,
      this.lastName,
      this.specialities,
      this.profession,
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
