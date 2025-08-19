import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/generated/l10n.dart';
import 'package:vo_ninja/modules/challenges_page/task_cubit/task_cubit.dart';
import 'package:vo_ninja/modules/challenges_page/task_cubit/task_state.dart';
import 'package:vo_ninja/modules/challenges_page/task_page.dart';
import 'package:vo_ninja/modules/taps_page/taps_cubit/taps_cubit.dart';
import 'package:vo_ninja/shared/main_cubit/cubit.dart';
import 'package:vo_ninja/shared/style/color.dart';

import '../../shared/network/local/cash_helper.dart';
import '../taps_page/taps_page.dart';
import 'challenges_rank_dialog.dart';

class EndChallenges extends StatefulWidget {
  final String taskId;
  final String challengeId;
  final String title;
  final String challengesName;
  final double rewardPoints;
  final DateTime challengesRemainingTime;
  final double subscriptionCostPoints;
  final String status;
  final double challengesNumberOfTasks;
  final double numberOfQuestion;
  final double challengesNumberOfSubscriptions;

  const EndChallenges(
      {super.key,
      required this.taskId,
      required this.challengeId,
      required this.title,
      required this.challengesName,
      required this.rewardPoints,
      required this.challengesRemainingTime,
      required this.subscriptionCostPoints,
      required this.status,
      required this.challengesNumberOfTasks,
      required this.numberOfQuestion,
      required this.challengesNumberOfSubscriptions});

  @override
  State<EndChallenges> createState() => _EndChallengesState();
}

class _EndChallengesState extends State<EndChallenges> {
  bool isLoading = false;
  String? uid;

  @override
  void initState() {
    super.initState();
    initData();

  }

  Future<void> initData() async {
    final taskCubit = TaskCubit.get(context);
    final mainCubit = MainAppCubit.get(context);
    setState(() {
      isLoading = true;
    });
    taskCubit.currentQuestionIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        // Wait until UID is retrieved
        uid = await CashHelper.getData(key: 'uid');
        await taskCubit.getUserRank(uid!, widget.challengeId);

        mainCubit.rewardAds();
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskCubit = TaskCubit.get(context);
    final mainCubit = MainAppCubit.get(context);
    uid = CashHelper.getData(key: 'uid');

    return BlocConsumer<TaskCubit, TaskState>(
        listener: (BuildContext context, TaskState state) {},
        builder: (BuildContext context, TaskState state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.lightColor,
              body: isLoading
                  ? const Center(
                      child: Image(
                        image: AssetImage('assets/img/ninja_gif.gif'),
                        height: 100,
                        width: 100,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * .75,
                            decoration: const BoxDecoration(
                              color: AppColors.mainColor, // Blue color
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                // Rounded bottom-left
                                bottomRight:
                                    Radius.circular(30), // Rounded bottom-right
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(22.0),
                                      child: Container(
                                        height: 4, // Height of the blue line
                                        decoration: BoxDecoration(
                                          color: AppColors.secondColor,
                                          borderRadius: BorderRadius.circular(
                                              2), // Rounded corners
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 100),
                                    Image.asset(
                                      'assets/img/Challenge.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${taskCubit.userPoints}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      S.of(context).points, // Static text
                                      style: const TextStyle(
                                        color: Color.fromRGBO(128, 128, 128, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 60),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 22),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondColor,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Text(
                                              '${taskCubit.rank}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      LeaderboardDialog(
                                                          challengeId: widget
                                                              .challengeId),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.secondColor,
                                                padding:
                                                    const EdgeInsets.all(20),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              child:  Center(
                                                child: Text(
                                                  S.of(context).showRanks,
                                                  style: const TextStyle(
                                                      color:
                                                          AppColors.whiteColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if(taskCubit.canShowAd)
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: ()  async {
                                          await taskCubit.rewardedInterstitialAd(uid!, widget.challengeId, widget.taskId);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondColor,
                                          padding: const EdgeInsets.all(20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Center(
                                              child: Text(
                                                S.of(context).plus20Points,
                                                style: const TextStyle(
                                                    color: AppColors.whiteColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const Positioned(
                                              right: 0,
                                              child: Icon(
                                                Icons.play_circle_outline,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      TapsCubit.get(context).selectTab(0);
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TapsPage()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.mainColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                    ),
                                    child: Text(
                                      S.of(context).backToHome,
                                      style: const TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => TaskPage(
                                                  challengesName:
                                                      widget.challengesName,
                                                  challengeId:
                                                      widget.challengeId,
                                                  rewardPoints:
                                                      widget.rewardPoints,
                                                  challengesRemainingTime: widget
                                                      .challengesRemainingTime,
                                                  subscriptionCostPoints: widget
                                                      .subscriptionCostPoints,
                                                  status: widget.status,
                                                  challengesNumberOfTasks: widget
                                                      .challengesNumberOfTasks,
                                                  challengesNumberOfSubscriptions:
                                                      widget
                                                          .challengesNumberOfSubscriptions,
                                                  numberOfQuestion:
                                                      widget.numberOfQuestion,
                                                )),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.mainColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                    ),
                                    child: Text(
                                      S.of(context).nextLesson,
                                      style: const TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
            ),
          );
        });
  }
}
