import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:snake_game/controller/settings_controller.dart';
import 'package:snake_game/screen/level_screen.dart';
import 'package:snake_game/screen/splash_screen.dart';
import 'package:snake_game/theme/theme.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {

   MyApp({Key? key}
   
  ) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Snake Game',
      debugShowCheckedModeBanner: false,
     
         theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      //settingsController.darkMode!? ThemeMode.dark:ThemeMode.light,
     
      home: const SplashScreen(),
    );
  }
}