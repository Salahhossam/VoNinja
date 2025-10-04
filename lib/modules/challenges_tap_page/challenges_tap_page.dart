import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:vo_ninja/modules/events_page/events_page.dart';
import '../../generated/l10n.dart';
import '../../shared/network/local/cash_helper.dart';
import '../../shared/style/color.dart';
import '../../shared/tutorial_keys.dart';
import '../challenges_page/challenges_page.dart';
import '../taps_page/taps_cubit/taps_cubit.dart';
import 'challenges_cubit/challenges_tap_cubit.dart';
import 'challenges_cubit/challenges_tap_state.dart';
import 'challenges_tap_card.dart';

class ChallengesTapPage extends StatefulWidget {
  const ChallengesTapPage({super.key});

  @override
  State<ChallengesTapPage> createState() => _ChallengesTapPageState();
}

class _ChallengesTapPageState extends State<ChallengesTapPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<Color?> _imageBackgroundColorAnimation;

  TutorialCoachMark? _coach;
  int _step = 1;
  @override
  void initState() {
    super.initState();
    initData();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Create a color animation that changes between two colors (light to dark)
    _imageBackgroundColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: AppColors.lightColor, // Change to the color you want
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start the animation to make the background pulse
    _animationController.repeat(reverse: true);
  }

  Future<void> initData() async {
    final challengeTapCubit = ChallengeTapCubit.get(context);
    setState(() {
      isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        String? uid;

        // Wait until UID is retrieved
        uid = await CashHelper.getData(key: 'uid');

        await challengeTapCubit.getLevelsData(uid!);
        // print(challengeTapCubit.levelsData.length);
        // print('777777777777777777777');
        final seenUnified = await CashHelper.getData(key: 'tutorial2') == true;
        setState(() {
          isLoading = false;
        });

        if (!seenUnified && mounted) {
          // سيب الـ UI يترسم كويس
          await Future.delayed(const Duration(milliseconds: 350));
          _showUnifiedTutorial(context);

        }
      });
    });
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


    final all = [ (key: basicLearnLevelKey,title: ":Basic قسم �",body: " !هذه خطوتك الأولي في رحلة التعلم .Voninja ابدأ أول دروسك من هنا وادخل عالم"),];


    const total = 1;

    final targets = List<TargetFocus>.generate(all.length, (i) {
      final idx = i + 1;
      final isFirst = idx == 1;
      final isLast  = idx == total;
      final it = all[i];


      final shape = ShapeLightFocus.Circle;

      return TargetFocus(
        identify: "unified_step_$idx",
        keyTarget: it.key,
        enableOverlayTab: false,
        shape: shape,
        radius: null,
        color: AppColors.mainColor.withOpacity(.80),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
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
        await CashHelper.saveData(key: 'tutorial2', value: true);
      },
      onSkip: ()  {
        unawaited(CashHelper.saveData(key: 'tutorial2', value: true)) ;
        return true;
      },
    );

    _coach!.show(context: context);
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challengeTapCubit = ChallengeTapCubit.get(context);
    return BlocConsumer<ChallengeTapCubit, ChallengeTapState>(
      listener: (BuildContext context, ChallengeTapState state) {},
      builder: (BuildContext context, ChallengeTapState state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.lightColor,
            body: WillPopScope(
              onWillPop: () async {
                TapsCubit.get(context).selectTab(0);

                return false;
              },
              child: isLoading
                  ? const Center(
                      child: Image(
                      image: AssetImage('assets/img/ninja_gif.gif'),
                      height: 100,
                      width: 100,
                    ))
                  : ListView(
                      children: [
                        const SizedBox(height: 24,),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0),
                          itemCount: challengeTapCubit.levelsData.length,
                          itemBuilder: (context, index) {
                            final challengesTap =
                            challengeTapCubit.levelsData[index];
                            return Container(
                              key: index == 0 ? basicLearnLevelKey : null,
                              child: Column(
                                children: [
                                  ChallengesTapCard(
                                    levelId: challengesTap.levelId,
                                    levelDifficulty:
                                    challengesTap.levelDifficulty,
                                    rewardedPoints:
                                    challengesTap.rewardedPoints,
                                    numberOfLessons:
                                    challengesTap.numberOfLessons,
                                    levelProgress:
                                    challengesTap.levelProgress,
                                    canTab: index == 0 ||
                                        challengesTap.levelProgress == 1.0 ||
                                        (challengesTap.canTap != null && challengesTap.canTap!) ||
                                        (index > 0 &&
                                            challengeTapCubit.levelsData[index - 1].levelProgress == 1.0),
                                    previousTile: index != 0?challengeTapCubit.levelsData[index-1].levelDifficulty:null,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            );
                          },
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const ChallengesPage(),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text and Icon Row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text Section
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              S.of(context).joinChallengesEarnPoints,
                                              style: const TextStyle(
                                                color: AppColors.whiteColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              S.of(context).completeDailyChallenges,
                                              style: const TextStyle(
                                                color: AppColors.whiteColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Fire Icon Section
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.secondColor.withOpacity(0.7),
                                                spreadRadius: 0,
                                                blurRadius: 15,
                                              ),
                                            ],
                                          ),
                                          child: AnimatedBuilder(
                                            animation: _animationController,
                                            builder: (context, child) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  color: _imageBackgroundColorAnimation.value,
                                                ),
                                                child: Icon(
                                                  Icons.local_fire_department,
                                                  color: Colors.orange,
                                                  size: MediaQuery.of(context).size.width * 0.12,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Button Section
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => const ChallengesPage(),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondColor,
                                      foregroundColor: AppColors.whiteColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    ),
                                    child: Text(
                                      S.of(context).viewAllChallenges,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const EventsPage(),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0, left: 16, right: 16),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text and Icon Row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text Section
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              S.of(context).discoverExcitingEvents,
                                              style: const TextStyle(
                                                color: AppColors.whiteColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              S.of(context).participateSpecialEvents,
                                              style: const TextStyle(
                                                color: AppColors.whiteColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Star Icon Section
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.secondColor.withOpacity(0.7),
                                                spreadRadius: 0,
                                                blurRadius: 15,
                                              ),
                                            ],
                                          ),
                                          child: AnimatedBuilder(
                                            animation: _animationController,
                                            builder: (context, child) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    color: _imageBackgroundColorAnimation.value,
                                                  ),
                                                  child: Icon(
                                                    FontAwesomeIcons.dragon,
                                                    color: Colors.yellow,
                                                    size: MediaQuery.of(context).size.width * 0.12,
                                                  )
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Button Section
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => const EventsPage(),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondColor,
                                      foregroundColor: AppColors.whiteColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    ),
                                    child: Text(
                                      S.of(context).viewAllEvents,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
