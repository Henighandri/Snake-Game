import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_game/widgets/blank_pixel.dart';
import 'package:snake_game/widgets/head_pixel.dart';
import 'package:snake_game/widgets/obstacle_pixel.dart';
import 'package:snake_game/widgets/snake_pixel.dart';

import 'food_pixel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key,
      required this.rowSize,
      required this.totalNumberOfSquares,
      required this.milliseconds,
      required this.nbObstacle,
      this.outline = false, required this.level})
      : super(key: key);
  final int rowSize;
  final int totalNumberOfSquares;
  final int milliseconds;
  final int nbObstacle;
  final bool outline;
  final int level;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum snakeDirection { UP, DOWN, LEFT, RIGHT }

class _MyHomePageState extends State<MyHomePage> {
  bool gameHasStarted = false;
 

//grid dimensions

  //snake position
  List<int> snakePos = [];

  //obstacle position
  List<int> obstaclePixel = [];

//snake direction is initially to the right
  var currentDirection = snakeDirection.RIGHT;

//food position
  int foodPos = 28;
  int currentScore = 0;
  int scoreMax =0 ;

  bool stopTimer = false;
//start the game
  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: widget.milliseconds), (timer) {
      setState(() {
        moveSnake();

        if (stopTimer) {
          timer.cancel();
        }
        //check if the game is over
        if (gameOver()) {
         
          timer.cancel();
          setMaxScore();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title:const Center(child:  Text("Game Over",style: TextStyle(color: Colors.grey,))),
                  

                  content: SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        children: [
                           
                         const Text(" Score Max :",
                          style:  TextStyle(color: Colors.white,fontSize: 25),),
                           Text(" $scoreMax",
                          style: const TextStyle(color: Colors.white,fontSize: 30),),
                          const SizedBox(height: 20,),

                          const Text(" Score :",
                          style:  TextStyle(color: Colors.white,fontSize: 25),),
                           Text(" $currentScore",
                          style: const TextStyle(color: Colors.white,fontSize: 45),),
                        
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    MaterialButton(
                      color: Colors.pink,
                      onPressed: () {
                        Navigator.pop(context);
                        restartGame();
                      },
                      child: const Text('reset'),
                    )
                  ],
                );
              });
        }
      });
    });
  }

  void restartGame() {
    setState(() {
      gameHasStarted = false;
        changeFoodPos();
      currentScore = 0;
      if (widget.outline) {
        snakePos = [widget.rowSize + 1, widget.rowSize + 2, widget.rowSize + 3];
      } else {
        snakePos = [0, 1, 2];
      }

      currentDirection = snakeDirection.RIGHT;
    });
  }

  void moveSnake() {
    switch (currentDirection) {
      case snakeDirection.RIGHT:
        {
          //add a new head
          //if snake is at the right wall, need to re-adjust
          if (snakePos.last % widget.rowSize == widget.rowSize - 1) {
            snakePos.add(snakePos.last + 1 - widget.rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }

        break;
      case snakeDirection.LEFT:
        {
          //add a new head
          //if snake is at the left wall, need to re-adjust
          if (snakePos.last % widget.rowSize == 0) {
            snakePos.add(snakePos.last - 1 + widget.rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }

        break;
      case snakeDirection.UP:
        {
          //add a new head
          //if snake is at the up wall, need to re-adjust
          if (snakePos.last < widget.rowSize) {
            snakePos.add(
                snakePos.last - widget.rowSize + widget.totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last - widget.rowSize);
          }
        }

        break;
      case snakeDirection.DOWN:
        {
          //add a new head
          //if snake is at the down wall, need to re-adjust
          if (snakePos.last >= widget.totalNumberOfSquares - widget.rowSize) {
            snakePos.add(
                snakePos.last + widget.rowSize - widget.totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last + widget.rowSize);
          }
        }

        break;
      default:
    }
    //snake is eating food
    if (snakePos.last == foodPos) {
      currentScore++;
      changeFoodPos();
    } else {
      //remove the tail
      snakePos.removeAt(0);
    }
  }

  void changeFoodPos() {
    //making sure the new food is not where the snake is
    while (snakePos.contains(foodPos) || obstaclePixel.contains(foodPos)) {
      foodPos = Random().nextInt(widget.totalNumberOfSquares);
    }
  }

  @override
  void initState() {

    getScoreMax();

    if (widget.outline) {
      snakePos = [widget.rowSize + 1, widget.rowSize + 2, widget.rowSize + 3];
    } else {
      snakePos = [0, 1, 2];
    }

    outlineConstruction();
    randomObstacle();
  }

  int nbPixelOutline = 0;
  void randomObstacle() {
    //for(int i=0;i<widget.nbObstacle;i++){
    while (obstaclePixel.length < widget.nbObstacle + nbPixelOutline) {
      int obstacleRandom = Random().nextInt(widget.totalNumberOfSquares);
      if (obstacleRandom != foodPos &&
          !snakePos.contains(obstacleRandom) &&
          !obstaclePixel.contains(obstacleRandom)) {
        obstaclePixel.add(obstacleRandom);
      }
    }
  }

  void outlineConstruction() {
    for (int i = 0; i < widget.totalNumberOfSquares; i++) {
      if ((i >= widget.totalNumberOfSquares - widget.rowSize ||
              i < widget.rowSize ||
              i % widget.rowSize == widget.rowSize - 1 ||
              i % widget.rowSize == 0) &&
          widget.outline) {
        obstaclePixel.add(i);
      }
    }
    nbPixelOutline = obstaclePixel.length;
  }

  bool gameOver() {
    //the game is over when the snake runs into itself
    //this occurs when there is a duplicate position in the snakePos list

    //this list is the body of the snake(no head)
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);
    if (bodySnake.contains(snakePos.last) ||
        obstaclePixel.contains(snakePos.last)) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    stopTimer = true;
   
  }
  
 getScoreMax() async {
    final pref=await SharedPreferences.getInstance();
    scoreMax = pref.getInt('${widget.level}') ?? 0;
  }

  Future<void> setMaxScore() async {
    final pref=await SharedPreferences.getInstance();
 
    if(currentScore> scoreMax){
      pref.setInt("${widget.level}", currentScore);
    scoreMax = pref.getInt('${widget.level}') ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (event){
            if(event.character.toString()=='z'&&
                          currentDirection != snakeDirection.DOWN){
              currentDirection=snakeDirection.UP;
            }else if(event.character.toString()=='q'&&
                          currentDirection != snakeDirection.RIGHT){
              currentDirection=snakeDirection.LEFT;
            }else if(event.character.toString()=='d'&&
                          currentDirection != snakeDirection.LEFT){
              currentDirection=snakeDirection.RIGHT;
            }else if(event.character.toString()=='b'&&
                          currentDirection != snakeDirection.UP){
              currentDirection=snakeDirection.DOWN;
            }
          },
          child: Column(
            children: [
              Expanded(
                  child: Center(
                      child: Text(
                    currentScore.toString(),
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))),
              Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.delta.dy > 0 &&
                          currentDirection != snakeDirection.UP) {
                        currentDirection = snakeDirection.DOWN;
                      } else if (details.delta.dy < 0 &&
                          currentDirection != snakeDirection.DOWN) {
                        currentDirection = snakeDirection.UP;
                      }
                    },
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.dx > 0 &&
                          currentDirection != snakeDirection.LEFT) {
                        currentDirection = snakeDirection.RIGHT;
                      } else if (details.delta.dx < 0 &&
                          currentDirection != snakeDirection.RIGHT) {
                        currentDirection = snakeDirection.LEFT;
                      }
                    },
                    child: GridView.builder(
                        itemCount: widget.totalNumberOfSquares,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: widget.rowSize),
                        itemBuilder: (context, index) {
                          if (obstaclePixel.contains(index)) {
                            return const ObstaclePixel();
                          } else if (snakePos.last == index) {
                            return const HeadPixel();
                          } else if (snakePos.contains(index)) {
                            return const SnakePixel();
                          } else if (index == foodPos) {
                            return const FoodPixel();
                          } else {
                            return const BlankPixel();
                          }
                        }),
                  )),
              Expanded(
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        child: Text("Back"),
                        color: Colors.pink,
                        onPressed: () {
                          stopTimer = true;
                          Navigator.pop(context);
                        },
                      ),
                      MaterialButton(
                        child: Text("PLAY"),
                        color: gameHasStarted ? Colors.grey : Colors.pink,
                        onPressed: gameHasStarted ? () {} : startGame,
                      ),
                    ],
                  ))),
            ],
          ),
        ),
      ),
    );
  }
}
