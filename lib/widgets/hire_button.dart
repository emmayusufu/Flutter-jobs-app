import 'package:workmannow/helpers/colors.dart';
// import 'package:workmannow/pages/hiring/hire_details.dart';
import 'package:flutter/material.dart';

class HireButton extends StatelessWidget {
  final workMan;
  HireButton({@required this.workMan});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         fullscreenDialog: true,
        //         builder: (_) => HireDetails(
        //               workman: workMan,
        //             )));
      },
      child: Text(
        'Hire',
        style: TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(),
      // color: MyColors.blue,
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(30.0),
      //     side: BorderSide(width: 2.0, color: Colors.grey[200])),
    );
  }
}
