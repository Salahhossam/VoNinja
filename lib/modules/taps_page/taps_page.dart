import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:vo_ninja/shared/style/color.dart';
import '../../generated/l10n.dart';
import '../../shared/constant/constant.dart';
import '../../shared/network/local/cash_helper.dart';
import 'taps_cubit/taps_cubit.dart';
import 'taps_cubit/taps_state.dart';

// NEW: مفاتيح موحّدة
import 'package:vo_ninja/shared/tutorial_keys.dart';

class TapsPage extends StatefulWidget {
  const TapsPage({super.key});
  @override
  State<TapsPage> createState() => _TapsPageState();
}

class _TapsPageState extends State<TapsPage> {
  // مفاتيح البوتوم ناف: بنستخدم المفاتيح الموحدة من tutorial_keys.dart

  TutorialCoachMark? _coach;
  int _step = 1;
  static const int kUnifiedSteps = 7; // 3 (Home) + 4 (Tabs)
  bool _unifiedScheduled = false;
  late final TutorialKeysBundle k;
  @override
  void initState() {
    super.initState();
    k = TutorialKeysBundle();
    final cubit = TapsCubit.get(context);
    cubit.bindTutorialKeys(k); // <-- دي الأهم
    cubit.updateActiveStatus(true);

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (firebaseAuth.currentUser != null) {
        if ("$message".contains('resume')) cubit.updateActiveStatus(true);
        if ("$message".contains('pause'))  cubit.updateActiveStatus(false);
      }
      return Future.value(message);
    });

  }

  Future<void> _maybeShowUnifiedTutorial({bool force = false}) async {
    if (!force && _unifiedScheduled) return;
    _unifiedScheduled = true;

    final seen =await CashHelper.getData(key: 'tutorial1') == true;
    if (seen && !force) return;

    final cubit = TapsCubit.get(context);

    // لازم نكون على تبويب الهوم علشان عناصر الهوم تكون موجودة في الشجرة
    if (cubit.currentIndex != 0) {
      cubit.selectTab(0);
      await Future.delayed(const Duration(milliseconds: 150));
    }

    // ادي فريم يتبني
    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    await _showUnifiedTutorial(context);
  }

  Widget _rtlBubble({
    required String title,
    required String body,
    required String stepText,
    required VoidCallback onNext,
    VoidCallback? onBack,
    required VoidCallback onSkip,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.secondColor.withOpacity(.25), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.mainColor)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.secondColor.withOpacity(.25)),
                  ),
                  child: Text(stepText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(body, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(isLast ? "إنهاء" : "التالي"),
                ),
                const SizedBox(width: 8),
                TextButton(onPressed: isFirst ? null : onBack, child: const Text("رجوع")),
                const Spacer(),
                TextButton(onPressed: onSkip, child: const Text("تخطي")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showUnifiedTutorial(BuildContext context) async {
    _step = 1;
    final cubit = TapsCubit.get(context);
    // --- 3 خطوات للهوم ---
    final homeItems = [
      (key: k.scoreCardKey, title: "نقاطك & ترتيبك", body: "ملخص نقاطك (Score) وترتيبك (Rank). كل إجابة صحيحة تزود الرصيد."),
      (key: k.adsIconKey,   title: "مكافآت الإعلانات", body: "لو الإعلان متاح، شغّله وخد مكافأة فورية حسب القواعد."),
      (key: k.libraryKey,   title: "Voninja Library",   body: "محتوى إضافي يساعدك تتعلم أسرع وبأسلوب ممتع."),
    ];

    // --- 4 خطوات للتابس ---
    final tabsItems = [
      (key: k.navLearnKey,       title: "Learn (التعلّم)",         body: "هنا المستويات، التحديات، والفعاليات."),
      (key: k.navLeaderboardKey, title: "Leaderboard (المتصدرون)", body: "تابع ترتيبك، واطلب كوبون لو وصلت #1 (التفاصيل في الإعدادات)."),
      (key: k.navTreasureKey,    title: "Treasures (الكنوز)",       body: "افتح كنوز عشوائية لمكافآت مختلفة."),
      (key: k.navSettingsKey,    title: "Settings (الإعدادات)",     body: "حوّل النقاط لفلوس، واقرأ الدليل، وتواصل مع الدعم."),
    ];

    final all = <({GlobalKey key, String title, String body})>[
      for (var it in homeItems) (key: it.key, title: it.title, body: it.body),
      for (var it in tabsItems) (key: it.key, title: it.title, body: it.body),
    ];

    assert(all.length == kUnifiedSteps, "Unified tutorial must be exactly 7 steps.");
    const total = kUnifiedSteps;

    final targets = List<TargetFocus>.generate(all.length, (i) {
      final idx = i + 1;
      final isFirst = idx == 1;
      final isLast  = idx == total;
      final it = all[i];

      final isHomePart = idx <= homeItems.length;
      final shape = isHomePart ? ShapeLightFocus.RRect : ShapeLightFocus.Circle;

      return TargetFocus(
        identify: "unified_step_$idx",
        keyTarget: it.key,
        enableOverlayTab: false,
        shape: shape,
        radius: isHomePart ? 14.0 : null,
        color: AppColors.mainColor.withOpacity(.80),
        contents: [
          TargetContent(
            align: isHomePart ? ContentAlign.bottom : ContentAlign.top,
            child: _rtlBubble(
              title: it.title,
              body: it.body,
              stepText: "$idx/$total",
              isFirst: isFirst,
              isLast: isLast,
              onSkip: () => _coach?.skip(),
              onBack: isFirst ? null : () {
                setState(() => _step--);
                _coach?.previous();
              },
              onNext: () {
                if (isLast) {
                  _coach?.finish();
                } else {
                  setState(() => _step++);
                  _coach?.next();
                }
              },
            ),
          ),
        ],
      );
    });

    _coach = TutorialCoachMark(
      targets: targets,
      hideSkip: true,
      textSkip: "تخطي",
      onFinish: () async {
        await CashHelper.saveData(key: 'tutorial1', value: true);
        cubit.selectTab(1);
      },
      onSkip: ()  {
        unawaited(CashHelper.saveData(key: 'tutorial1', value: true)) ;
        cubit.selectTab(1);
        return true;
      },
    );

    _coach!.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = TapsCubit.get(context);
    final s = S.of(context);

    return BlocConsumer<TapsCubit, TapsState>(
      listener: (context, state) async {
        if (state is SelectTapError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.select_tap_error)));
        }
        // NEW: أول ما يجيلنا سيجنال من الهوم → اعرض التوتريال الموحّد
        if (state is UnifiedTutorialRequested) {
          await _maybeShowUnifiedTutorial(force: true);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.lightColor,
            body: cubit.pages[cubit.currentIndex],
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              child: BottomNavigationBar(
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color(0xFF1A3037),
                unselectedItemColor: const Color(0xFFDBDEDE),
                selectedItemColor: AppColors.secondColor,
                showSelectedLabels: true,
                items: <BottomNavigationBarItem>[
                  _buildNavBarItem(icon: Icons.home,        label: s.nav_home,        isSelected: cubit.currentIndex == 0),
                  _buildNavBarItem(icon: Icons.school,      label: s.nav_learn,       isSelected: cubit.currentIndex == 1, itemKey: k.navLearnKey),
                  _buildNavBarItem(icon: Icons.leaderboard, label: s.nav_leaderboard, isSelected: cubit.currentIndex == 2, itemKey: k.navLeaderboardKey),
                  _buildNavBarItem(icon: Icons.diamond,     label: s.nav_treasure,    isSelected: cubit.currentIndex == 3, itemKey: k.navTreasureKey),
                  _buildNavBarItem(icon: Icons.settings,    label: s.nav_settings,    isSelected: cubit.currentIndex == 4, itemKey: k.navSettingsKey),
                ],
                currentIndex: cubit.currentIndex,
                onTap: (index) => cubit.selectTab(index),
              ),
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavBarItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    Key? itemKey,
  }) {
    final Widget baseIcon = isSelected
        ? Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFDBDEDE)),
      child: Icon(icon, color: const Color(0xFF1A3037)),
    )
        : Icon(icon);

    return BottomNavigationBarItem(
      icon: KeyedSubtree(
        key: itemKey,
        child: baseIcon,
      ),
      label: label,
    );
  }
}
