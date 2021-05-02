import 'package:flutter/material.dart';

class SearchModal extends StatefulWidget {
  @override
  _SearchModalState createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      }),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      child: TextFormField(
                        style: TextStyle(color: Colors.blue, fontSize: 13.0),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Search ',
                          hintStyle:
                              TextStyle(color: Colors.blue, fontSize: 13.0),
                          fillColor: Colors.blue.withOpacity(0.1),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  color: Colors.blue[100], width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                30.0,
                              ),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                30.0,
                              ),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              preferredSize: Size.fromHeight(50.0)),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Recent searches....'),
            ),
            ListTile(
              title: Text('Lawyer'),
              trailing: IconButton(icon: Icon(Icons.clear), onPressed: () {}),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchResults()));
              },
            ),
            ListTile(
              title: Text('Engineer'),
              trailing: IconButton(icon: Icon(Icons.clear), onPressed: () {}),
            ),
            ListTile(
              title: Text('Carpenter'),
              trailing: IconButton(icon: Icon(Icons.clear), onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
