import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vo_ninja/models/challenge_progress_model.dart';
import 'package:vo_ninja/modules/challenges_page/task_cubit/task_state.dart';

import '../../../models/leaderboard_tap_model.dart';
import '../../../models/task_details_model.dart';
import '../../../shared/constant/constant.dart';
import '../end_challenges.dart';
import '../task_page.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  static TaskCubit get(context) {
    return BlocProvider.of(context);
  }

  List<ChallengeProgressDto> taskProgress = [];

  List<TaskDetails> taskCards = [];
  DocumentSnapshot? lastDocument;

  Future<void> getChallengeData(
      String uid, String? challengeId, bool loadMore, double rewardedPoints,
      {int numTasks = 5}) async {
    emit(GetChallengeDataLoading());

    try {
      Query query = fireStore
          .collection('challenges')
          .doc(challengeId)
          .collection('tasks')
          .orderBy('order')
          .limit(numTasks);

      // If loadMore is true and we have a last document, start after it
      if (loadMore && lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      } else {
        taskCards = [];
        taskProgress = [];
      }

      QuerySnapshot tasksSnapshot = await query.get();

      // Stop loading if there's no more data
      if (tasksSnapshot.docs.isEmpty) {
        return;
      }

      for (var doc in tasksSnapshot.docs) {
        String tackId = doc.id;

        double points = 0;
        double userPoints = 0; // User points calculated from grade field
        double questionsCount = 0;
        double userProgress = 0;

        TaskDetails taskCard =
            TaskDetails.fromJson(doc.data() as Map<String, dynamic>);

        points = doc['numQuestions'] * rewardedPoints;

        questionsCount = doc['numQuestions'].toDouble();

        // Fetch the user's answers and retrieve the 'grade' field
        QuerySnapshot userAnswersSnapshot = await fireStore
            .collection('users')
            .doc(uid)
            .collection('challengeAnswers')
            .where('taskId', isEqualTo: tackId)
            .get();

        int answeredQuestions = userAnswersSnapshot.docs.length;
        double lessonProgress = 0.0;

        if (answeredQuestions > 0 &&
            taskCard.numberOfQuestion != null &&
            taskCard.numberOfQuestion! > 0) {
          lessonProgress = answeredQuestions / taskCard.numberOfQuestion!;
        }

        // Calculate userPoints based on grades from answers
        for (var answerDoc in userAnswersSnapshot.docs) {
          double grade =
              (answerDoc['grade'] ?? 0).toDouble(); // Get the 'grade' field
          userPoints += grade; // Accumulate userPoints based on grades
        }

        // Update lesson progress
        userProgress = double.parse(lessonProgress.toStringAsFixed(2));

        taskCards.add(taskCard);
        taskProgress.add(ChallengeProgressDto(
            taskId: tackId,
            points: points,
            userPoints: userPoints,
            questionsCount: questionsCount,
            userProgress: userProgress));
      }

      // Update last document for next pagination
      lastDocument = tasksSnapshot.docs.last;

      emit(GetChallengeDataSuccess());
    } catch (error) {
      emit(GetChallengeDataError(error.toString()));
    }
  }

  /////////////////////////////////////////////////////////////////////////////////

  List<Question> questions = [];

  int currentQuestionIndex = 0;

  bool canShowAd=false;

  Future<void> rewardedInterstitialAd(String? uid,String challengeId, String taskId) async {
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

                await fireStore
                    .collection('challenges')
                    .doc(challengeId)
                    .collection('tasks')
                    .doc(taskId)
                    .collection('userAds')
                    .doc(uid)
                    .set({'uid': uid});
                canShowAd = false;
                emit(GetTasksDetailsDataSuccess());
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






  Future<void> getTasksDetailsData(
    String uid,
    String challengeId,
    String taskId,
  ) async {
    emit(GetTasksDetailsDataLoading());
    try {
      questions = [];

      var data = await fireStore
          .collection('challenges')
          .doc(challengeId)
          .collection('tasks')
          .doc(taskId)
          .collection('questions')
          .get();

      var docSnapshot= await fireStore
          .collection('challenges')
          .doc(challengeId)
          .collection('tasks')
          .doc(taskId)
          .collection('userAds')
          .doc(uid)
          .get();
       canShowAd = !docSnapshot.exists;  // true if the document doesn't exist

      questions =
          data.docs.map((doc) => Question.fromJson(doc.data())).toList();

      emit(GetTasksDetailsDataSuccess());
    } catch (error) {
      //print('Error fetching lesson details: $error');
      emit(GetTasksDetailsDataError(error.toString()));
    }
  }

  List<Map<String, dynamic>> previousAnswers = [];

  Future<void> getUserPreviousAnswers(String uid, String taskId) async {
    emit(GetTasksDetailsDataLoading());

    try {
      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await fireStore
          .collection('users')
          .doc(uid)
          .collection('challengeAnswers')
          .where('taskId', isEqualTo: taskId)
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
      emit(GetTasksDetailsDataSuccess());
    } catch (e) {
      emit(GetTasksDetailsDataError(e.toString()));
    }
  }

  double userPoints = 0;

  Future<void> getUserPoints(String uid, String challengeId) async {
    try {
      emit(GetTasksDetailsDataLoading());
      var data = await fireStore
          .collection('challenges')
          .doc(challengeId)
          .collection('users')
          .doc(uid)
          .get();
      userPoints = data['userPoints'].toDouble();
      emit(GetTasksDetailsDataSuccess());
    } catch (e) {
      emit(GetTasksDetailsDataError(e.toString()));
    }
  }

  void success() {
    emit(GetTasksDetailsDataSuccess());
  }

  Future<void> postUserExamAnswers(String uid, String taskId, String questionId,
      String answer, bool correct, double grade, String challengeId) async {
    emit(GetTasksDetailsDataLoading());
    try {
      // Store the answer in the user's answers collection

      await fireStore
          .collection('users')
          .doc(uid)
          .collection('challengeAnswers')
          .doc(questionId)
          .set({
        'correct': correct,
        'grade': correct ? grade : -grade,
        'taskId': taskId,
        'challengeId': challengeId,
        'questionId': questionId,
        'selectedAnswer': answer,
      });

      // Reference to the user document
      DocumentReference userDocRef = fireStore
          .collection('challenges')
          .doc(challengeId)
          .collection('users')
          .doc(uid);

      // Get the current pointsNumber and update it without a transaction
      DocumentSnapshot userDoc = await userDocRef.get();
      double newPoints = correct ? grade : -grade;

      if (userDoc.exists && userDoc.data() != null) {
        var data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('userPoints')) {
          newPoints = ((data['userPoints'] as num) + newPoints).toDouble();
        }
      }

      await userDocRef.update({'userPoints': newPoints});

      await fireStore
          .collection('users')
          .doc(uid)
          .update({'pointsNumber': pointsToShowQuestionExam});

      emit(GetTasksDetailsDataSuccess());
    } catch (e) {
      emit(GetTasksDetailsDataError("Network error: ${e.toString()}"));
    }
  }

  void moveToNextQuestion(
      context,
      double userPoints,
      String taskId,
      String challengeId,
      String challengesName,
      double rewardPoints,
      DateTime challengesRemainingTime,
      double subscriptionCostPoints,
      String status,
      double challengesNumberOfTasks,
      double numberOfQuestion,
      double challengesNumberOfSubscriptions) {
    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;

      emit(GetTasksDetailsDataSuccess());
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => EndChallenges(
                taskId: taskId,
                challengeId: challengeId,
                title: challengesName,
                challengesName: challengesName,
                rewardPoints: rewardPoints,
                challengesRemainingTime: challengesRemainingTime,
                subscriptionCostPoints: subscriptionCostPoints,
                status: status,
                challengesNumberOfTasks: challengesNumberOfTasks,
                numberOfQuestion: numberOfQuestion,
                challengesNumberOfSubscriptions:
                    challengesNumberOfSubscriptions)),
      );
      emit(GetTasksDetailsDataSuccess());
    }
  }

  void moveToPastQuestion(
      context,
      double userPoints,
      String taskId,
      String challengeId,
      String challengesName,
      double rewardPoints,
      DateTime challengesRemainingTime,
      double subscriptionCostPoints,
      String status,
      double challengesNumberOfTasks,
      double numberOfQuestion,
      double challengesNumberOfSubscriptions) {
    if (currentQuestionIndex != 0) {
      currentQuestionIndex--;

      emit(GetTasksDetailsDataSuccess());
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => TaskPage(
                  challengesName: challengesName,
                  challengeId: challengeId,
                  rewardPoints: rewardPoints,
                  challengesRemainingTime: challengesRemainingTime,
                  subscriptionCostPoints: subscriptionCostPoints,
                  status: status,
                  challengesNumberOfTasks: challengesNumberOfTasks,
                  challengesNumberOfSubscriptions:
                      challengesNumberOfSubscriptions,
                  numberOfQuestion: numberOfQuestion,
                )),
      );
      emit(GetTasksDetailsDataSuccess());
    }
  }

  int rank = 0;
  Future<void> getUserRank(String uid, String challengeId) async {
    emit(GetTasksDetailsDataLoading());
    try {
      final querySnapshot = await fireStore
          .collection('challenges')
          .doc(challengeId)
          .collection('users')
          .where('userPoints', isGreaterThan: userPoints)
          .count()
          .get();

      rank = (querySnapshot.count ?? 0) + 1;

      emit(GetTasksDetailsDataSuccess());
    } catch (e) {
      emit(GetTasksDetailsDataError("Network error: ${e.toString()}"));
    }
  }

  List<LeaderboardTap> leaderboards = [];
  Future<void> fetchLeaderboards(String challengeId) async {
    emit(GetTasksDetailsDataLoading());
    try {
      leaderboards = [];

      double rank = 0;
      int limitSize = 15;

      Query query = fireStore
          .collection('challenges')
          .doc(challengeId)
          .collection('users')
          .orderBy('userPoints', descending: true)
          .limit(limitSize);

      final querySnapshot = await query.get();

      for (var doc in querySnapshot.docs) {
        var user = doc.data() as Map<String, dynamic>;
        double points = user['userPoints'].toDouble();
        rank += 1;

        leaderboards.add(LeaderboardTap(
          rank: rank,
          username: user['username'],
          userAvatar: user['userAvater'],
          points: points,
          id: doc.id,
        ));
      }

      emit(GetTasksDetailsDataSuccess());
    } catch (e) {
      emit(GetTasksDetailsDataError('Failed to load data: $e'));
    }
  }

  double pointsToShowQuestionExam = 0;
  Future<void> getTotalUserPoints(String uid) async {
    emit(GetUserPointsLoading());
    try {
      var response = await fireStore.collection(USERS).doc(uid).get();
      pointsToShowQuestionExam = response['pointsNumber'].toDouble();
      emit(GetUserPointsSuccess());
    } catch (error) {
      emit(GetUserPointsError(error.toString()));
    }
  }
}
