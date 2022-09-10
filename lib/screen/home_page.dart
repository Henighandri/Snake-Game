import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_game/ads/interstitiel_ad_model.dart';
import 'package:snake_game/controller/settings_controller.dart';
import 'package:snake_game/screen/level_screen.dart';
import 'package:snake_game/widgets/blank_pixel.dart';
import 'package:snake_game/widgets/head_pixel.dart';
import 'package:snake_game/widgets/obstacle_pixel.dart';
import 'package:snake_game/widgets/snake_pixel.dart';

import '../ads/banner_ad_model.dart';
import '../ads/rewarded_ad_model.dart';
import '../controller/level_controller.dart';
import '../widgets/bottons_joypad.dart';
import '../widgets/food_pixel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key,
      required this.rowSize,
      required this.totalNumberOfSquares,
      required this.milliseconds,
      required this.nbObstacle,
      this.outline = false,
      required this.level})
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
  final LevelController _levelController = Get.find<LevelController>();
  final SettingsController _settingsController = Get.put(SettingsController());

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//grid dimensions

  //snake position
  List<int> snakePos = [];

  //obstacle position
  List<int> obstaclePixel = [];

//snake direction is initially to the right
  var currentDirection = snakeDirection.RIGHT;

//food position
  late int foodPos;
  int currentScore = 0;
  int scoreMax = 0;

  bool stopTimer = false;
  final player = AudioCache();

  @override
  void initState() {
    foodPos = (4 * widget.rowSize) + 5;
    getScoreMax();

    if (widget.outline) {
      snakePos = [widget.rowSize + 1, widget.rowSize + 2, widget.rowSize + 3];
    } else {
      snakePos = [0, 1, 2];
    }

    outlineConstruction();
    randomObstacle();
    _settingsController.getSettings();
  }

  Future<void> initPlayerSound() async {}

