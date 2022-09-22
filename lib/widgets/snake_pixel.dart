import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/settings_controller.dart';

class SnakePixel extends StatelessWidget {
   SnakePixel({Key? key}) : super(key: key);
final SettingsController settingsController=Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                     
                      color:settingsController.darkMode!?Colors.white: Colors.black,
                       borderRadius: BorderRadius.circular(2)

                    ),
                  ),
                );
  }
}