class LearningProgress {
  final List<LearningProgressDto> learningProgressDtoList;

  LearningProgress({required this.learningProgressDtoList});

  factory LearningProgress.fromJson(Map<String, dynamic> json) {
    return LearningProgress(
      learningProgressDtoList: (json['learningProgressDtoList'] as List?)
              ?.map((item) => LearningProgressDto.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'learningProgressDtoList':
          learningProgressDtoList.map((dto) => dto.toJson()).toList(),
    };
  }
}

class LearningProgressDto {
  final String lessonId;
  final double points;
  final double userPoints;
  final double questionsCount;
  final double userProgress;

  LearningProgressDto({
    required this.lessonId,
    required this.points,
    required this.userPoints,
    required this.questionsCount,
    required this.userProgress,
  });

  factory LearningProgressDto.fromJson(Map<String, dynamic> json) {
    return LearningProgressDto(
      lessonId: json['lessonId'] ?? '',
      points: json['points'] ?? 0,
      userPoints: json['userPoints'] ?? 0,
      questionsCount: json['questionsCount'] ?? 0,
      userProgress: (json['userProgress'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'points': points,
      'userPoints': userPoints,
      'questionsCount': questionsCount,
      'userProgress': userProgress,
    };
  }
}
