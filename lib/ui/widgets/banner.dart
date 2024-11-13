import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../utils/ad_helper.dart';
import '../../utils/log_helper.dart';

class QuadernoBannerAd extends StatefulWidget {
  const QuadernoBannerAd({super.key});

  @override
  _QuadernoBannerAdState createState() => _QuadernoBannerAdState();
}

class _QuadernoBannerAdState extends State<QuadernoBannerAd> {
  late BannerAd _ad;

  @override
  void initState() {
    super.initState();

    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          QTLog.log(
              'Ad load failed (code=${error.code} message=${error.message})',
              name: 'widgets.banner');
        },
      ),
    );

    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: _ad.size.width.toDouble(),
      height: _ad.size.height.toDouble(),
      child: AdWidget(ad: _ad),
    );
  }

  @override
  void dispose() {
    _ad.dispose();

    super.dispose();
  }
}
