import 'dart:io';

import 'package:flutter/foundation.dart';

const testBannerId = 'ca-app-pub-3940256099942544/6300978111';
const androidBannerId = 'ca-app-pub-8225784208582563/5675537622';
const androidNativeId = 'ca-app-pub-8225784208582563/1082644359';
const iosBannerId = 'ca-app-pub-8225784208582563/9912265724';
const iosNativeId = 'ca-app-pub-8225784208582563/7770152265';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode ? testBannerId : androidBannerId;
    } else if (Platform.isIOS) {
      return kDebugMode ? testBannerId : iosBannerId;
    }
    throw new UnsupportedError("Unsupported platform");
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return androidNativeId;
    } else {
      if (Platform.isIOS) {
        return iosNativeId;
      }
    }
    throw new UnsupportedError("Unsupported platform");
  }
}
