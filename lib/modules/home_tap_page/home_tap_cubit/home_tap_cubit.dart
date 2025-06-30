import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:ntp/ntp.dart';
import 'package:vo_ninja/models/level_progress_model.dart';
import 'package:vo_ninja/models/user_data_model.dart';
import '../../../generated/l10n.dart';
import '../../../shared/constant/constant.dart';
import 'home_tap_state.dart';
import 'dart:async';
import 'dart:developer';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class HomeTapCubit extends Cubit<HomeTapState> {
  HomeTapCubit() : super(HomeTapLoading());

  static HomeTapCubit get(context) {
    return BlocProvider.of(context);
  }

  DateTime? lastBackPressTime = DateTime.now();
  RewardedAd? rewardedAd;
  bool isAdShowing = false;
  bool isProfileIconEnabled = true;
  UserDataModel? userData;
  List<LevelsProgressData> levelsData = [];



  Future<Map<String, dynamic>> showAds(String? uid) async {
    if (uid == null) {
      return {
      'success': false,
      'title': 'Error',
      'message': 'User ID is missing'
    };
    }

    if (rewardedAd == null || !isProfileIconEnabled) {
      return {
        'success': false,
        'title': 'Error',
        'message': 'Ad is not ready now try again later'
      };
    }

    try {
      DocumentReference userDocRef = fireStore.collection('users').doc(uid);
      DocumentSnapshot userDoc = await userDocRef.get();

      final now = await NTP.now();
      final today = DateTime(now.year, now.month, now.day);

      int adsViewedToday = 0;
      DateTime? lastAdDate;

      if (userDoc.exists && userDoc.data() != null) {
        var data = userDoc.data() as Map<String, dynamic>;
        lastAdDate = data['lastAdDate']?.toDate();
        adsViewedToday = data['adsViewedToday'] ?? 0;
      }

      // إذا كان اليوم مختلفاً، نعيد العداد إلى الصفر
      if (lastAdDate == null || lastAdDate.isBefore(today)) {
        adsViewedToday = 0;
      }

      // التحقق من تجاوز الحد اليومي
      if (adsViewedToday >= 10) {
        return {
          'success': false,
          'title': 'Limit Reached',
          'message': 'You have reached the daily ads limit (10 ads). Please try again tomorrow.'
        };
      }

      isAdShowing = true;

      rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
          try {
            await userDocRef.update({
              'pointsNumber': FieldValue.increment(10),
              'adsViewedToday': (lastAdDate == null || lastAdDate.isBefore(today))?1:FieldValue.increment(1),
              'lastAdDate': Timestamp.fromDate(now),
            });

            await getUserData(uid);
            await getUserRank(uid);
            emit(HomeTapLoaded(userData!, levelsData));
          } catch (e) {
            log('Error in onUserEarnedReward: $e');
          }
        },
      );

      rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          rewardedAd!.dispose();
          rewardedAd = null;
          loadRewardAds();
          isAdShowing = false;
          _disableProfileIconTemporarily();
          emit(HomeTapLoaded(userData!, levelsData));
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          log('Ad failed to show: $error');
          rewardedAd!.dispose();
          rewardedAd = null;
          loadRewardAds();
          isAdShowing = false;
          _disableProfileIconTemporarily();
          emit(HomeTapLoaded(userData!, levelsData));
        },
      );

      return {
        'success': true,
        'title': 'Success',
        'message': '10 points added successfully!'
      };
    } catch (e) {
      log('Error showing ad: $e');
      return {
        'success': false,
        'title': 'Error',
        'message': 'An error occurred. Please try again.'
      };
    }
  }

  void _disableProfileIconTemporarily() {
    isProfileIconEnabled = false; // Disable the icon
    emit(HomeTapLoaded(userData!, levelsData)); // Update the state

    // Re-enable the icon after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      isProfileIconEnabled = true; // Re-enable the icon
      log('10 seconds ');
      emit(HomeTapLoaded(userData!, levelsData)); // Update the state again
    });
  }

  void loadRewardAds() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-7223929122163665/9327150128',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          log('Rewarded ad loaded successfully');
          emit(HomeTapLoaded(userData!, levelsData));
        },
        onAdFailedToLoad: (error) {
          log('Rewarded ad failed to load: $error');
          rewardedAd = null;
          emit(HomeTapLoaded(userData!, levelsData));
        },
      ),
    );
  }

// BannerAd? _bannerAd;

// void loadBannerAd() {
//   _bannerAd = BannerAd(
//     adUnitId: 'ca-app-pub-5312931470035704/5179298778',
//     size: AdSize.banner,
//     request: const AdRequest(),
//     listener: BannerAdListener(
//       onAdLoaded: (_) {
//         log('Banner ad loaded successfully');
//         emit(state);
//       },
//       onAdFailedToLoad: (Ad ad, LoadAdError error) {
//         log('Banner ad failed to load: $error');
//         ad.dispose();
//         emit(state);
//       },
//     ),
//   )..load();
// }

