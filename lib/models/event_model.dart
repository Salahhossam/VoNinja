import 'package:cloud_firestore/cloud_firestore.dart';

enum EventType {
  welcome,
  multiplier,
  targetPoints,
  quiz,
  leaderboardQuiz,
}

EventType parseEventType(String? value) {
  switch (value) {
    case 'welcome':
      return EventType.welcome;
    case 'multiplier':
      return EventType.multiplier;
    case 'target_points':
      return EventType.targetPoints;
    case 'quiz':
      return EventType.quiz;
    case 'leaderboard_quiz':
      return EventType.leaderboardQuiz;
    default:
      return EventType.quiz;
  }
}

class AppEvent {
  final String id;
  final EventType type;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime? startAt;
  final DateTime? endAt;
  final int? order;
  final Map<String, dynamic> rules;
  final List<String> instructions;

  AppEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startAt,
    required this.endAt,
    required this.order,
    required this.rules,
    required this.instructions,
  });

  factory AppEvent.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AppEvent(
      id: doc.id,
      type: parseEventType(data['type']),
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      startAt: (data['startAt'] as Timestamp?)?.toDate(),
      endAt: (data['endAt'] as Timestamp?)?.toDate(),
      order: data['order'] as int?,
      rules: Map<String, dynamic>.from(data['rules'] ?? {}),
      instructions: (data['instructions'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  bool isUpcoming(DateTime now) {
    if (startAt == null) return false;
    return now.isBefore(startAt!);
  }

  bool isActiveNow(DateTime now, {DateTime? userStart, DateTime? userEnd}) {
    if (type == EventType.welcome) {
      if (userStart == null || userEnd == null) return false;
      return now.isAfter(userStart) && now.isBefore(userEnd);
    }

    if (startAt == null || endAt == null) return false;
    return now.isAfter(startAt!) && now.isBefore(endAt!);
  }

  bool get isLeaderboardQuiz => type == EventType.leaderboardQuiz;

  int get normalQuestionPoints => (rules['normalQuestionPoints'] ?? 0) as int;
  int get goldenEvery => (rules['goldenEvery'] ?? 0) as int;
  int get goldenQuestionPoints => (rules['goldenQuestionPoints'] ?? 0) as int;
  int get rewardedAdMultiplier => (rules['rewardedAdMultiplier'] ?? 2) as int;
  int get pageSize => (rules['pageSize'] ?? 20) as int;
}

class UserEventProgress {
  final String eventId;
  String status;
  int pointsAccumulated;
  int correctAnswers;
  int answerCount;
  int eventScore;
  int currentOrder;
  int prizeAmount;
  DateTime? userStartAt;
  DateTime? userEndAt;

  UserEventProgress({
    required this.eventId,
    required this.status,
    required this.pointsAccumulated,
    required this.correctAnswers,
    required this.answerCount,
    required this.eventScore,
    required this.currentOrder,
    required this.prizeAmount,
    this.userStartAt,
    this.userEndAt,
  });

  factory UserEventProgress.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final progress = Map<String, dynamic>.from(data['progress'] ?? {});

    return UserEventProgress(
      eventId: data['eventId'] ?? doc.id,
      status: data['status'] ?? 'not_joined',
      pointsAccumulated: (progress['pointsAccumulated'] ?? 0) as int,
      correctAnswers: (progress['correctAnswers'] ?? 0) as int,
      answerCount: (progress['answerCount'] ?? 0) as int,
      eventScore: (progress['eventScore'] ?? 0) as int,
      currentOrder: (progress['currentOrder'] ?? 0) as int,
      prizeAmount: (data['prizeAmount'] ?? 0) as int,
      userStartAt: (data['userStartAt'] as Timestamp?)?.toDate(),
      userEndAt: (data['userEndAt'] as Timestamp?)?.toDate(),
    );
  }
}

class Question {
  final String questionId;
  final int order;
  final String content;
  final List<String> choices;
  final String correctAnswer;
  final String? imageUrl;
  final String explanation;

  Question({
    required this.questionId,
    required this.order,
    required this.content,
    required this.choices,
    required this.correctAnswer,
    required this.imageUrl,
    required this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['id'] ?? '',
      order: (json['order'] ?? 0) as int,
      content: json['content'] ?? '',
      choices: List<String>.from(json['choices'] ?? []),
      correctAnswer: json['correct_answer'] ?? '',
      imageUrl: json['image_url'],
      explanation: json['explanation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': questionId,
      'order': order,
      'content': content,
      'choices': choices,
      'correct_answer': correctAnswer,
      'image_url': imageUrl,
      'explanation': explanation,
    };
  }

  bool isGolden(AppEvent event) {
    if (!event.isLeaderboardQuiz) return false;
    if (event.goldenEvery <= 0) return false;
    return order > 0 && order % event.goldenEvery == 0;
  }
}

class LeaderboardEntry {
  final String uid;
  final String name;
  final String avatar;
  final int score;
  final int correctAnswers;
  final int answerCount;
  final DateTime? lastAnsweredAt;

  LeaderboardEntry({
    required this.uid,
    required this.name,
    required this.avatar,
    required this.score,
    required this.correctAnswers,
    required this.answerCount,
    required this.lastAnsweredAt,
  });

  factory LeaderboardEntry.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LeaderboardEntry(
      uid: data['uid'] ?? doc.id,
      name: data['name'] ?? '',
      avatar: data['avatar'] ?? '',
      score: (data['score'] ?? 0) as int,
      correctAnswers: (data['correctAnswers'] ?? 0) as int,
      answerCount: (data['answerCount'] ?? 0) as int,
      lastAnsweredAt: (data['lastAnsweredAt'] as Timestamp?)?.toDate(),
    );
  }
}