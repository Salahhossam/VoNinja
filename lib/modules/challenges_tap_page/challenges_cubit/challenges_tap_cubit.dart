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
        if (!levelsData.any((e) => e.levelId == levelId)) {
          // Store challenge data
        levelsData.add(ChallengeTap(
          levelId: levelId,
          levelDifficulty: levelDifficulty,
          rewardedPoints: rewardedPoints,
          numberOfLessons: numberOfLessons,
          levelProgress: double.parse(levelProgress.toStringAsFixed(2)),
          canTap: docSnapshot.exists
        ));
        }
      }

      // Emit the loaded state with levels data and progress data
      emit(ChallengeTapLoaded());
    } catch (error) {
      emit(ChallengeTapError(error.toString()));
    }
  }






}
