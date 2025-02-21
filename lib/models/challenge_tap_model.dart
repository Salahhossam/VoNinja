// class ChallengeTap {
//   final String imagePath;
//   final int level;
//   final String title;
//   final double progress;
//   final String positivePoints;
//   final String negativePoints;
//   final String percentage;

//   ChallengeTap({
//     required this.imagePath,
//     required this.level,
//     required this.title,
//     required this.progress,
//     required this.positivePoints,
//     required this.negativePoints,
//     required this.percentage,
//   });
// }
class ChallengeTap {
  final String? levelId;
  final String? levelDifficulty;
  final double? rewardedPoints;
  final double? deducedPoints;
  final int? numberOfLessons;
  final int? numberOfQuestion;
  final double? levelProgress;

  ChallengeTap({
    required this.levelId,
    required this.levelDifficulty,
    required this.rewardedPoints,
    required this.deducedPoints,
    required this.numberOfLessons,
    this.levelProgress,
    this.numberOfQuestion
  });

  factory ChallengeTap.fromJson(Map<String, dynamic> json) {
    return ChallengeTap(
      levelId: json['id'] as String? ?? '',
      levelDifficulty: json['difficulty'] as String? ?? '',
      rewardedPoints: (json['questionRewardPoints'] as num?)?.toDouble() ?? 0.0,
      deducedPoints: (json['questionDeducePoints'] as num?)?.toDouble() ?? 0.0,
      numberOfLessons: (json['totalLessons'] as num?)?.toInt() ?? 0,
      numberOfQuestion: (json['totalQuestions'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': levelId ?? '',
      'difficulty': levelDifficulty ?? '',
      'questionRewardPoints': rewardedPoints ?? 0.0,
      'questionDeducePoints': deducedPoints ?? 0.0,
      'totalLessons': numberOfLessons ?? 0,
      'totalQuestions': numberOfQuestion??0,
    };
  }
}
