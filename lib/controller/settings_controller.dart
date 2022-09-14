import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  bool? sound, vibration, darkMode;
  String? controls;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getSettings();
    
   
  }

  getSettings() async {
    final pref = await SharedPreferences.getInstance();
    darkMode = pref.getBool("darkMode") ?? true;
    sound = pref.getBool("sound") ?? true;
    vibration = pref.getBool("vibration") ?? true;
    controls = pref.getString("controls") ?? "Swipe";
    Get.changeThemeMode(!darkMode! ? ThemeMode.light : ThemeMode.dark);
    update();
  }

  onChangedSound(bool newValue) async {
    sound = newValue;
    final pref = await SharedPreferences.getInstance();
    pref.setBool("sound", newValue);
    update();
  }

  onChangedTheme(bool newValue) async {
    darkMode = newValue;
    final pref = await SharedPreferences.getInstance();
    pref.setBool("darkMode", newValue);
    Get.changeThemeMode(!newValue ? ThemeMode.light : ThemeMode.dark);
   

    update();
  }

  onChangedVibration(bool newValue) async {
    vibration = newValue;
    final pref = await SharedPreferences.getInstance();
    pref.setBool("vibration", newValue);
    update();
  }

  onChangedControls(String? newValue) async {
    controls = newValue;
    final pref = await SharedPreferences.getInstance();
    pref.setString("controls", newValue!);
    update();
  }
}
