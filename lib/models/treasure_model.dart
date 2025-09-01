import 'package:flutter/material.dart';

enum TreasureTier { bronze, silver, gold }

extension TierMeta on TreasureTier {
  String get title => switch (this) {
    TreasureTier.bronze => 'Bronze',
    TreasureTier.silver => 'Silver',
    TreasureTier.gold => 'Gold',
  };

  // String get closedImg => switch (this) {
  //   TreasureTier.bronze => 'assets/boxes/bronze_closed.png',
  //   TreasureTier.silver => 'assets/boxes/silver_closed.png',
  //   TreasureTier.gold => 'assets/boxes/gold_closed.png',
  // };
  //
  // String get openImg => switch (this) {
  //   TreasureTier.bronze => 'assets/boxes/bronze_open.png',
  //   TreasureTier.silver => 'assets/boxes/silver_open.png',
  //   TreasureTier.gold => 'assets/boxes/gold_open.png',
  // };

  String get closedImg => switch (this) {
    TreasureTier.bronze => 'assets/img/ADs.png',
    TreasureTier.silver => 'assets/img/ADs.png',
    TreasureTier.gold => 'assets/img/ADs.png',
  };

  String get openImg => switch (this) {
    TreasureTier.bronze => 'assets/img/ADs.png',
    TreasureTier.silver => 'assets/img/ADs.png',
    TreasureTier.gold => 'assets/img/ADs.png',
  };
}


class BoxCondition {
  /// إن كانت null يعني الشرط غير مطلوب
  final int? minPoints; // مثال: 600
  final int? minAds;    // مثال: 3

  const BoxCondition({this.minPoints, this.minAds});

  bool isSatisfied({required int points, required int ads}) {
    final okPoints = (minPoints == null) || (points >= minPoints!);
    final okAds = (minAds == null) || (ads >= minAds!);
    return okPoints && okAds; // AND
  }

  bool get requiresAds => (minAds ?? 0) > 0;
  bool get requiresPoints => (minPoints ?? 0) > 0;
}


class TreasureBox {
  final int index;            // 0..19
  final int rewardPoints;     // المكافأة
  final BoxCondition condition;

  const TreasureBox({
    required this.index,
    required this.rewardPoints,
    required this.condition,
  });
}