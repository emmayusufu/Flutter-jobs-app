import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:recase/recase.dart';

class MultiDropDown extends StatelessWidget {
  final items;
  final cb;
  final initialValue;

  MultiDropDown({this.items, this.cb, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField(
      initialValue: initialValue != null ? [...initialValue] : [],
      itemsTextStyle: TextStyle(fontSize: 13.5),
      items: items
          .map<MultiSelectItem<String>>((e) => MultiSelectItem<String>(
              e, e.replaceAll('_', ' ').toString().sentenceCase))
          .toList(),
      title: Text("Specialities"),
      listType: MultiSelectListType.CHIP,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.all(Radius.circular(40)),
        border: Border.all(
          color: Colors.blue[100],
        ),
      ),
      buttonIcon: Icon(
        Icons.arrow_drop_down,
        color: Colors.blue,
      ),
      buttonText: Text(
        "Specialities",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 13.5,
        ),
      ),
      onConfirm: cb,
    );
  }
}
