import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quaderno_flutter/utils/ad_helper.dart';

class QuadernoBannerAd extends StatefulWidget {
  @override
  _QuadernoBannerAdState createState() => _QuadernoBannerAdState();
}

class _QuadernoBannerAdState extends State<QuadernoBannerAd> {
  late BannerAd _ad;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: AdWidget(ad: _ad),
      width: _ad.size.width.toDouble(),
      height: _ad.size.height.toDouble(),
    );
  }

  @override
  void dispose() {
    _ad.dispose();

    super.dispose();
  }
}
