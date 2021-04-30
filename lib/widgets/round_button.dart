import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workmannow/helpers/colors.dart';

class RoundButton extends StatefulWidget {
  final Function cb;
  final String name;

  RoundButton({@required this.cb, @required this.name});

  @override
  _RoundButtonState createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black54,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Colors.grey[200], width: 2.0)),
        height: 45.0,
        minWidth: 200,
        color: MyColors.blue,
        onPressed: widget.cb,
        child: Text(
          widget.name,
          style: TextStyle(color: Colors.white, fontSize: 15.0),
        ));
  }
}
