import 'package:flutter/foundation.dart';

class Hiring {
  String workManId;
  String clientId;
  String clientName;
  String jobDescription;
  String location;
  String contact;
  String clientImage;
  Map<String, dynamic> geocodes;
  Hiring(
      {@required this.clientId,
      @required this.jobDescription,
      @required this.workManId,
      @required this.clientName,
      @required this.contact,
      @required this.clientImage,
      @required this.geocodes,
      @required this.location});
}
