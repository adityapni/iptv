import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../helpers/helpers.dart';

String bannerUnitId = Platform.isAndroid
    ? "ca-app-pub-1001110363789350/2628383323" //TODO: Banner Android
    : "ca-app-pub-1001110363789350/2816085584"; //TODO: Banner IOS

String interstitialUnitId = Platform.isAndroid
    ? "ca-app-pub-1001110363789350/1047795695" //TODO: Interstitial Android
    : "ca-app-pub-3940256099942544/4411468910"; //TODO: Interstitial IOS

String rewardedUnitId = Platform.isAndroid
    ? "ca-app-pub-3940256099942544/5224354917" //TODO: Rewarded Android
    : "ca-app-pub-3940256099942544/1712485313"; //TODO: Rewarded IOS

class AdmobWidget {
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  final int _maxFailedLoadAttempts = 3;

  static getBanner() {
    if (!showAds) {
      return const SizedBox(height: 10);
    }

    final BannerAdListener listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        debugPrint("Banner Loaded");
        // isLoaded = true;
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        debugPrint('Ad failed to load: $error');
        // isLoaded = false;
      },
    );

    final BannerAd myBanner = BannerAd(
      adUnitId: bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: listener,
    );

    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
      child: Center(child: adWidget),
    );
  }

  void createRewardedAd() {
    if (!showAds) return;
    final RewardedAdLoadCallback rewardedAdLoadCallback = RewardedAdLoadCallback(
      onAdLoaded: (RewardedAd ad) {
        debugPrint('RewardedAd loaded');
        _rewardedAd = ad;
        _numRewardedLoadAttempts = 0;
      },
      onAdFailedToLoad: (LoadAdError error) {
        if (kDebugMode) {
          print('RewardedAd failed to load: $error');
        }
        _rewardedAd = null;
        _numRewardedLoadAttempts += 1;
        if (_numRewardedLoadAttempts <= _maxFailedLoadAttempts) {
          createRewardedAd();
        }
      },
    );
    RewardedAd.load(
        adUnitId: rewardedUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: rewardedAdLoadCallback
    );
  }

  void showRewardedAd() {
    if (_rewardedAd == null) {
      debugPrint('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          debugPrint('RewardedAd onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) async {
        debugPrint('$ad onAdDismissedFullScreenContent. ');
        ad.dispose();
        createRewardedAd();
        // Navigator.pushNamed(context, QuestionIndexScreen.id,
        //     arguments: _competition);
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedAd();
      },
    );
    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
      debugPrint(
          '************************************* watched the ad ***************************************');
      debugPrint('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
    });
    _rewardedAd = null;
  }

}
