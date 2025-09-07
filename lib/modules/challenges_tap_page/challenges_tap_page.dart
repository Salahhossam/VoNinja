import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vo_ninja/modules/events_page/events_page.dart';
import '../../generated/l10n.dart';
import '../../shared/network/local/cash_helper.dart';
import '../../shared/style/color.dart';
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
        setState(() {
          isLoading = false;
        });
      });
    });
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
                            return Column(
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
