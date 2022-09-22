import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snake_game/controller/settings_controller.dart';

class BlankPixel extends StatelessWidget {
   BlankPixel({Key? key}) : super(key: key);

  final SettingsController settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    decoration: BoxDecoration(
                 
                color:settingsController.darkMode! ?Colors.grey[900]: Colors.grey[400],
                       borderRadius: BorderRadius.circular(2)

                    ),
                  ),
                );
  }
}