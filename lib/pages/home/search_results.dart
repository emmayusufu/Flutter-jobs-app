import 'package:flutter/material.dart';

class SearchResults extends StatefulWidget {
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Lawyers',
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.filter_alt,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
      ),
      body: SafeArea(
          child: ListView.builder(
        itemCount: 20,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text('tile'));
        },
      )),
    );
  }
}
