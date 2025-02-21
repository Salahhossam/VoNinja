class LevelsProgressData {
  final String levelId;
  final String levelDifficulty;
  final double levelProgress;

  LevelsProgressData({
    required this.levelId,
    required this.levelDifficulty,
    required this.levelProgress,
  });

  factory LevelsProgressData.fromJson(Map<String, dynamic> json) {
    return LevelsProgressData(
      levelId: json['levelId'] as String? ?? '',
      levelDifficulty: json['levelDifficulty'] as String? ?? '',
      levelProgress: (json['progress'] as num?)?.toDouble() ?? 0,
    );
  }
  // Map<String, dynamic> toJson = {
  //   "levels": [
  //     {
  //       "levelId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  //       "levelDifficulty": "BASIC",
  //       "progress": 0
  //     }
  //   ]
  // };
  Map<String, dynamic> toJson() {
    return {
      'levelId': levelId,
      'levelDifficulty': levelDifficulty,
      'progress': levelProgress,
    };
  }
}