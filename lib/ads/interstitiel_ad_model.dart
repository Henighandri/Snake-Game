import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:snake_game/ads/ad_helper.dart';

class AdIntertitiel {
  static InterstitialAd? _interstitialAd;
  static bool _isAdReady =false;

  static int nbShow=0;
  
  static void loadAd() {
     InterstitialAd.load(
  adUnitId: AdHelper.interstitielAdUnitId,
  request: const AdRequest(),
  adLoadCallback: InterstitialAdLoadCallback(
    onAdLoaded: (InterstitialAd ad) {
      // Keep a reference to the ad so you can show it later.
      _interstitialAd = ad;
      _isAdReady=true;
    },
    onAdFailedToLoad: (LoadAdError error) {
      print('InterstitialAd failed to load: $error');
    },
  ));
  }

  static void showAd(){
    if(_isAdReady){
     _interstitialAd!.show();
    }
  }


}
