import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:snake_game/controller/settings_controller.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final double space = 15;
  final SettingsController _settinsController = Get.find<SettingsController>();

  
  @override
  void initState() {
    super.initState();
    _settinsController.getSettings();
  }

  Widget customSwitch(String text, bool? val, Function(bool) onChagedMethod) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 20,),
          ),
          if (val != null)
            CupertinoSwitch(
                trackColor: Colors.red,
                thumbColor: Colors.white,
                activeColor: Colors.green,
                value: val,
                onChanged: onChagedMethod)
          else
            const CircularProgressIndicator()
        ],
      ),
    );
  }
  
   Widget customDropDown(String text,  String? valueChoose, Function(String?) onChagedMethod) {
    var  listItem=["Joypad","Swipe"];
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 20, ),
          ),
          DropdownButton(
               
              // Initial Value
              value: valueChoose,
               
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),   
               
              // Array list of items
              items: listItem.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: onChagedMethod )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
     
       appBar: AppBar(
       
        centerTitle: true,
        title: Text(
                "SETTINGS",
                style: Theme.of(context).textTheme.headline5!.copyWith(letterSpacing: 5)
                
                    
              ) ,
            leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                   
                  )),
       ),
       
      body: GetBuilder<SettingsController>(builder: (_) {
        return Column(children: [
          
          
          const SizedBox(height: 5,),
          const Text(
            "Play as you wish",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
          const SizedBox(
            height: 20,
          ), customSwitch("Dark Mode", _settinsController.darkMode,
              _settinsController.onChangedTheme),
          SizedBox(
            height: space,
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          customSwitch("Sound", _settinsController.sound,
              _settinsController.onChangedSound),
          SizedBox(
            height: space,
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          SizedBox(
            height: space,
          ),
          customSwitch("Vibration", _settinsController.vibration,
              _settinsController.onChangedVibration),
          SizedBox(
            height: space,
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          SizedBox(
            height: space,
          ),
         // customSwitch("Controls", _settinsController.controls,
          //    _settinsController.onChangedControls),
          customDropDown("Controls", _settinsController.controls,  _settinsController.onChangedControls),
          SizedBox(
            height: space,
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          )

        ]);
      }),
    ));
  }
}
