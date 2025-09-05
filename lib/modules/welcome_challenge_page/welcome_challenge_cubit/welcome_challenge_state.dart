

abstract class WelcomeChallengeState {}

class InitialWelcomeChallengeState extends WelcomeChallengeState {}


class GetWelcomeChallengeDetailsDataLoading extends WelcomeChallengeState {}

class GetWelcomeChallengeDetailsDataSuccess extends WelcomeChallengeState {}

class GetWelcomeChallengeDetailsDataError extends WelcomeChallengeState {
  final String message;

  GetWelcomeChallengeDetailsDataError(this.message);
}

class WelcomeChallengeUpdated extends WelcomeChallengeState {}

class WelcomeChallengeFinished extends WelcomeChallengeState {}