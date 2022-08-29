import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_game/models/level.dart';
import 'package:snake_game/widgets/Stars.dart';

import 'package:snake_game/widgets/home_page.dart';

import '../controller/score_controller.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({Key? key}) : super(key: key);

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  List<Level> levels=[];
  int nbLevel=12;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getScoreMax();
  }
   getScoreMax() async {
    final pref=await SharedPreferences.getInstance();
     List<Level> levelList=[];
      for(int i=0;i<nbLevel;i++){
       int scoreMax = pref.getInt('${i+1}') ?? 0;
        levelList.add(Level(level: i+1,maxScore: scoreMax));
      //  print("${levelList[i].level} :${levelList[i].maxScore}");
      }
      setState(() {
        levels =levelList;
      });

    
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          const Expanded(child: Center(
            child: Text("Level",style:TextStyle(color: Colors.white,fontSize: 25)),
          )),
          Expanded(
            flex: 4,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                    itemCount: levels.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index)  {
                      return LevelItem(level: levels[index],);
                    }),
              ),
            ),
          ),
          Expanded(child: Container()),
        ],
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

class _LevelItemState extends State<LevelItem> with WidgetsBindingObserver{
 //ScoreController scoreController=Get.put(ScoreController());

int rowSize= 0;
  int totalNumberOfSquares=0;
int nbStars=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rowSize= widget.level.level!+9;
    totalNumberOfSquares=(widget.level.level!+9)*(widget.level.level!+9);
  calculNbStars();
  }
 void calculNbStars(){

  double facteur =(totalNumberOfSquares-(3+widget.level.level!-1))/35;
  print(facteur);

 if(   widget.level.maxScore! >facteur &&widget.level.maxScore! <=2*facteur ){
  nbStars=1;
 }else if(   widget.level.maxScore! >2*facteur &&widget.level.maxScore! <=3*facteur ){
  nbStars=2;
 }else if(   widget.level.maxScore! >3*facteur ){
  nbStars=3;
 }
 }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state==AppLifecycleState.resumed){
      print("Resumed");
    }
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
                          milliseconds: 210-(widget.level.level!+9),
                          nbObstacle: widget.level.level!-1,
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
             
               Stars(nbStars: nbStars,),
            ],
          ),
        ),
      ),
    );
  }
}


