class ChallengePage {
  List<Challenge>? challenges;
  double? page;
  double? size;
  double? totalElements;
  double? totalPages;

  ChallengePage({
    required this.challenges,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  factory ChallengePage.fromJson(Map<String?, dynamic> json) {
    return ChallengePage(
      challenges: List<Challenge>.from(
        json['challenges']?.map((x) => Challenge.fromJson(x)) ?? [],
      ),
      page: json['page'] ?? 0.0,
      size: json['size'] ?? 0.0,
      totalElements: json['totalElements'] ?? 0.0,
      totalPages: json['totalPages'] ?? 0.0,
    );
  }

  Map<String?, dynamic> toJson() {
    return {
      'challenges': List<dynamic>.from(challenges!.map((x) => x.toJson())),
      'page': page,
      'size': size,
      'totalElements': totalElements,
      'totalPages': totalPages,
    };
  }
}

class Challenge {
  String? challengeId;
  String? title;
  double? rewardPoints;
  double? deducePoints;
  DateTime? endTime;
  double? subscriptionPoints;
  String? status;
  Rewards? rewards;
  double? numberOfTasks;
  double? numberOfSubscriptions;
  double? totalQuestions;
  DateTime? createdAt;
  Challenge({
    required this.challengeId,
    required this.title,
    required this.rewardPoints,
    required this.deducePoints,
    required this.endTime,
    required this.subscriptionPoints,
    required this.status,
    required this.rewards,
    required this.numberOfTasks,
    required this.numberOfSubscriptions,
    this.createdAt,
    required this.totalQuestions
  });

  factory Challenge.fromJson(Map<String?, dynamic> json) {
    return Challenge(
      challengeId: json['challengeId'] ?? '',
      title: json['title'] ?? '',
      rewardPoints: json['rewardPoints'].toDouble() ?? 0.0,
      deducePoints: json['deducePoints'].toDouble() ?? 0.0,
      endTime: json['endTime'].toDate() ?? DateTime.now(),
      subscriptionPoints: json['subscriptionPoints'].toDouble() ?? 0.0,
      status: json['status'] ?? '',
      rewards: Rewards.fromJson(json['rewards'] ?? {}),
      numberOfTasks: json['numberOfTasks'].toDouble() ?? 0.0,
      numberOfSubscriptions: json['numberOfSubscriptions'].toDouble() ?? 0.0,
      createdAt: json['createdAt'].toDate(),
      totalQuestions:json['totalQuestions'].toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'challengeId': challengeId,
      'title': title,
      'rewardPoints': rewardPoints,
      'deducePoints': deducePoints,
      'endTime': endTime,
      'subscriptionPoints': subscriptionPoints,
      'status': status,
      'rewards': rewards?.toJson() ?? [],
      'numberOfTasks': numberOfTasks,
      'numberOfSubscriptions': numberOfSubscriptions,
      'createdAt':createdAt
    };
  }
}

class Rewards {
  double? additionalProp1;
  double? additionalProp2;
  double? additionalProp3;

  Rewards({
    required this.additionalProp1,
    required this.additionalProp2,
    required this.additionalProp3,
  });

  factory Rewards.fromJson(Map<String?, dynamic> json) {
    return Rewards(
      additionalProp1: json['additionalProp1'] ?? 0.0,
      additionalProp2: json['additionalProp2'] ?? 0.0,
      additionalProp3: json['additionalProp3'] ?? 0.0,
    );
  }

  Map<String?, dynamic> toJson() {
    return {
      'additionalProp1': additionalProp1,
      'additionalProp2': additionalProp2,
      'additionalProp3': additionalProp3,
    };
  }
}
