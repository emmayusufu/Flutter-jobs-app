import 'package:workmannow/widgets/utils/chip.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class ChipList extends StatelessWidget {
  final List list;

  ChipList({this.list});
  @override
  Widget build(BuildContext context) {
    List _children = <Widget>[];
    for (var i = 0; i < list.length; i++) {
      _children.add(ChipWidget(
        label: list[i].toString().sentenceCase,
      ));
    }

    return Wrap(
      children: _children,
    );
  }
}
