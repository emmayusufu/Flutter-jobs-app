import 'package:workmannow/screens/home/search_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchContainer extends StatefulWidget {
  @override
  _SearchContainerState createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.blue[100], width: 1)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        onTap: () {
          showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return SearchModal();
              });
        },
        child: Row(
          children: [
            IconButton(
                icon: Icon(
                  CupertinoIcons.search,
                  color: Colors.blue,
                ),
                onPressed: () {}),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Search for workmen ...',
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
      ),
    );
  }
}
