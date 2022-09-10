import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/level.dart';

class LevelController extends GetxController {
  List<Level> levels = [];
  int nbLevel = 20;
  int totalStars = 0;


  getListLevel() async {
    final pref = await SharedPreferences.getInstance();
    List<Level> levelList = [];
    for (int i = 0; i < nbLevel; i++) {
      int scoreMax = pref.getInt('${i + 1}') ?? 0;
      int nbStars = calculNbStars((i + 9) * (i + 9), i + 1, scoreMax);
      // print(nbStars);
      levelList.add(Level(level: i + 1, maxScore: scoreMax, nbStars: nbStars));
      //  print("${levelList[i].level} :${levelList[i].maxScore}");
    }

    levels = levelList;

    update();
  }

  int calculNbStars(int totalNumberOfSquares, int level, int maxScore) {
    double facteur = (totalNumberOfSquares - (3 + level - 1)) / 8;
    // print(facteur);

    if (maxScore > facteur && maxScore <= 2 * facteur) {
      return 1;
    } else if (maxScore > 2 * facteur && maxScore <= 3 * facteur) {
      return 2;
    } else if (maxScore > 3 * facteur) {
      return 3;
    }
    return 0;
  }

  setNbStart(int totalNumberOfSquares, int level, int maxScore) {
    levels[level - 1].nbStars =
        calculNbStars(totalNumberOfSquares, level, maxScore);
    update();
  }

  getTotalStars() {
    int somStars = 0;
    for (int i = 0; i < levels.length; i++) {
      somStars = somStars + levels[i].nbStars!;
    }
    totalStars = somStars;

    update();
  }

}
