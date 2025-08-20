abstract class EventState {}

class InitialEventState extends EventState{}


class SeedDummyEventsLoading extends EventState {}

class SeedDummyEventsSuccess extends EventState {}

class SeedDummyEventsError extends EventState {
  final String message;

  SeedDummyEventsError(this.message);
}

class SeedQuizQuestionsLoading extends EventState {}

class SeedQuizQuestionsSuccess extends EventState {}

class SeedQuizQuestionsError extends EventState {
  final String message;

  SeedQuizQuestionsError(this.message);
}


class ClearEventsLoading extends EventState {}

class ClearEventsSuccess extends EventState {}

class ClearEventsError extends EventState {
  final String message;

  ClearEventsError(this.message);
}

class FetchEventsLoading extends EventState {}

class FetchEventsSuccess extends EventState {}

class FetchEventsError extends EventState {
  final String message;

  FetchEventsError(this.message);
}

class EnsureWelcomeLoading extends EventState {}

class EnsureWelcomeSuccess extends EventState {}

class EnsureWelcomeError extends EventState {
  final String message;

  EnsureWelcomeError(this.message);
}


class FetchUserEventsProgressLoading extends EventState {}

class FetchUserEventsProgressSuccess extends EventState {}

class FetchUserEventsProgressError extends EventState {
  final String message;

  FetchUserEventsProgressError(this.message);
}

class JoinEventLoading extends EventState {}

class JoinEventSuccess extends EventState {}

class JoinEventError extends EventState {
  final String message;

  JoinEventError(this.message);
}

class AddPointsLoading extends EventState {}

class AddPointsSuccess extends EventState {}

class AddPointsError extends EventState {
  final String message;

  AddPointsError(this.message);
}

class ClaimRewardLoading extends EventState {}

class ClaimRewardSuccess extends EventState {}

class ClaimRewardError extends EventState {
  final String message;

  ClaimRewardError(this.message);
}