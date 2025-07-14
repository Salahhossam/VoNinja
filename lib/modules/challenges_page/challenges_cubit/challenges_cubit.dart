import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';
import 'package:vo_ninja/shared/constant/constant.dart';
import '../../../models/challenge_model.dart';
import 'challenges_state.dart';

class ChallengeCubit extends Cubit<ChallengeState> {
  ChallengeCubit() : super(ChallengeInitial());

  static ChallengeCubit get(context) {
    return BlocProvider.of(context);
  }

  List<Challenge> challenges = [];

  Future<void> getChallengePageData(String uid) async {
    emit(ChallengeLoading());
    try {
      challenges = [];
      DateTime now = await NTP.now();
      var query = await fireStore
          .collection('challenges')
          .where('status', isEqualTo: 'PUBLISHED')
          .where('endTime', isGreaterThan: now)
          .orderBy('challenge_order')
          .get();
      for (var doc in query.docs) {
        challenges.add(Challenge.fromJson(doc.data()));
      }
      emit(ChallengeLoaded2());
    } catch (error) {
      // print(error);
      // print('7777777777777777777');
      emit(ChallengeError(error.toString()));
    }
  }

  Future<double> getUserPoints(String uid) async {
    emit(GetUserPointsLoading());
    try {
      var response = await fireStore.collection(USERS).doc(uid).get();
      emit(GetUserPointsSuccess());
      return response['pointsNumber'].toDouble();
    } catch (error) {
      emit(GetUserPointsError(error.toString()));
      return 0;
    }
  }

  Future<bool> checkUserExistInChallenge(String uid, String challengeId) async {
    emit(GetUserPointsLoading());
    try {
      var response = await fireStore
          .collection('challenges')
          .doc(challengeId)
          .collection('users')
          .doc(uid)
          .get();
      if (response.exists) {
        emit(GetUserPointsSuccess());
        return true;
      } else {
        emit(GetUserPointsSuccess());
        return false;
      }
    } catch (error) {
      emit(GetUserPointsError(error.toString()));
      return false;
    }
  }

  Future<void> addUserInChallenge(String uid, String challengeId,
      double userPoints, double challengePoint, String userName) async {
    emit(GetUserPointsLoading());
    try {
      await fireStore
          .collection('challenges')
          .doc(challengeId)
          .collection('users')
          .doc(uid)
          .set({'userPoints': 0.0, 'username': userName});
      var challenge =
          await fireStore.collection('challenges').doc(challengeId).get();
      await fireStore.collection('challenges').doc(challengeId).update({
        'numberOfSubscriptions': challenge['numberOfSubscriptions'] + 1,
      });

      emit(GetUserPointsSuccess());
    } catch (error) {
      emit(GetUserPointsError(error.toString()));
    }
  }
}
