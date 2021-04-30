import 'dart:io';

class UpdateWorkManProfile {
  final String profession;
  final String qualification;
  final List<dynamic> specialities;
  final String areaOfOperation;
  final String aboutSelf;
  final String startingFee;
  final String nin;
  final bool client;
  final bool workMan;
  final File dpImage;
  final File idBack;
  final File idFront;

  UpdateWorkManProfile(
      {this.areaOfOperation,
      this.specialities,
      this.profession,
      this.qualification,
      this.client,
      this.dpImage,
      this.aboutSelf,
      this.nin,
      this.workMan,
      this.startingFee,
      this.idBack,
      this.idFront});
}
