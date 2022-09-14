import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
    primaryColorDark: Colors.white,
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.dark()
  );

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        textTheme: TextTheme(
          headline5: TextStyle(fontSize: 25, color: Colors.black),
          bodyText1: TextStyle(fontSize: 20, color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black)),
    primaryColorLight: Colors.black,
    brightness: Brightness.light,
    primaryColor: Colors.black,
    colorScheme: const ColorScheme.light()

  
  );
}
