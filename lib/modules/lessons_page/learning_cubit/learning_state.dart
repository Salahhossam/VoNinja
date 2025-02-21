
abstract class LearningState {}

class LearningInitial extends LearningState {}

class LearningLoading extends LearningState {}

class LearningUpdated extends LearningState {}

class LearningLoaded extends LearningState {}

class LearningPointsLoaded extends LearningState {
  final double points;
  LearningPointsLoaded(this.points);
}

class LearningError extends LearningState {
  final String message;

  LearningError(this.message);
}

class GetUserPointsLoading extends LearningState {}
class GetUserPointsSuccess extends LearningState {}
class GetUserPointsError extends LearningState {
  final String error;
  GetUserPointsError(this.error);
}
