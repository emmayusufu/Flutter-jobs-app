import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropDownSearch extends StatelessWidget {
  final List items;
  final Function cb;
  final String value;
  final String hint;
  final String popUpTitle;
  DropDownSearch(
      {@required this.items,
      @required this.cb,
      @required this.value,
      this.popUpTitle,
      @required this.hint});

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      mode: Mode.BOTTOM_SHEET,
      popupTitle: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                popUpTitle == null ? '' : popUpTitle,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              )
            ],
          )
        ],
      ),
      showSelectedItem: true,
      items: [...items],
      hint: hint,
      onChanged: cb,
      selectedItem: value,
      clearButton: Icon(
        Icons.clear,
        color: Colors.red,
      ),
      dropdownSearchDecoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintStyle: TextStyle(color: Colors.blue, fontSize: 13.0),
          contentPadding:
              EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0)),
      showClearButton: true,
      dropDownButton: Icon(Icons.arrow_drop_down, color: Colors.blue),
      popupShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          side: BorderSide(color: Colors.grey, width: 2.0)),
    );
  }
}
