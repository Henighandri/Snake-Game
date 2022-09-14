import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:snake_game/ads/ad_helper.dart';
import 'package:snake_game/controller/level_controller.dart';

class AdRewarded {
  static RewardedAd? _rewardedAd;
  static bool isAdReady =false;
 

  static void loadAd() {
    
    RewardedAd.load(
        adUnitId: AdHelper.rewardAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            isAdReady=true;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
          },
        ));
  }

  static void showAd(bool addStar){
    LevelController levelController=Get.find<LevelController>();
    
    if(isAdReady){
      _rewardedAd!.show(
        onUserEarnedReward: (ad,reward) async {
          isAdReady=false;
           double amount=reward.amount/10;
           
            if(addStar){
           await levelController.incrementNbStarFromAd(amount.toInt());
            levelController.getTotalStars();
            }
            
        });
    }
 
  }


}
