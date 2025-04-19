import 'package:vo_ninja/models/lesson_details_model.dart';

abstract class ExamState {}

class ExamInitial extends ExamState {}

class ExamLoading extends ExamState {}
class ExamUpdated extends ExamState {}

class ExamLoaded extends ExamState {
  final LessonDetails? lessonDetails;

  ExamLoaded(this.lessonDetails);
}

class ExamError extends ExamState {
  final String message;

  ExamError(this.message);
}
