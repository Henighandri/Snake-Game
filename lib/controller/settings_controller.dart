import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController{
  
  bool? sound, vibration;
  String? controls;
  
  getSettings() async {
    final pref = await SharedPreferences.getInstance();
    sound = pref.getBool("sound") ?? true;
    vibration = pref.getBool("vibration") ?? true;
    controls = pref.getString("controls") ?? "Swipe";
    update();
  }

  onChangedSound(bool newValue) async {
    sound = newValue;
    final pref = await SharedPreferences.getInstance();
    pref.setBool("sound", newValue);
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