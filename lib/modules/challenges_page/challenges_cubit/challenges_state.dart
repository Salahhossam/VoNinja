import '../../../models/challenge_model.dart';

abstract class ChallengeState {}

class ChallengeInitial extends ChallengeState {}

class ChallengeLoading extends ChallengeState {}

class ChallengeLoaded extends ChallengeState {
  final ChallengePage challengePage;
  ChallengeLoaded(this.challengePage);
}

class ChallengeLoaded2 extends ChallengeState {}

class ChallengeError extends ChallengeState {
  final String message;

  ChallengeError(this.message);
}

class GetUserPointsLoading extends ChallengeState{}
class GetUserPointsSuccess extends ChallengeState{}
class GetUserPointsError extends ChallengeState {
  final String message;

  GetUserPointsError(this.message);
}