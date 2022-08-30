import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_game/models/level.dart';
import 'package:snake_game/widgets/Stars.dart';

import 'package:snake_game/widgets/home_page.dart';

import '../controller/level_controller.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({Key? key}) : super(key: key);

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
 LevelController _levelController=Get.put(LevelController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   _levelController.getListLevel();
  }
   
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
        children: [
            /*const Expanded(child: Center(
              child: Text("Level",style:TextStyle(color: Colors.white,fontSize: 25)),
            )),*/
            Expanded(
              flex: 4,
              child: GetBuilder<LevelController>(
                builder: (_) {
                  return Center(
                    child:
                         Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                         child: 
                              _levelController.levels.isNotEmpty? GridView.builder(
                                  itemCount: _levelController.levels.length,
                                //  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                                  itemBuilder: (context, index)  {

                                    return LevelItem(level: _levelController.levels[index],);
                                  }):const CircularProgressIndicator()
                           
                        )
                     
                  );
                }
              ),
            ),
            Expanded(child: Container()),
        ],
      ),
          )),
    );
  }
}

class LevelItem extends StatefulWidget {
  const LevelItem({Key? key, required this.level}) : super(key: key);
  final Level level;

  @override
  State<LevelItem> createState() => _LevelItemState();
}

class _LevelItemState extends State<LevelItem> {


int rowSize= 0;
  int totalNumberOfSquares=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rowSize= widget.level.level!+9;
    totalNumberOfSquares=(widget.level.level!+9)*(widget.level.level!+9);
 //
  }



  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
      child: GestureDetector(
        onTap: () {

          Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(
                          rowSize: rowSize,
                          totalNumberOfSquares: totalNumberOfSquares,
                          milliseconds:widget.level.level! < 10 ? 250-(widget.level.level!*10):100,
                          nbObstacle: widget.level.level! < 10 ?
                          widget.level.level!-1 :
                          widget.level.level!-10,
                          level: widget.level.level!,
                           outline: widget.level.level!>9,
                        )),
              );
        
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 2, color: Colors.white)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${widget.level.level}",
              style: const TextStyle(color: Colors.white,fontSize: 40),
              ),
             
               Stars(nbStars:widget.level.nbStars!,),
            ],
          ),
        ),
      ),
    );
  }
}


