
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ntp/ntp.dart';
import 'package:vo_ninja/modules/challenges_page/task_page.dart';
import 'package:vo_ninja/shared/style/color.dart';
import 'package:vo_ninja/modules/taps_page/taps_page.dart';

import '../../generated/l10n.dart';
import '../../models/challenge_model.dart';
import '../../shared/companent.dart';
import '../../shared/network/local/cash_helper.dart';
import '../home_tap_page/home_tap_cubit/home_tap_cubit.dart';
import 'challenges_card.dart';
import 'challenges_cubit/challenges_cubit.dart';
import 'challenges_cubit/challenges_state.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  bool isLoading = false;
  bool isLoading2 = false;
  bool isLoading3 = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    final challengeCubit = ChallengeCubit.get(context);
    setState(() {
      isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        String? uid;
        uid = await CashHelper.getData(key: 'uid');
        await challengeCubit.getChallengePageData(uid!);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final challengeCubit = ChallengeCubit.get(context);
    return BlocConsumer<ChallengeCubit, ChallengeState>(
      listener: (BuildContext context, ChallengeState state) {},
      builder: (BuildContext context, ChallengeState state) {
        return Scaffold(
          backgroundColor: AppColors.mainColor,
          appBar: AppBar(
            backgroundColor: AppColors.mainColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const TapsPage()),
                );
              },
            ),
            title: Text(
              S.of(context).challenges,
              style: const TextStyle(fontSize: 24, color: AppColors.lightColor),
            ),
            centerTitle: true,
          ),
          body: WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const TapsPage()),
              );
              return true;
            },
            child: isLoading
                ? const Center(
                    child: Image(
                                                image: AssetImage(
                                                    'assets/img/ninja_gif.gif'),
                                                height: 100,
                                                width: 100,
                                              ),
                  )
                : LoadingOverlay(
                    isLoading: isLoading2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 15),
                            decoration: const BoxDecoration(
                              color: AppColors.lightColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35),
                              ),
                            ),
                            child: BlocBuilder<ChallengeCubit, ChallengeState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 16),
                                    Image.asset(
                                      'assets/img/Challenge.png',
                                      // Replace with your image path
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      S.of(context).gainPointsChallenges,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(20),
                                        itemCount:
                                            challengeCubit.challenges.length,
                                        itemBuilder: (context, index) {
                                          final challenges =
                                              challengeCubit.challenges[index];
                                          return InkWell(
                                            onTap: () async {
                                              setState(() {
                                                isLoading2 = true;
                                              });


                                                bool userExist =
                                                    await challengeCubit
                                                        .checkUserExistInChallenge(
                                                            HomeTapCubit.get(
                                                                        context)
                                                                    .userData
                                                                    ?.userId ??
                                                                '',
                                                            challenges
                                                                .challengeId!);

                                                if (userExist) {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TaskPage(
                                                        challengesName:
                                                            challenges.title!,
                                                        challengeId: challenges
                                                            .challengeId!,
                                                        rewardPoints: challenges
                                                            .rewardPoints!,
                                                        subscriptionCostPoints:
                                                            challenges
                                                                .subscriptionPoints!,
                                                        status:
                                                            challenges.status!,
                                                        challengesNumberOfTasks:
                                                            challenges
                                                                .numberOfTasks!,
                                                        challengesNumberOfSubscriptions:
                                                            challenges
                                                                .numberOfSubscriptions!,
                                                        numberOfQuestion:
                                                            challenges
                                                                .totalQuestions!,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                else {
                                                  _showChallengeDialog(
                                                      context, challenges);
                                                }


                                              setState(() {
                                                isLoading2 = false;
                                              });
                                            },
                                            child: ChallengeCard(
                                              challengesName: challenges.title!,
                                              challengeId:
                                                  challenges.challengeId!,
                                              rewardPoints:
                                                  challenges.rewardPoints!,
                                              subscriptionCostPoints: challenges
                                                  .subscriptionPoints!,
                                              status: challenges.status!,
                                              challengesNumberOfTasks:
                                                  challenges.numberOfTasks!,
                                              challengesNumberOfSubscriptions:
                                                  challenges
                                                      .numberOfSubscriptions!,
                                              numberOfQuestion:
                                                  challenges.totalQuestions!,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
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

  void _showChallengeDialog(BuildContext context, Challenge challenge) {
    final challengeCubit = ChallengeCubit.get(context);
    bool isLoading3 = false;
    showDialog(
      context: context,
      builder: (context) {
        return BlocConsumer<ChallengeCubit, ChallengeState>(
            listener: (BuildContext context, ChallengeState state) {},
            builder: (BuildContext context, ChallengeState state) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                insetPadding: const EdgeInsets.all(20),
                content: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor, // Dark background
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondColor
                            .withOpacity(1), // Shadow color
                        spreadRadius: 3, // Spread of the shadow
                        blurRadius: 2, // Blur effect
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // This makes the dialog fit content

                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Circular Badge for Lesson Number
                      Image.asset(
                        'assets/img/Challenge.png', // Replace with your image path
                        width: 50,
                        height: 50,
                        // color: AppColors.lightColor, // Make the icon white
                      ),
                      const SizedBox(height: 10),
                      // Lesson Name
                      Text(
                        challenge.title!,
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildInfoCard(
                        context,
                        challenge.subscriptionPoints!,
                      ),
                      const SizedBox(height: 15),
                      isLoading3
                          ? const Center(
                              child: Image(
                                                image: AssetImage(
                                                    'assets/img/ninja_gif.gif'),
                                                height: 100,
                                                width: 100,
                                              ),
                            )
                          : _buildActionButton(
                              context,
                              S.of(context).subscribeInChallenge,
                              AppColors.secondColor, () async {
                              setState(() {
                                isLoading3 = true;
                              });

                              double userPoints = await challengeCubit
                                  .getUserPoints(HomeTapCubit.get(context)
                                          .userData
                                          ?.userId ??
                                      '');
                              if (userPoints >= challenge.subscriptionPoints!) {
                                await challengeCubit.addUserInChallenge(
                                    HomeTapCubit.get(context)
                                            .userData
                                            ?.userId ??
                                        '',
                                    challenge.challengeId!,
                                    userPoints,
                                    challenge.subscriptionPoints!,
                                    HomeTapCubit.get(context)
                                            .userData
                                            ?.userName ??
                                        '');
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => TaskPage(
                                      challengesName: challenge.title!,
                                      challengeId: challenge.challengeId!,
                                      rewardPoints: challenge.rewardPoints!,
                                      subscriptionCostPoints:
                                          challenge.subscriptionPoints!,
                                      status: challenge.status!,
                                      challengesNumberOfTasks:
                                          challenge.numberOfTasks!,
                                      challengesNumberOfSubscriptions:
                                          challenge.numberOfSubscriptions! + 1,
                                      numberOfQuestion:
                                          challenge.totalQuestions!,
                                    ),
                                  ),
                                );
                              } else {
                                setState(() {
                                  isLoading3 = false;
                                });
                                showErrorDialog(
                                  context,
                                  title: 'Insufficient Points',
                                  desc: 'You don’t have enough points to subscribe!',
                                  onOkPressed: () {},
                                );
                              }
                            }, Colors.white)
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  Widget _buildActionButton(BuildContext context, String label,
      Color backgroundColor, void Function()? onPressed, Color textColor) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed, // Close dialog on press
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Text(
          label,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildInfoCard(context, double subscriptionCostPoints) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.lightColor, // Light color background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: AppColors.mainColor, size: 30),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              S.of(context).minmaPoints(subscriptionCostPoints.toInt()),
              style: const TextStyle(
                color: AppColors.mainColor,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRanks(Color containerColor, String placeNumber,
      double rankPointsNumber, context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Text(
            '$placeNumber ${S.of(context).placeNumber}',
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          const Spacer(),
          Text(
            '${rankPointsNumber.toInt()} ${S.of(context).rankPointsNumber}',
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
