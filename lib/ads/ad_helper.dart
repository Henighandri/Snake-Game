

class AdHelper{

static const bool testMode=true;


  static String get bannerAdUnitId{
    if(testMode){
      return "ca-app-pub-3940256099942544/6300978111";
    }else{
      return "ca-app-pub-3635966717377231/7836552714";
    }

  }
   static String get rewardAdUnitId{
    if(testMode){
      return "ca-app-pub-3940256099942544/5224354917";
    }else{
      return "ca-app-pub-3635966717377231/1583271021";
    }

  }
  static String get interstitielAdUnitId{
    if(testMode){
      return "ca-app-pub-3940256099942544/1033173712";
    }else{
      return "ca-app-pub-3635966717377231/3184089319";
    }

  }
}