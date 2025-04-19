abstract class LeaderboardTapState {}

class LeaderboardTapLoading extends LeaderboardTapState {}

class LeaderboardTapLoaded extends LeaderboardTapState {}

class LeaderboardTapError extends LeaderboardTapState {
  final String error;

  LeaderboardTapError(this.error);
}
