import 'package:flutter/foundation.dart';

class HireModal {
  String workManId;
  String clientId;
  String clientName;
  String jobDescription;
  String location;
  String contact;
  String clientImage;
  Map<String, dynamic> geocodes;
  HireModal(
      {@required this.clientId,
      @required this.jobDescription,
      @required this.workManId,
      @required this.clientName,
      @required this.contact,
      @required this.clientImage,
      @required this.geocodes,
      @required this.location});
}
