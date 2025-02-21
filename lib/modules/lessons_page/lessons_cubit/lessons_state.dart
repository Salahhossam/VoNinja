abstract class LessonState {}

class LessonInitial extends LessonState {}

class LessonLoading extends LessonState {}

class LessonLoaded extends LessonState {}

class LessonError extends LessonState {
  final String message;

  LessonError(this.message);
}
