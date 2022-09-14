import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/settings_controller.dart';

class ObstaclePixel extends StatelessWidget {
   ObstaclePixel({Key? key}) : super(key: key);
final SettingsController settingsController=Get.find<SettingsController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                     
                     color:settingsController.darkMode!?Colors.grey: Colors.black54,
                       borderRadius: BorderRadius.circular(4)

                    ),
                  ),
                );
  }
}