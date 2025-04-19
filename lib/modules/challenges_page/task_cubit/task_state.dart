abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);
}

class GetChallengeDataLoading extends TaskState {}
class GetChallengeDataSuccess extends TaskState {}
class GetChallengeDataError extends TaskState {
  final String message;

  GetChallengeDataError(this.message);
}


class GetTasksDetailsDataLoading extends TaskState {}
class GetTasksDetailsDataSuccess extends TaskState {}
class GetTasksDetailsDataError extends TaskState {
  final String message;

  GetTasksDetailsDataError(this.message);
}



class GetUserPointsLoading extends TaskState {}
class GetUserPointsSuccess extends TaskState {}
class GetUserPointsError extends TaskState {
  final String message;

  GetUserPointsError(this.message);
}