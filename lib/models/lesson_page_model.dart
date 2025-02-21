// class Lesson {
//   final int lessonNumber;
//   final String lessonName;
//   final int pointLessonNumber;
//   final int questionsLessonNumber;
//   final bool isCompleted;
//   final int lessonLevel;
//   final String lessonLevelTitle;

//   Lesson({
//     required this.lessonNumber,
//     required this.lessonName,
//     required this.pointLessonNumber,
//     required this.isCompleted,
//     required this.questionsLessonNumber,
//     required this.lessonLevel,
//     required this.lessonLevelTitle,
//   });
// }
class LessonsPage {
  final List<LessonCard>? lessonsCard;
  final double? page;
  final double? size;
  final double? totalElements;
  final double? totalPages;

  LessonsPage({
    required this.lessonsCard,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  factory LessonsPage.fromJson(Map<String, dynamic> json) {
    return LessonsPage(
      lessonsCard: (json['lessons'] as List?)
              ?.map((lesson) => LessonCard.fromJson(lesson))
              .toList() ??
          [],
      page: json['page'] ?? 0,
      size: json['size'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessons': lessonsCard?.map((lesson) => lesson.toJson()).toList(),
      'page': page,
      'size': size,
      'totalElements': totalElements,
      'totalPages': totalPages,
    };
  }
}

class LessonCard {
  final String? lessonId;
  final String? title;
  final double? order;
  double? levelProgress;
  final int? numberOfQuestion;
  LessonCard({
    required this.lessonId,
    required this.title,
    required this.order,
    this.levelProgress,
    this.numberOfQuestion
  });

  factory LessonCard.fromJson(Map<String, dynamic> json) {
    return LessonCard(
      lessonId: json['id'] ?? '',
      title: json['title'] ?? '',
      order: (json['lesson_order'] as num?)?.toDouble() ?? 0.0,
      numberOfQuestion: (json['numQuestions'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': lessonId,
      'title': title,
      'lesson_order': order,
    };
  }
}