//start the game
  void startGame() {
    AdRewarded.loadAd();
    AdIntertitiel.loadAd();
    stopTimer = false;
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
          showGameOverDialog();
        }
      });
    });
  }

  showGameOverDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Center(
                child: Text("REWIND ?",
                    style: TextStyle(
                      color: Colors.grey,
                    ))),
            content: SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  children: [
                    MaterialButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      color:
                          snakePos.length <= 2 ? Colors.grey[400] : Colors.pink,
                      onPressed: () {
                        if (snakePos.length > 2) {
                          AdRewarded.showAd();

                          gameHasStarted = false;

                          setState(() {
                            snakePos.remove(snakePos.last);
                          });

                          Navigator.pop(context);
                        }
                      },
                      child: snakePos.length <= 2
                          ? const Text("You can't\n rewind")
                          : Column(
                              children: const [
                                Text(
                                  "Yes",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Watch a\nshort video",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      color: Colors.pink,
                      onPressed: () {
                        AdIntertitiel.showAd();
                        restartGame();

                        Navigator.pop(context);
                      },
                      child: Column(
                        children: const [
                          Text(
                            "No",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Giv up and\nstart again",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  showPauseDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Center(
                child: Text("PAUSED ",
                    style: TextStyle(
                      color: Colors.grey,
                    ))),
            content: SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const LevelScreen());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                        child: const Icon(Icons.home),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        restartGame();
                        //gameHasStarted=false;
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                        child: const Icon(Icons.replay),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        startGame();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                        child: const Icon(Icons.play_arrow),
                      ),
                    ),
                  ],
                )),
          );
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

      playSound("sound.wav");
      changeFoodPos();
    } else {
      //remove the tail
      snakePos.removeAt(0);
    }
  }

  void playSound(String soundAsset) {
    if (_settingsController.sound!) {
      player.play(soundAsset);
    }
  }

  void vibration() {
    if (_settingsController.vibration!) {
      HapticFeedback.heavyImpact();
    }
  }

  void changeFoodPos() {
    //making sure the new food is not where the snake is
    while (snakePos.contains(foodPos) || obstaclePixel.contains(foodPos)) {
      foodPos = Random().nextInt(widget.totalNumberOfSquares);
    }
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
      playSound("game_over.wav");
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
    final pref = await SharedPreferences.getInstance();
    setState(() {
      scoreMax = pref.getInt('${widget.level}') ?? 0;
    });
  }

  Future<void> setMaxScore() async {
    final pref = await SharedPreferences.getInstance();

    if (currentScore > scoreMax) {
      pref.setInt("${widget.level}", currentScore);
      scoreMax = pref.getInt('${widget.level}') ?? 0;
      _levelController.setNbStart(
          widget.totalNumberOfSquares, widget.level, scoreMax);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          AdIntertitiel.loadAd();
          stopTimer = true;
          return true;
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.black,
          body: RawKeyboardListener(
            focusNode: FocusNode(),
            autofocus: true,
            onKey: (event) {
              vibration();
              if (event.character.toString() == 'z' &&
                  currentDirection != snakeDirection.DOWN) {
                currentDirection = snakeDirection.UP;
              } else if (event.character.toString() == 'q' &&
                  currentDirection != snakeDirection.RIGHT) {
                currentDirection = snakeDirection.LEFT;
              } else if (event.character.toString() == 'd' &&
                  currentDirection != snakeDirection.LEFT) {
                currentDirection = snakeDirection.RIGHT;
              } else if (event.character.toString() == 'b' &&
                  currentDirection != snakeDirection.UP) {
                currentDirection = snakeDirection.DOWN;
              }
            },
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shield_sharp),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            scoreMax.toString(),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      MaterialButton(
                        
                        onPressed: () {
                          stopTimer = true;
                          if(!gameOver()){
                              showPauseDialog();
                          }
                         
                        },
                        child: const Icon(Icons.pause),
                      ),
                      Text(
                        currentScore.toString(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom:
                            BorderSide(width: 2.0, color: Colors.grey.shade900),
                      )),
                      child: GestureDetector(
                        onVerticalDragUpdate: (details) {
                          if (_settingsController.controls == 'Swipe') {
                            if (!gameHasStarted) {
                              startGame();
                            }
                            vibration();
                            if (details.delta.dy > 0 &&
                                currentDirection != snakeDirection.UP) {
                              currentDirection = snakeDirection.DOWN;
                            } else if (details.delta.dy < 0 &&
                                currentDirection != snakeDirection.DOWN) {
                              currentDirection = snakeDirection.UP;
                            }
                          }
                        },
                        onHorizontalDragUpdate: (details) {
                          if (_settingsController.controls == 'Swipe') {
                            if (!gameHasStarted) {
                              startGame();
                            }
                            vibration();
                            if (details.delta.dx > 0 &&
                                currentDirection != snakeDirection.LEFT) {
                              currentDirection = snakeDirection.RIGHT;
                            } else if (details.delta.dx < 0 &&
                                currentDirection != snakeDirection.RIGHT) {
                              currentDirection = snakeDirection.LEFT;
                            }
                          }
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: GridView.builder(
                                  itemCount: widget.totalNumberOfSquares,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
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
                            ),
                            _settingsController.controls == 'Swipe'
                                ? Image.asset(
                                    "assets/icons/drag.png",
                                    height: 100,
                                    width: 100,
                                  )
                                : ButtonsJoyPad(
                                    onTapDown: () {
                                      vibration();
                                      if (!gameHasStarted) {
                                        startGame();
                                      }
                                      if (currentDirection !=
                                          snakeDirection.UP) {
                                        currentDirection = snakeDirection.DOWN;
                                      }
                                        
                                    },
                                    onTapUp: () {
                                      if (!gameHasStarted) {
                                        startGame();
                                      }
                                      vibration();
                                      if (currentDirection !=
                                          snakeDirection.DOWN) {
                                        currentDirection = snakeDirection.UP;
                                      }
                                        
                                    },
                                    onTapRight: () {
                                      if (!gameHasStarted) {
                                        startGame();
                                      }
                                      vibration();
                                      if (currentDirection !=
                                          snakeDirection.LEFT) {
                                        currentDirection = snakeDirection.RIGHT;
                                      }
                                     
                                    },
                                    onTapLeft: () {
                                      if (!gameHasStarted) {
                                        startGame();
                                      }
                                      vibration();
                                      if (currentDirection !=
                                          snakeDirection.RIGHT) {
                                        currentDirection = snakeDirection.LEFT;
                                      }
                                        
                                    },
                                  ),
                            // Icon(Icons.drag)
                          ],
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 35,
                ),
                const AdBanner(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
