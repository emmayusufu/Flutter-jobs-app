import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  final int count;
  Rating({@required this.count});

  @override
  Widget build(BuildContext context) {
    List children = <Widget>[];
    if (count == 0) {
      children = <Widget>[
        Icon(
          Icons.star,
          color: Colors.grey,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.grey,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.grey,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.grey,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.grey,
          size: 15.0,
        ),
      ];
    } else if (count == 1) {
      children = <Widget>[
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.grey,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.grey,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.grey,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.grey,
          size: 15.0,
        ),
      ];
    } else if (count == 2) {
      children = <Widget>[
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.grey,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.grey,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.grey,
          size: 15.0,
        ),
      ];
    } else if (count == 3) {
      children = <Widget>[
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.grey,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.grey,
          size: 15.0,
        ),
      ];
    } else if (count == 4) {
      children = <Widget>[
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.grey,
          size: 15.0,
        ),
      ];
    } else if (count == 5) {
      children = <Widget>[
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15.0,
        ),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15.0,
        ),
      ];
    }
    return Row(
      children: children,
    );
  }
}
