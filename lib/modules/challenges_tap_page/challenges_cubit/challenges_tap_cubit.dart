import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/challenge_tap_model.dart';
import '../../../shared/constant/constant.dart';
import 'challenges_tap_state.dart';

class ChallengeTapCubit extends Cubit<ChallengeTapState> {
  ChallengeTapCubit() : super(ChallengeTapLoading());
  static ChallengeTapCubit get(context) {
    return BlocProvider.of(context);
  }

  List<ChallengeTap> levelsData = [];

  Future<void> getLevelsData(String uid) async {
    emit(ChallengeTapLoading());
    try {
      levelsData = [];


      QuerySnapshot levelsSnapshot = await fireStore.collection('levels').get();

      for (var doc in levelsSnapshot.docs) {
        String levelId = doc.id;
        String levelDifficulty = doc['difficulty']; // Ensure this field exists
        double rewardedPoints = (doc['questionRewardPoints'] ?? 0.0).toDouble();
        double deducedPoints = (doc['questionDeducePoints'] ?? 0.0).toDouble();
        int numberOfLessons = (doc['totalLessons'] ?? 0);
        int totalQuestions = doc['totalQuestions'] ?? 0;

        final docSnapshot = await fireStore
            .collection('levels')
            .doc(levelId)
            .collection('users')
            .doc(uid)
            .get();

        // Fetch the number of answered questions for this level
        AggregateQuerySnapshot answersCountSnapshot = await fireStore
            .collection('users')
            .doc(uid)
            .collection('answers')
            .where('levelId', isEqualTo: levelId)
            .count()
            .get();

        int? answeredQuestions = answersCountSnapshot.count;
        double levelProgress = 0.0;
        if (answeredQuestions != null && totalQuestions > 0) {
          levelProgress = (answeredQuestions / totalQuestions);
        }
        // Store challenge data
        levelsData.add(ChallengeTap(
          levelId: levelId,
          levelDifficulty: levelDifficulty,
          rewardedPoints: rewardedPoints,
          deducedPoints: deducedPoints,
          numberOfLessons: numberOfLessons,
          levelProgress: double.parse(levelProgress.toStringAsFixed(2)),
          canTap: docSnapshot.exists
        ));
      }

      // Emit the loaded state with levels data and progress data
      emit(ChallengeTapLoaded(levelsData));
    } catch (error) {
      emit(ChallengeTapError(error.toString()));
    }
  }

// Simulated server fetch function
  // Future<void> fetchChallenges() async {
  //   try {
  //     emit(ChallengeTapLoading());

  //     // await Future.delayed(const Duration(seconds: 2));

  //     final challenges = [
  //       ChallengeTap(
  //         imagePath: 'assets/img/basic.png',
  //         level: 1,
  //         title: 'Basic',
  //         progress: 0.9,
  //         positivePoints: '1',
  //         negativePoints: '1',
  //         percentage: '90%',
  //       ),
  //       ChallengeTap(
  //         imagePath: 'assets/img/intermed.png',
  //         level: 2,
  //         title: 'Intermediate',
  //         progress: 0.28,
  //         positivePoints: '3',
  //         negativePoints: '1',
  //         percentage: '28%',
  //       ),
  //       ChallengeTap(
  //         imagePath: 'assets/img/Advanced.png',
  //         level: 3,
  //         title: 'Advanced',
  //         progress: 0.60,
  //         positivePoints: '5',
  //         negativePoints: '1',
  //         percentage: '60%',
  //       ),
  //     ];

  //     emit(ChallengeTapLoaded(challenges));
  //   } catch (e) {
  //     emit(ChallengeTapError('Failed to load data'));
  //   }
  // }




}
