import 'package:cloud_firestore/cloud_firestore.dart';

enum EventType { welcome, multiplier, targetPoints, quiz }

EventType eventTypeFromString(String s) {
  switch (s) {
    case 'welcome': return EventType.welcome;
    case 'multiplier': return EventType.multiplier;
    case 'target_points': return EventType.targetPoints;
    case 'quiz': return EventType.quiz;
    default: return EventType.welcome;
  }
}

class AppEvent {
  final String id;
  final EventType type;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime? startAt; // null in welcome template
  final DateTime? endAt;   // null in welcome template
  final Map<String, dynamic> rules;

  AppEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.rules,
    this.startAt,
    this.endAt,
  });

  factory AppEvent.fromDoc(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return AppEvent(
      id: doc.id,
      type: eventTypeFromString(data['type'] as String),
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      rules: Map<String, dynamic>.from(data['rules'] ?? {}),
      startAt: (data['startAt'] as Timestamp?)?.toDate(),
      endAt: (data['endAt'] as Timestamp?)?.toDate(),
    );
  }

  bool isActiveNow(DateTime now, {DateTime? userStart, DateTime? userEnd}) {
    if (type == EventType.welcome) {
      if (userStart == null || userEnd == null) return false;
      return now.isAfter(userStart) && now.isBefore(userEnd);
    }
    if (startAt == null || endAt == null) return false;
    return now.isAfter(startAt!) && now.isBefore(endAt!);
  }

  bool isUpcoming(DateTime now, {DateTime? userStart, DateTime? userEnd}) {
    if (type == EventType.welcome) {
      if (userStart == null) return false;
      return now.isBefore(userStart);
    }
    if (startAt == null) return false;
    return now.isBefore(startAt!);
  }
}

class UserEventProgress {
  final String eventId;
  final EventType type;
  final String status; // not_joined, in_progress, completed, reward_claimed, expired
  final DateTime? userStartAt;
  final DateTime? userEndAt;
  final int pointsAccumulated;
  final int correctAnswers;
  final int rewardPoints;

  UserEventProgress({
    required this.eventId,
    required this.type,
    required this.status,
    required this.pointsAccumulated,
    required this.correctAnswers,
    required this.rewardPoints,
    this.userStartAt,
    this.userEndAt,
  });

  factory UserEventProgress.fromDoc(DocumentSnapshot doc) {
    final d = doc.data()! as Map<String, dynamic>;
    return UserEventProgress(
      eventId: doc.id,
      type: eventTypeFromString(d['eventType']),
      status: d['status'],
      pointsAccumulated: (d['progress']?['pointsAccumulated'] ?? 0) as int,
      correctAnswers: (d['progress']?['correctAnswers'] ?? 0) as int,
      rewardPoints: (d['rewardPoints'] ?? 0) as int,
      userStartAt: (d['userStartAt'] as Timestamp?)?.toDate(),
      userEndAt: (d['userEndAt'] as Timestamp?)?.toDate(),
    );
  }
}
