import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdsService {
  RewardedAdsService._();
  static final RewardedAdsService instance = RewardedAdsService._();

  RewardedAd? _rewardedAd;
  bool _isLoading = false;

  // استخدم Ad Unit الحقيقي في الريليس، و Test ID في الديبج
  static const _realUnitId = 'ca-app-pub-7223929122163665/9327150128';
  static const _testUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Rewarded Test

  String get _adUnitId => kReleaseMode ? _realUnitId : _testUnitId;

  Future<void> preload() async {
    if (_isLoading || _rewardedAd != null) return;
    _isLoading = true;
    await RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (err) {
          _rewardedAd = null;
          _isLoading = false;
          if (kDebugMode) {
            debugPrint('Rewarded load failed: ${err.code} - ${err.message}');
          }
        },
      ),
    );
  }

  /// يعرض الإعلان ويرجع true لو المستخدم حصل على المكافأة
  Future<bool> show() async {
    // لو مش محمّل، حاول تحميله سريعًا
    if (_rewardedAd == null) {
      await preload();
      if (_rewardedAd == null) return false;
    }

    final completer = Completer<bool>();
    bool earned = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {},
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null; // حضّر للإعلان التالي
        // حمّل إعلان جديد للخدمة
        preload();
        // لو اتقفل ومكسبناش، هنكمل false
        if (!completer.isCompleted) completer.complete(earned);
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _rewardedAd = null;
        preload();
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (ad, rewardItem) {
      earned = true; // المستخدم شاهد الإعلان لحد المكافأة
    });

    return completer.future;
  }
}
