import 'dart:io';

class WorkManProfile {
  String firstName;
  String lastName;
  DateTime dob;
  String profession;
  String qualification;
  List<dynamic> specialities;
  String areaOfOperation;
  String nin;
  String aboutSelf;
  String startingFee;
  File dpImage;
  File idFront;
  File idBack;

  WorkManProfile(
      {this.dob,
      this.firstName,
      this.lastName,
      this.nin,
      this.areaOfOperation,
      this.specialities,
      this.profession,
      this.qualification,
      this.dpImage,
      this.idBack,
      this.aboutSelf,
      this.idFront,
      this.startingFee});
}

class ClientProfile {
  String firstName;
  String lastName;
  File dpImage;

  ClientProfile({
    this.firstName,
    this.lastName,
    this.dpImage,
  });
}