// Widget buildBannerAd() {
//   if (_bannerAd == null) {
//     return const SizedBox(); // Return an empty widget if the ad isn't loaded
//   }
//   return SizedBox(
//     height: _bannerAd!.size.height.toDouble(),
//     width: _bannerAd!.size.width.toDouble(),
//     child: AdWidget(ad: _bannerAd!),
//   );
// }

  // Future<void> getHome() async {
  //   try {
  //     emit(HomeTapLoading());

  //     final userData = UserDataModel(
  //       pointsNumber: 1000,
  //       rankNumber: 50000,
  //       userName: "salahhossam",
  //     );
  //     final levelsData = [
  //       LevelsProgressData(courseLevel: "Basic", coursePercentage: 0.6),
  //       LevelsProgressData(courseLevel: "Intermediate", coursePercentage: 0.3),
  //       LevelsProgressData(courseLevel: "Advanced", coursePercentage: 0.3),
  //     ];

  //     emit(HomeTapLoaded(userData, levelsData));
  //   } catch (e) {
  //     emit(HomeTapError('Failed to load data'));
  //   }
  // }

  Future<void> getUserData(String uid) async {
    emit(HomeTapLoading());
    try {
      var response = await fireStore.collection(USERS).doc(uid).get();
      userData =
          UserDataModel.fromJson(response.data() as Map<String, dynamic>);
      emit(HomeTapLoaded(userData!, levelsData));
    } catch (error) {
      emit(HomeTapError(error.toString()));
    }
  }

  Future<void> getLevelsDataProgress(String uid) async {
    emit(HomeTapLoading());
    try {
      levelsData = [];
      QuerySnapshot levelsSnapshot = await fireStore.collection('levels').get();

      for (var doc in levelsSnapshot.docs) {
        String levelId = doc.id;
        String levelDifficulty =
            doc['difficulty']; // Assuming this exists in Firestore

        // Count the number of answers the user has for this level
        AggregateQuerySnapshot answersCountSnapshot = await fireStore
            .collection('users')
            .doc(uid)
            .collection('answers')
            .where('levelId', isEqualTo: levelId)
            .count()
            .get();

        int? answeredQuestions = answersCountSnapshot.count;
        int totalQuestions =
            doc['totalQuestions']; // Ensure this exists in Firestore
        double levelProgress = 0.0;
        if (answeredQuestions != null) {
          levelProgress =
              totalQuestions > 0 ? (answeredQuestions / totalQuestions) : 0.0;
        }

        levelsData.add(LevelsProgressData(
            levelId: levelId,
            levelDifficulty: levelDifficulty,
            levelProgress: double.parse(levelProgress.toStringAsFixed(2))));
      }

      emit(HomeTapLoaded(userData!, levelsData));
    } catch (error) {
      emit(HomeTapError(error.toString()));
    }
  }

  double rank = 0;

  Future<void> getUserRank(String uid) async {
    emit(HomeTapLoading());
    try {
      double? userPoints = userData?.pointsNumber;

      // Count how many users have more points than this user
      final querySnapshot = await fireStore
          .collection(USERS)
          .where('pointsNumber', isGreaterThan: userPoints)
          .count()
          .get();

      rank = (querySnapshot.count ?? 0) + 1;

      emit(HomeTapRankLoaded(rank));
    } catch (e) {
      emit(HomeTapError(e.toString()));
    }
  }

  // Future<void> getUserRank(String uid) async {
  //   emit(HomeTapLoading());
  //   try {
  //     double? userPoints = userData?.pointsNumber;
  //
  //     final querySnapshot = await fireStore
  //         .collection(USERS)
  //         .where('pointsNumber', isGreaterThan: userPoints)
  //         .get();
  //
  //     Set<double> uniqueHigherPoints = querySnapshot.docs
  //         .map((doc) => doc['pointsNumber'].toDouble() as double)
  //         .toSet();
  //
  //     rank = uniqueHigherPoints.length + 1;
  //
  //     emit(HomeTapRankLoaded(rank));
  //   } catch (e) {
  //     emit(HomeTapError(e.toString()));
  //   }
  // }

  bool doubleBack(BuildContext context) {
    DateTime now = DateTime.now();
    if (lastBackPressTime == null ||
        now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
      lastBackPressTime = now;
      showToast(
        S.of(context).exit,
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        position: const StyledToastPosition(
          align: Alignment.bottomCenter,
          offset: 40,
        ),
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 3),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );
      return false;
    }
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
    return true;
  }

  Future<void> updateQuestionCounts() async {
    String levelId = "FsJrCVNOxFBcOYRigt2X"; // Your level ID
    CollectionReference advancedLevelRef =
        fireStore.collection("levels").doc(levelId).collection("lessons");

    int totalQuestions = 0;

    // Get all documents in advancedLevel
    QuerySnapshot advancedLevelDocs = await advancedLevelRef.get();

    for (QueryDocumentSnapshot advancedDoc in advancedLevelDocs.docs) {
      String advancedDocId = advancedDoc.id;

      // Get the number of questions in the subcollection
      QuerySnapshot questionDocs = await advancedLevelRef
          .doc(advancedDocId)
          .collection("questions")
          .get();

      int numQuestions = questionDocs.size;

      // Update each document in advancedLevel with numQuestions
      await advancedLevelRef.doc(advancedDocId).update({
        "numQuestions": numQuestions,
      });

      totalQuestions += numQuestions;
    }

    // Update the total number of questions in the main collection
    await fireStore.collection("levels").doc(levelId).update({
      "totalQuestions": totalQuestions,
    });

    print("Updated successfully!");
  }

  Future<void> updateLevelCount() async {
    try {
      String levelDocId = 'FsJrCVNOxFBcOYRigt2X';

      // Count the number of documents in the 'advancedLevel' subcollection
      AggregateQuerySnapshot countSnapshot = await fireStore
          .collection('levels')
          .doc(levelDocId)
          .collection('lessons')
          .count()
          .get();

      int? advancedLevelCount = countSnapshot.count;

      // Update the parent document with the count
      await fireStore.collection('levels').doc(levelDocId).update({
        'totalLessons': advancedLevelCount,
      });

      print('Updated advancedLevelCount: $advancedLevelCount');
    } catch (error) {
      print('Error updating advancedLevelCount: $error');
    }
  }

