import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:snake_game/ads/ad_helper.dart';

class AdRewarded {
  static RewardedAd? _rewardedAd;
  static bool _isAdReady =false;
  static int amount=0;

  static void loadAd() {
    RewardedAd.load(
        adUnitId: AdHelper.rewardAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _isAdReady=true;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
          },
        ));
  }

  static void showAd(){
    if(_isAdReady){
      _rewardedAd!.show(
        onUserEarnedReward: (ad,reward){
            amount=reward.amount.toInt();
        });
    }
  }


}
