import 'package:flutter/material.dart';
import 'package:snake_game/screen/level_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
       brightness: Brightness.dark
      ),
      home: const LevelScreen(),
    );
  }
}