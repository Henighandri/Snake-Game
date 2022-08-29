import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreController extends GetxController{
   List<int> listScoreMax=[];
   
  getScoreMax(int level) async {
    final pref=await SharedPreferences.getInstance();
   int scoreMax = pref.getInt('$level') ?? 0;
   listScoreMax.add(scoreMax);
     update();
  }
  
}