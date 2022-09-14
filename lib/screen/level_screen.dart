import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snake_game/ads/interstitiel_ad_model.dart';
import 'package:snake_game/models/level.dart';
import 'package:snake_game/screen/setting_screen.dart';
import 'package:snake_game/widgets/Stars.dart';

import 'package:snake_game/screen/home_page.dart';

import '../ads/banner_ad_model.dart';
import '../ads/rewarded_ad_model.dart';
import '../controller/level_controller.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({Key? key}) : super(key: key);

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final LevelController _levelController = Get.put(LevelController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AdRewarded.loadAd();
    AdIntertitiel.loadAd();
    init();
  }

  init() async {
    await _levelController.getListLevel();
    _levelController.getTotalStars();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            
            leading: GestureDetector(
                onTap: () {
                  Get.to(() => SettingScreen());
                },
                child: const Icon(Icons.settings)),
            title:  Text("Levels",
                style:  Theme.of(context).textTheme.headline5
                ),
            centerTitle: true,
            actions: [
              Center(
                child: GetBuilder<LevelController>(builder: (_) {
                  return Text(
                    _levelController.totalStars.toString(),
                    style:  Theme.of(context).textTheme.bodyText1
                   
                  );
                }),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                Icons.star,
                size: 30,
                color: Color.fromRGBO(255, 179, 0, 1),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                  onTap: () {
                    showCustomDialog();
                  },
                  child: const Icon(Icons.add_circle_outline)),
                  const SizedBox(
                width: 5,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
               
                Expanded(
                  flex: 5,
                  child: GetBuilder<LevelController>(builder: (_) {
                    return Center(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: _levelController.levels.isNotEmpty
                                ? GridView.builder(
                                    itemCount: _levelController.levels.length,
                                    //  physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemBuilder: (context, index) {
                                      return LevelItem(
                                        level: _levelController.levels[index],
                                      );
                                    })
                                : const CircularProgressIndicator()));
                  }),
                ),
                const SizedBox(
                  height: 35,
                ),
                const AdBanner(),
              ],
            ),
          )),
    );
  }

  showCustomDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              Container(
                width: double.infinity,
                color: Colors.pink,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: FlatButton(
                    child: const Text(
                      'Ok',
                      style: TextStyle( fontSize: 20),
                    ),
                    onPressed: () {
                      AdRewarded.showAd(true);
                      //AdRewarded.loadAd();
                      Navigator.of(context).pop();
                    }),
              )
            ],
            actionsAlignment: MainAxisAlignment.center,
            backgroundColor: Colors.white70,
            titleTextStyle: TextStyle(),
            //title: const Text("level closed",style: TextStyle(color: Colors.black,fontSize: 25),),
            content: Container(
                height: 100,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Watch ashort video \nand get a star",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                )),
          );
        });
  }
}

class LevelItem extends StatefulWidget {
  const LevelItem({Key? key, required this.level}) : super(key: key);
  final Level level;

  @override
  State<LevelItem> createState() => _LevelItemState();
}

class _LevelItemState extends State<LevelItem> {
  final LevelController _levelController = Get.find<LevelController>();
  int rowSize = 0;
  int totalNumberOfSquares = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rowSize = widget.level.level! + 9;
    totalNumberOfSquares =
        (widget.level.level! + 9) * (widget.level.level! + 9);
    //
  }

  showCustomDialog() {
    showDialog(
        context: context,
        builder: (context) {
          int requiredStar = (widget.level.level! - 1) * 2;
          return AlertDialog(
            actions: [
              Container(
                width: double.infinity,
                color: Colors.black,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: FlatButton(
                    child: const Text(
                      'Ok',
                      style: TextStyle( fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              )
            ],
            actionsAlignment: MainAxisAlignment.center,
            backgroundColor: Colors.white70,
            titleTextStyle: TextStyle(),
            //title: const Text("level closed",style: TextStyle(color: Colors.black,fontSize: 25),),
            content: Container(
                height: 100,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock,
                      color: Colors.black,
                      size: 40,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "You should get $requiredStar stars",
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: GestureDetector(
        onTap: () {
          if (_levelController.totalStars >= (widget.level.level! - 1) * 2) {
            if (AdIntertitiel.nbShow == 2) {
              AdIntertitiel.showAd();
              AdIntertitiel.nbShow = 0;
            } else {
              AdIntertitiel.nbShow++;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(
                        rowSize: rowSize,
                        totalNumberOfSquares: totalNumberOfSquares,
                        milliseconds: widget.level.level! < 10
                            ? 250 - (widget.level.level! * 10)
                            : 100,
                        nbObstacle: widget.level.level! < 10
                            ? widget.level.level! - 1
                            : widget.level.level! - 10,
                        level: widget.level.level!,
                        outline: widget.level.level! > 9,
                      )),
            );
          } else {
            showCustomDialog();
          }
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 2, color:Theme.of(context).primaryColor )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.level.level}",
                style: const TextStyle( fontSize: 40),
              ),
              Stars(
                nbStars: widget.level.nbStars!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
