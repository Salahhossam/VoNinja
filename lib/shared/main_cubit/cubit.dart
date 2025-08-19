import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constant/constant.dart';
import '../network/local/cash_helper.dart';
import 'states.dart';

class MainAppCubit extends Cubit<MainAppState> {
  MainAppCubit() : super(InitialMainAppState());

  static MainAppCubit get(context) {
    return BlocProvider.of(context);
  }

  String language = 'en';

  void changeLanguage(String newLanguage) {
    language = newLanguage;
    CashHelper.saveData(key: 'language', value: language);

    emit(ChangeLanguageSuccessStates());
  }

  void rewardedInterstitialAd(String? uid) {
    // RewardedInterstitialAd.load(
    //   adUnitId: 'ca-app-pub-7223929122163665/2103266220',
    //   request: const AdRequest(),
    //   rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
    //     onAdLoaded: (ad) {
    //       log('InterstitialAd loaded successfully');
    //       ad.show(
    //         onUserEarnedReward: (ad, reward) async {
    //           DocumentReference userDocRef =
    //               fireStore.collection('users').doc(uid);
    //
    //           // Get the current pointsNumber and update it without a transaction
    //           DocumentSnapshot userDoc = await userDocRef.get();
    //           double adReward = 20;
    //
    //           if (userDoc.exists && userDoc.data() != null) {
    //             var data = userDoc.data() as Map<String, dynamic>;
    //             if (data.containsKey('pointsNumber')) {
    //               adReward =
    //                   ((data['pointsNumber'] as num) + adReward).toDouble();
    //             }
    //           }
    //
    //           await userDocRef.update({'pointsNumber': adReward});
    //
    //           log('User earned reward: ${reward.amount} ${reward.type}');
    //         },
    //       );
    //     },
    //     onAdFailedToLoad: (error) {
    //       log('Failed to load Rewarded Interstitial Ad: $error');
    //     },
    //   ),
    // );
  }

  void interstitialAd() {
    // InterstitialAd.load(
    //   adUnitId: 'ca-app-pub-7223929122163665/6066561966',
    //   request: const AdRequest(),
    //   adLoadCallback: InterstitialAdLoadCallback(
    //     onAdLoaded: (InterstitialAd ad) {
    //       log('InterstitialAd loaded successfully');
    //
    //       ad.show();
    //     },
    //     onAdFailedToLoad: (LoadAdError error) {
    //       log('InterstitialAd failed to load: $error');
    //     },
    //   ),
    // );
  }



  void rewardAds() {
    // RewardedAd.load(
    //   adUnitId: 'ca-app-pub-7223929122163665/9327150128',
    //   request: const AdRequest(),
    //   rewardedAdLoadCallback: RewardedAdLoadCallback(
    //     onAdLoaded: (ad) {
    //       log('InterstitialAd loaded successfully');
    //       ad.show(
    //         onUserEarnedReward: (ad, reward) async {
    //           log('User earned reward: ${reward.amount} ${reward.type}');
    //         },
    //       );
    //     },
    //     onAdFailedToLoad: (error) {
    //       log('Failed to load Rewarded Interstitial Ad: $error');
    //     },
    //   ),
    // );
  }
}
