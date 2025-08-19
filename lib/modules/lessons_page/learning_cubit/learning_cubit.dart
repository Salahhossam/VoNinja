import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vo_ninja/models/lesson_details_model.dart';
import 'package:vo_ninja/modules/lessons_page/learning_cubit/learning_state.dart';
import 'package:vo_ninja/shared/constant/constant.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../end_exam_learning.dart';
import '../end_learning.dart';
import '../lessons_page.dart';

class LearningCubit extends Cubit<LearningState> {
  LearningCubit() : super(LearningInitial());
  static LearningCubit get(context) {
    return BlocProvider.of(context);
  }

  LessonDetails? lessonDetails;
  int currentVocabIndex = 0;
  int currentQuestionIndex = 0;
  int? selectedOption;
  bool isAnswered = false;
  final FlutterTts flutterTts = FlutterTts();
  bool isEnglish = true;

  List<Map<String, dynamic>> previousAnswers = [];
  void toggleLanguage() {
    isEnglish = !isEnglish;
    emit(LearningUpdated());
  }

  Future<void> speak(String text, String language) async {
    await flutterTts.setLanguage(language);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void moveToNextQuestion(
    context,
    double userPoints,
    String lessonId,
    String levelId,
    double page,
    double size,
    double order,
    String collectionName,
    double rewardedPoints,
      int numberOfLessons,
      bool isLastExam,

  ) {
    if (lessonDetails != null &&
        currentQuestionIndex < lessonDetails!.questions!.length - 1) {
      currentQuestionIndex++;
      selectedOption = null;
      isAnswered = false;
      emit(LearningUpdated());
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => EndExamLearning(
                  userPoints: userPoints,
                  lessonId: lessonId,
                  levelId: levelId,
                  page: page,
                  size: size,
                  order: order,
                  collectionName: collectionName,
                  rewardedPoints: rewardedPoints,
                   numberOfLessons: numberOfLessons, isLastExam: isLastExam,
                )),
      );
    }
  }

  void moveToPastQuestion(
    context,
    double userPoints,
    String lessonId,
    String levelId,
    double page,
    double size,
    double order,
    String collectionName,
    double rewardedPoints,
      int numberOfLessons,
  ) {
    if (lessonDetails != null && currentQuestionIndex != 0) {
      currentQuestionIndex--;
      selectedOption = null;
      isAnswered = false;
      emit(LearningUpdated());
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => LessonsPage(
                  levelId: levelId,
                  page: page,
                  size: size,
                  collectionName: collectionName,
                  rewardedPoints: rewardedPoints,
                   numberOfLessons: numberOfLessons,
                )),
      );
    }
  }

  void selectOption(int index) {
    selectedOption = index;
    emit(LearningUpdated());
  }

  Future<void> postUserExamAnswers(
      String uid,
      String lessonId,
      String questionId,
      String answer,
      bool correct,
      double grade,
      String levelId) async {
    emit(LearningLoading());
    try {
      // Store the answer in the user's answers collection
      await fireStore
          .collection('users')
          .doc(uid)
          .collection('answers')
          .doc(questionId)
          .set({
        'correct': correct,
        'grade': correct ? grade : -grade,
        'lessonId': lessonId,
        'levelId': levelId,
        'questionId': questionId,
        'selectedAnswer': answer,
      });

      // Reference to the user document
      DocumentReference userDocRef = fireStore.collection('users').doc(uid);

      // Get the current pointsNumber and update it without a transaction
      DocumentSnapshot userDoc = await userDocRef.get();
      double newPoints = correct ? grade : -grade;

      if (userDoc.exists && userDoc.data() != null) {
        var data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('pointsNumber')) {
          newPoints = ((data['pointsNumber'] as num) + newPoints).toDouble();
        }
      }

      await userDocRef.update({'pointsNumber': newPoints});

      emit(LearningLoaded());
    } catch (e) {
      emit(LearningError("Network error: ${e.toString()}"));
    }
  }

  Future<void> getUserPreviousAnswers(String? uid, String lessonId) async {
    emit(LearningLoading());

    try {
      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await fireStore
          .collection('users')
          .doc(uid)
          .collection('answers')
          .where('lessonId', isEqualTo: lessonId)
          .get();

      // Extract data from documents
      previousAnswers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          "id": doc.id, // Firestore document ID
          "questionId": data["questionId"],
          "answerContent": data["selectedAnswer"],
          "grade": data["grade"],
          "correct": data["correct"],
        };
      }).toList();

      // Emit the loaded state with extracted data
      emit(LearningLoaded());
    } catch (e) {
      emit(LearningError("Error: $e"));
    }
  }

  void nextVocabulary(
    context,
    String lessonId,
    String levelId,
    double page,
    double size,
    double order,
    String title,
    double userPoints,
    String collectionName,
    double rewardedPoints,
      int numberOfLessons,
      bool isLastExam
  ) {
    if (lessonDetails != null &&
        currentVocabIndex < lessonDetails!.vocabularies!.length - 1) {
      currentVocabIndex++;
      emit(LearningUpdated());
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EndLearning(
            lessonId: lessonId,
            levelId: levelId,
            page: page,
            size: size,
            order: order,
            title: title,
            userPoints: userPoints,
            collectionName: collectionName,
            rewardedPoints: rewardedPoints,
            numberOfLessons: numberOfLessons, isLastExam: isLastExam,
          ),
        ),
      );
    }
  }

  void pastVocabulary(
    context,
    String lessonId,
    String levelId,
    double page,
    double size,
    double order,
    String title,
    double userPoints,
    String collectionName,
    double rewardedPoints,
      int numberOfLessons,
      bool isLastExam
  ) {
    if (lessonDetails != null && currentVocabIndex != 0) {
      currentVocabIndex--;
      emit(LearningUpdated());
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => LessonsPage(
                  levelId: levelId,
                  page: page,
                  size: size,
                  collectionName: collectionName,
                  rewardedPoints: rewardedPoints,
                 numberOfLessons: numberOfLessons,
                )),
      );
    }
  }

  Future<void> getLessonsDetailsData(String uid, String levelId,
      String collectionName, String lessonsId, String title, int order,
      {bool question = false, bool vocab = false, bool forget = true}) async {
    emit(LearningLoading());
    try {
      if (forget) {
        lessonDetails = null;
      }

      var docSnapshot = await fireStore.collection('levels')
          .doc(levelId)
          .collection(collectionName)
          .doc(lessonsId)
          .collection('userAds')
          .doc(uid)  // Using the uid as the document ID
          .get();

      var canShowAd = !docSnapshot.exists;  // true if the document doesn't exist

      if (question) {
        var data = await fireStore
            .collection('levels')
            .doc(levelId)
            .collection(collectionName)
            .doc(lessonsId)
            .collection('questions')
            .get();


        List<Question> questions =
            data.docs.map((doc) => Question.fromJson(doc.data())).toList();

        if (forget) {
          lessonDetails = LessonDetails(
            lessonId: lessonsId,
            title: title,
            order: order,
            levelId: levelId,
            questions: questions,
            canShowAd: canShowAd,
          );
        } else {
          lessonDetails?.questions = questions;
        }
      } else if (vocab) {
        var data = await fireStore
            .collection('levels')
            .doc(levelId)
            .collection(collectionName)
            .doc(lessonsId)
            .collection('vocabulary')
            .get();

        List<Vocabulary> vocabularies =
            data.docs.map((doc) => Vocabulary.fromJson(doc.data())).toList();
        if (forget) {
          lessonDetails = LessonDetails(
            lessonId: lessonsId,
            title: title,
            order: order,
            levelId: levelId,
            vocabularies: vocabularies,
            canShowAd: canShowAd,
          );
        } else {
          lessonDetails?.vocabularies = vocabularies;
        }
      }

      emit(LearningLoaded());
    } catch (error) {
      print('Error fetching lesson details: $error');
      emit(LearningError(error.toString()));
    }
  }

  Future<void> rewardedInterstitialAdLessonExam(String? uid ,String levelId,
  String collectionName, String lessonsId) async {
    RewardedInterstitialAd.load(
      adUnitId: 'ca-app-pub-7223929122163665/2103266220',
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          log('InterstitialAd loaded successfully');
          ad.show(
            onUserEarnedReward: (ad, reward) async {
              DocumentReference userDocRef =
              fireStore.collection('users').doc(uid);

              // Get the current pointsNumber and update it without a transaction
              DocumentSnapshot userDoc = await userDocRef.get();

              if (userDoc.exists && userDoc.data() != null) {
                await userDocRef.update({
                  'pointsNumber': FieldValue.increment(10),
                });

                await fireStore.collection('levels')
                    .doc(levelId)
                    .collection(collectionName)
                    .doc(lessonsId)
                    .collection('userAds')
                    .doc(uid)
                    .set({
                  'uid':uid
                });
                lessonDetails?.canShowAd=false;
                emit(LearningLoaded());
              }

              log('User earned reward: ${reward.amount} ${reward.type}');
            },
          );
        },
        onAdFailedToLoad: (error) {
          log('Failed to load Rewarded Interstitial Ad: $error');
        },
      ),
    );
  }




  double pointsToShowQuestionExam = 0;
  Future<void> getUserPoints(String uid) async {
    emit(GetUserPointsLoading());
    try {
      var response = await fireStore.collection(USERS).doc(uid).get();
      pointsToShowQuestionExam = response['pointsNumber'].toDouble();
      emit(GetUserPointsSuccess());
    } catch (error) {
      emit(GetUserPointsError(error.toString()));
    }
  }
Future<void>addUserToCompleteLesson(String uid,String levelId)async{
  emit(GetUserPointsLoading());
  try {
     await fireStore.collection('levels').doc(levelId).collection('users').doc(uid).set({
      'userId':uid
    });

    emit(GetUserPointsSuccess());
  } catch (error) {
    emit(GetUserPointsError(error.toString()));
  }
}

}
