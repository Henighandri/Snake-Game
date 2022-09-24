

import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import '../controller/settings_controller.dart';
import 'level_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
     final SettingsController settingsController=Get.put(SettingsController());
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
            duration: 2000,
            splash: Image.asset("assets/icons/app_icon.png"),
            splashIconSize: MediaQuery.of(context).size.shortestSide*.5 ,
            nextScreen: const LevelScreen(),
            splashTransition: SplashTransition.scaleTransition,
            backgroundColor: Colors.black);
   
  }
}