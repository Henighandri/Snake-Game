import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:snake_game/ads/ad_helper.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({Key? key}) : super(key: key);

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? bannerAd;
  bool _isAdReady = false;
  final AdSize _adSize = AdSize.banner;

  void _createBannerAd() {
    bannerAd = BannerAd(
        size: _adSize,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isAdReady = true;
              });
            },
            onAdFailedToLoad: (ad, error) {}),
        request: const AdRequest());

    bannerAd!.load();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createBannerAd();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bannerAd!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdReady
        ? Container(
            width: _adSize.width.toDouble(),
            height: _adSize.height.toDouble(),
            alignment: Alignment.center,
            child: AdWidget(ad: bannerAd!),
          )
        : const SizedBox();
  }
}
