import 'package:flutter/material.dart';

class ObstaclePixel extends StatelessWidget {
  const ObstaclePixel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                       color: Colors.grey,
                       borderRadius: BorderRadius.circular(4)

                    ),
                  ),
                );
  }
}