// lib/shared/tutorial_keys.dart
import 'package:flutter/material.dart';

class TutorialKeysBundle {
  // Home keys
  final GlobalKey scoreCardKey = GlobalKey(debugLabel: 'scoreCard');
  final GlobalKey adsIconKey   = GlobalKey(debugLabel: 'adsIcon');
  final GlobalKey libraryKey   = GlobalKey(debugLabel: 'library');

  // Bottom nav keys
  final GlobalKey navLearnKey       = GlobalKey(debugLabel: 'navLearn');
  final GlobalKey navLeaderboardKey = GlobalKey(debugLabel: 'navLeaderboard');
  final GlobalKey navTreasureKey    = GlobalKey(debugLabel: 'navTreasure');
  final GlobalKey navSettingsKey    = GlobalKey(debugLabel: 'navSettings');

  final GlobalKey basicLearnLevelKey    = GlobalKey(debugLabel: 'basicLearnLevelKey');

}
