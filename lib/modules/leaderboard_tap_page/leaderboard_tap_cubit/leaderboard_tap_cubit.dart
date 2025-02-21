import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/models/leaderboard_tap_model.dart';
import 'package:vo_ninja/shared/constant/constant.dart';
import 'leaderboard_tap_state.dart';

class LeaderboardTapCubit extends Cubit<LeaderboardTapState> {
  LeaderboardTapCubit() : super(LeaderboardTapLoading());

  static LeaderboardTapCubit get(context) {
    return BlocProvider.of(context);
  }

  List<LeaderboardTap> leaderboards = [];

  // Future<void> fetchLeaderboards2() async {
  //   emit(LeaderboardTapLoading());
  //   try {
  //     leaderboards = [];
  //     double? previousPoints;
  //     double rank = 0;
  //     int uniqueRanks = 0;
  //     DocumentSnapshot? lastDocument;
  //     int limitSize = 15;
  //
  //     while (uniqueRanks < 10) {
  //       Query query = fireStore
  //           .collection('users')
  //           .orderBy('pointsNumber', descending: true)
  //           .limit(limitSize);
  //
  //
  //       if (lastDocument != null) {
  //         query = query.startAfterDocument(lastDocument);
  //       }
  //
  //       final querySnapshot = await query.get();
  //
  //
  //       if (querySnapshot.docs.isNotEmpty) {
  //         lastDocument = querySnapshot.docs.last;
  //       } else {
  //         break;
  //       }
  //
  //       for (var doc in querySnapshot.docs) {
  //         var user = doc.data() as Map<String, dynamic>;
  //         double points = user['pointsNumber'].toDouble();
  //
  //
  //         if (previousPoints == null || previousPoints != points) {
  //           rank++;
  //           uniqueRanks++;
  //         }
  //
  //         if (uniqueRanks > 5) {
  //           break;
  //         }
  //
  //         leaderboards.add(LeaderboardTap(
  //           rank: rank,
  //           username: user['username'],
  //           points: points,
  //           id: user['userId'],
  //         ));
  //
  //         previousPoints = points;
  //       }
  //     }
  //
  //     emit(LeaderboardTapLoaded());
  //   } catch (e) {
  //     emit(LeaderboardTapError('Failed to load data: $e'));
  //   }
  // }

  Future<void> fetchLeaderboards() async {
    emit(LeaderboardTapLoading());
    try {
      leaderboards = [];

      double rank = 0;
      int limitSize = 50;

      Query query = fireStore
          .collection('users')
          .orderBy('pointsNumber', descending: true)
          .limit(limitSize);

      final querySnapshot = await query.get();

      for (var doc in querySnapshot.docs) {
        var user = doc.data() as Map<String, dynamic>;
        double points = user['pointsNumber'].toDouble();
        rank += 1;

        leaderboards.add(LeaderboardTap(
          rank: rank,
          username: user['username'],
          userAvatar: user['userAvatar'],
          points: points,
          id: user['userId'],
        ));
      }

      emit(LeaderboardTapLoaded());
    } catch (e) {
      emit(LeaderboardTapError('Failed to load data: $e'));
    }
  }
}
