import 'package:flutter/cupertino.dart';

import '../../../shared/constant/constant.dart';
import '../../../shared/network/local/cash_helper.dart';
import '../../challenges_tap_page/challenges_tap_page.dart';
import '../../home_tap_page/home_tap_page.dart';
import '../../leaderboard_tap_page/leaderboard_tap_page.dart';
import '../../settings_tap_page/settings_tap_page.dart';
import '../../treasure_boxes_page/treasure_boxes_page.dart';
import 'taps_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TapsCubit extends Cubit<TapsState> {
  TapsCubit() : super(TapsInitial());

  static TapsCubit get(context) => BlocProvider.of(context);

  final List<Widget> pages = [
    const HomeTapPage(),
    const ChallengesTapPage(),
    const LeaderboardPage(),
    const TreasureBoxesPage(),
    const SettingsTapPage(),
  ];

  int _currentIndex = 0;

  void selectTab(int index) {
    _currentIndex = index;
    emit(SelectTapLoaded(index));
  }

  int get currentIndex => _currentIndex;

  Future<void> updateActiveStatus(bool isOnline) async {
    String uid = await CashHelper.getData(key: 'uid');
    await fireStore.collection('users').doc(uid).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now()

    });
    emit(UpdateActiveStatusSuccess());
  }

  void requestUnifiedTutorial() {
    emit(UnifiedTutorialRequested());
  }
}
