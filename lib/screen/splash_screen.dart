

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    Timer(const Duration(seconds: 3),
          ()=>Get.to(()=>const LevelScreen())
         );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child:FlutterLogo(size:MediaQuery.of(context).size.height)
    );
  }
}