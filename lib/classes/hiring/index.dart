import 'package:flutter/foundation.dart';

class Hiring {
  String workManId;
  String workManPhoneNumber;
  String clientId;
  String clientName;
  String jobDescription;
  String location;
  String clientPhoneNumber;
  String clientImage;
  Map<String, dynamic> geocodes;

  Hiring(
      {@required this.clientId,
      @required this.workManPhoneNumber,
      @required this.jobDescription,
      @required this.workManId,
      @required this.clientName,
      @required this.clientPhoneNumber,
      @required this.clientImage,
      this.geocodes,
      this.location});
}