// Future<void> answerRandomQuestions() async {
//   try {
//     int num=0;
//     const String userId = "WfBqFtPGqHTtA2wUxfyQ8vl7bIC2";
//     const String levelId = "x70tphfutoVekFDeo0mQ"; // Level ID
//     // Fetch all lessons inside the level
//     QuerySnapshot lessonsSnapshot = await fireStore
//         .collection("challenges")
//         .doc(levelId)
//         .collection("tasks")
//         .get();
//
//     for (var lessonDoc in lessonsSnapshot.docs) {
//       num+=1;
//       String lessonId = lessonDoc.id;
//
//       // Fetch questions from each lesson
//       QuerySnapshot questionsSnapshot = await fireStore
//           .collection("challenges")
//           .doc(levelId)
//           .collection("tasks")
//           .doc(lessonId)
//           .collection("questions")
//           .get();
//
//       List<QueryDocumentSnapshot> questions = questionsSnapshot.docs;
//
//       // Determine a random number of questions to answer
//       int numQuestionsToAnswer = 10;
//
//       // Shuffle and pick random questions
//       questions.shuffle();
//       List<QueryDocumentSnapshot> selectedQuestions =
//           questions.take(numQuestionsToAnswer).toList();
//
//       for (var questionDoc in selectedQuestions) {
//         String questionId = questionDoc.id;
//         Map<String, dynamic> questionData =
//             questionDoc.data() as Map<String, dynamic>;
//
//         List<dynamic> choices = questionData["choices"] ?? [];
//         String correctedAnswer = questionData["correct_answer"] ?? "";
//
//         if (choices.isEmpty) continue;
//
//         // Pick a random answer
//         String selectedAnswer = choices[math.Random().nextInt(choices.length)];
//
//         // Check correctness
//         bool isCorrect = selectedAnswer == correctedAnswer;
//         int grade = isCorrect ? 5 : -3;
//
//         // Store the answer in the user's answers collection
//         await fireStore
//             .collection("users")
//             .doc(userId)
//             .collection("challengeAnswers")
//             .doc(questionId) // Use the question ID as document ID
//             .set({
//           "questionId": questionId,
//           "taskId": lessonId,
//           "challengeId": levelId,
//           "selectedAnswer": selectedAnswer,
//           "correct": isCorrect,
//           "grade": grade,
//         });
//       }
//       if(num>10) {
//         return;
//       }
//
//     }
//     print("finish successfully");
//   } catch (e) {
//     print("Error answering questions: $e");
//   }
// }

  Future<void> updateQuestionCounts2() async {
    String levelId = "x70tphfutoVekFDeo0mQ"; // Your level ID
    CollectionReference advancedLevelRef =
        fireStore.collection("challenges").doc(levelId).collection("tasks");

    int totalQuestions = 0;

    // Get all documents in advancedLevel
    QuerySnapshot advancedLevelDocs = await advancedLevelRef.get();

    for (QueryDocumentSnapshot advancedDoc in advancedLevelDocs.docs) {
      String advancedDocId = advancedDoc.id;

      // Get the number of questions in the subcollection
      QuerySnapshot questionDocs = await advancedLevelRef
          .doc(advancedDocId)
          .collection("questions")
          .get();

      int numQuestions = questionDocs.size;

      // Update each document in advancedLevel with numQuestions
      await advancedLevelRef.doc(advancedDocId).update({
        "numQuestions": numQuestions,
      });

      totalQuestions += numQuestions;
    }

    // Update the total number of questions in the main collection
    await fireStore.collection("challenges").doc(levelId).update({
      "totalQuestions": totalQuestions,
    });

    print("Updated successfully!");
  }
}
