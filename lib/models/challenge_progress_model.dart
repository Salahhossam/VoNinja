class ChallengeProgress {
  List<ChallengeProgressDto> progressDtoList;

  ChallengeProgress({
    required this.progressDtoList,
  });

  factory ChallengeProgress.fromJson(Map<String, dynamic> json) {
    return ChallengeProgress(
      progressDtoList: List<ChallengeProgressDto>.from(
        json['progressDtoList']?.map((x) => ChallengeProgressDto.fromJson(x)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'progressDtoList': List<dynamic>.from(progressDtoList.map((x) => x.toJson())),
    };
  }
}

class ChallengeProgressDto {
  String taskId;
  double points;
  double userPoints;
  double questionsCount;
  double userProgress;

  ChallengeProgressDto({
    required this.taskId,
    required this.points,
    required this.userPoints,
    required this.questionsCount,
    required this.userProgress,
  });

  factory ChallengeProgressDto.fromJson(Map<String, dynamic> json) {
    return ChallengeProgressDto(
      taskId: json['taskId'] ?? '',
      points: json['points'] ?? 0.0,
      userPoints: json['userPoints'] ?? 0.0,
      questionsCount: json['questionsCount'] ?? 0.0,
      userProgress: json['userProgress'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'points': points,
      'userPoints': userPoints,
      'questionsCount': questionsCount,
      'userProgress': userProgress,
    };
  }
}
