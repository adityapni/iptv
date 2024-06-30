import 'dart:convert';

import 'package:OOHLIVETV_iptv/repository/api/ads.dart';
import 'package:OOHLIVETV_iptv/repository/models/ads.dart';
import 'package:flutter/foundation.dart';

class AdsLocale {
  final AdsApi _adsApi;
  AdsLocale(this._adsApi);

  Future<Map<String, dynamic>> getRandomAd({required double width}) async {
    if (kDebugMode) {
      print('getRandomAd() Called In AdsLocale');
    }
    var adsRes = await _adsApi.getRandomAd(width: width);
    try {
      if (adsRes['status']) {
        final results = jsonDecode(adsRes['res'])['customizedAds'];
        adsRes['ads'] = Ads.fromJson(results);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      adsRes['status'] = false;
      adsRes['msg'] = 'SomeThing Went Wrong';
    }
    return adsRes;
  }
}