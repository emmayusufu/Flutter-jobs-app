import 'package:workmannow/helpers/colors.dart';
import 'package:flutter/material.dart';

class ThemeHelper {
  static final theme = ThemeData(
    cardTheme: CardTheme(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      labelStyle: TextStyle(color: Colors.blue, fontSize: 13.0),
      fillColor: Colors.blue.withOpacity(0.1),
      contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.blue[100], width: 1)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            30.0,
          ),
          borderSide: BorderSide(color: Colors.blue, width: 2)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            30.0,
          ),
          borderSide: BorderSide(color: Colors.red, width: 1)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            30.0,
          ),
          borderSide: BorderSide(color: Colors.red, width: 1)),
    ),
    scaffoldBackgroundColor: Colors.grey[200],
    primarySwatch: MyColors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Quicksand',
    appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: MyColors.blue),
        textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.blue, fontFamily: 'Quicksand', fontSize: 20.0))),
  );
}
