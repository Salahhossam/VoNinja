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
  bool isFetching = false;

  Future<void> getLevelsData(String uid) async {
    if (isFetching) return; // Prevent new fetch if one is ongoing
    isFetching = true;

    emit(ChallengeTapLoading());
    try {
      levelsData = [];

      QuerySnapshot levelsSnapshot = await fireStore.collection('levels').get();

      for (var doc in levelsSnapshot.docs) {
        String levelId = doc.id;
        String levelDifficulty = doc['difficulty'];
        double rewardedPoints = (doc['questionRewardPoints'] ?? 0.0).toDouble();
        int numberOfLessons = (doc['totalLessons'] ?? 0);
        int totalQuestions = doc['totalQuestions'] ?? 0;

        final docSnapshot = await fireStore
            .collection('levels')
            .doc(levelId)
            .collection('users')
            .doc(uid)
            .get();

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

        levelsData.add(ChallengeTap(
          levelId: levelId,
          levelDifficulty: levelDifficulty,
          rewardedPoints: rewardedPoints,
          numberOfLessons: numberOfLessons,
          levelProgress: double.parse(levelProgress.toStringAsFixed(2)),
          canTap: docSnapshot.exists,
        ));
      }

      emit(ChallengeTapLoaded());
    } catch (error) {
      emit(ChallengeTapError(error.toString()));
    } finally {
      isFetching = false; // Reset flag after completion
    }
  }






}
