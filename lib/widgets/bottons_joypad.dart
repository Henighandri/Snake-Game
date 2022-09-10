import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ButtonsJoyPad extends StatelessWidget {
  const ButtonsJoyPad({Key? key,  this.onTapUp,  this.onTapRight,  this.onTapLeft,  this.onTapDown}) : super(key: key);
final Function()? onTapUp;
final Function()? onTapRight;
final Function()? onTapLeft;
final Function()? onTapDown;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTapUp,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: 36,
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap:onTapLeft ,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                        size: 36,
                      ),
                ),
              ),
               GestureDetector(
                onTap: onTapDown,
                 child: Container(
                           decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20)),
                           margin: const EdgeInsets.symmetric(horizontal: 5),
                           padding: const EdgeInsets.all(10),
                           
                           child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 36,
                  ),
                         ),
               ),
              GestureDetector(
                onTap: onTapRight,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                        size: 36,
                      ),
                ),
              ),
            ],
          ),
         
        ]);
  }
}
