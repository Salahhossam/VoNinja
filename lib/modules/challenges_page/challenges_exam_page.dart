import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:vo_ninja/modules/challenges_page/task_cubit/task_cubit.dart';
import 'package:vo_ninja/modules/challenges_page/task_cubit/task_state.dart';
import 'package:vo_ninja/modules/challenges_page/task_page.dart';
import '../../generated/l10n.dart';
import '../../shared/main_cubit/cubit.dart';
import '../../shared/network/local/cash_helper.dart';
import '../../shared/style/color.dart';
import '../lessons_page/learning_cubit/learning_cubit.dart';

class ChallengesExamPage extends StatefulWidget {
  final String taskId;
  final String challengeId;
  final String title;
  final String challengesName;
  final double rewardPoints;
  final double deducePoints;
  final DateTime challengesRemainingTime;
  final double subscriptionCostPoints;
  final String status;
  final List<double> rankPoints;
  final double challengesNumberOfTasks;
  final double numberOfQuestion;
  final double challengesNumberOfSubscriptions;

  const ChallengesExamPage({
    super.key,
    required this.taskId,
    required this.title,
    required this.challengeId,
    required this.challengesName,
    required this.rewardPoints,
    required this.deducePoints,
    required this.challengesRemainingTime,
    required this.subscriptionCostPoints,
    required this.status,
    required this.rankPoints,
    required this.challengesNumberOfTasks,
    required this.numberOfQuestion,
    required this.challengesNumberOfSubscriptions,
  });

  @override
  State<ChallengesExamPage> createState() => _ChallengesExamPageState();
}

class _ChallengesExamPageState extends State<ChallengesExamPage> {
  bool isLoading = false;
  bool isLoadingAnswer = false;
  String? uid;
  final Map<String, List<String>> shuffledChoicesMap = {};

  BannerAd? myBannerTop;
  BannerAd? myBannerBottom;
  bool isTopBannerLoaded = false;
  bool isBottomBannerLoaded = false;
  void _initBannerAds() {
    // Top Banner
    myBannerTop = BannerAd(
      adUnitId: 'ca-app-pub-7223929122163665/1831803488', // استبدل بمعرف وحدة الإعلان الخاصة بك
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isTopBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // print('Failed to load a banner ad: ${error.message}');
          // print('Error code: ${error.code}');
          // print('Error domain: ${error.domain}');
          ad.dispose();
        },
      ),
    )..load();

    // Bottom Banner
    myBannerBottom = BannerAd(
      adUnitId: 'ca-app-pub-7223929122163665/1831803488', // استبدل بمعرف وحدة الإعلان الخاصة بك
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isBottomBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // print('Failed to load a banner ad: ${error.message}');
          // print('Error code: ${error.code}');
          // print('Error domain: ${error.domain}');
          ad.dispose();
        },
      ),
    )..load();
  }
  @override
  void initState() {
    super.initState();
    initData();
    final mainCubit = MainAppCubit.get(context);
    mainCubit.interstitialAd();
    _initBannerAds();
  }

  Future<void> initData() async {
    final taskCubit = TaskCubit.get(context);
    setState(() {
      isLoading = true;
    });
    taskCubit.currentQuestionIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        // Wait until UID is retrieved
        uid = await CashHelper.getData(key: 'uid');
        await taskCubit.getTotalUserPoints(uid!);
        await taskCubit.getTasksDetailsData(
            uid!, widget.challengeId, widget.taskId);
        await taskCubit.getUserPreviousAnswers(uid!, widget.taskId);
        await taskCubit.getUserPoints(uid!, widget.challengeId);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskCubit = TaskCubit.get(context);
    final learningCubit = LearningCubit.get(context);
    return BlocConsumer<TaskCubit, TaskState>(
      listener: (BuildContext context, TaskState state) {},
      builder: (BuildContext context, TaskState state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.lightColor,
            body: LoadingOverlay(
              isLoading: isLoadingAnswer,
              progressIndicator: Image.asset(
                'assets/img/ninja_gif.gif',
                height: 100,
                width: 100,
              ),
              child: WillPopScope(
                onWillPop: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => TaskPage(
                              challengesName: widget.challengesName,
                              challengeId: widget.challengeId,
                              rewardPoints: widget.rewardPoints,
                              deducePoints: widget.deducePoints,
                              challengesRemainingTime:
                                  widget.challengesRemainingTime,
                              subscriptionCostPoints:
                                  widget.subscriptionCostPoints,
                              status: widget.status,
                              rankPoints: widget.rankPoints,
                              challengesNumberOfTasks:
                                  widget.challengesNumberOfTasks,
                              challengesNumberOfSubscriptions:
                                  widget.challengesNumberOfSubscriptions,
                              numberOfQuestion: widget.numberOfQuestion,
                            )),
                  );

                  return true;
                },
                child: isLoading
                    ? const Center(
                        child: Image(
                          image: AssetImage('assets/img/ninja_gif.gif'),
                          height: 100,
                          width: 100,
                        ),
                      )
                    : BlocBuilder<TaskCubit, TaskState>(
                      builder: (context, state) {
                        var currentQuestion = taskCubit
                            .questions[taskCubit.currentQuestionIndex];



                        if (!shuffledChoicesMap
                            .containsKey(currentQuestion.questionId)) {
                          final originalChoices =
                              List<String>.from(currentQuestion.choices);
                          originalChoices.shuffle(Random());
                          shuffledChoicesMap[currentQuestion.questionId] =
                              originalChoices;

                        }
                        final shuffledChoices =
                            shuffledChoicesMap[currentQuestion.questionId]!;

                        for (var choice in shuffledChoices) {

                        }

                        double progress =
                            (taskCubit.currentQuestionIndex + 1) /
                                taskCubit.questions.length;
                        Map<String, dynamic>? selectedAnswer =
                            taskCubit.previousAnswers.firstWhere(
                          (answer) =>
                              answer["questionId"] ==
                              currentQuestion.questionId,
                          orElse: () =>
                              {}, // Return an empty map instead of null
                        );
                        bool isPreviouslySelected =
                            selectedAnswer.isNotEmpty;
                        return Column(
                          children: [
                            if (isTopBannerLoaded && myBannerTop != null)
                              Container(
                                height: 60,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: AdWidget(ad: myBannerTop!),
                              ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  width: double.infinity,
                                  //height: MediaQuery.of(context).size.height * .75,
                                  decoration: const BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.close,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TaskPage(
                                                                challengesName:
                                                                    widget
                                                                        .challengesName,
                                                                challengeId: widget
                                                                    .challengeId,
                                                                rewardPoints: widget
                                                                    .rewardPoints,
                                                                deducePoints: widget
                                                                    .deducePoints,
                                                                challengesRemainingTime:
                                                                    widget
                                                                        .challengesRemainingTime,
                                                                subscriptionCostPoints:
                                                                    widget
                                                                        .subscriptionCostPoints,
                                                                status: widget
                                                                    .status,
                                                                rankPoints: widget
                                                                    .rankPoints,
                                                                challengesNumberOfTasks:
                                                                    widget
                                                                        .challengesNumberOfTasks,
                                                                challengesNumberOfSubscriptions:
                                                                    widget
                                                                        .challengesNumberOfSubscriptions,
                                                                numberOfQuestion:
                                                                    widget
                                                                        .numberOfQuestion,
                                                              )),
                                                    );
                                                  },
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "${taskCubit.currentQuestionIndex + 1} / ${taskCubit.questions.length}",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .6,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child:
                                                            LinearProgressIndicator(
                                                          value: progress,
                                                          backgroundColor:
                                                              const Color
                                                                  .fromRGBO(168,
                                                                  168, 168, 1),
                                                          color: AppColors
                                                              .secondColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColors.secondColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "${taskCubit.pointsToShowQuestionExam.toInt()}",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16),
                                                      ),
                                                      Text(
                                                        S.of(context).pts,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 8),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (currentQuestion.imageUrl !=
                                                null &&
                                                currentQuestion.imageUrl != '')
                                              const SizedBox(height: 10)
                                            else
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    .15,
                                              ),
                                            if (currentQuestion.imageUrl !=
                                                null &&
                                                currentQuestion.imageUrl != '')
                                              Center(
                                                child: CachedNetworkImage(
                                                  imageUrl: currentQuestion
                                                      .imageUrl ??
                                                      'http/',
                                                  height: 200,
                                                  width: 200,
                                                  placeholder: (context, url) =>
                                                  const SizedBox(
                                                    height:
                                                    30, // Adjust the size as needed
                                                    width: 30,
                                                    child: Center(
                                                        child: Image(
                                                          image: AssetImage(
                                                              'assets/img/ninja_gif.gif'),
                                                          height: 100,
                                                          width: 100,
                                                        )
                                                      // Thinner indicator
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                      error) =>
                                                  const Icon(Icons.error,
                                                      color: Colors.red,
                                                      size: 30),
                                                ),
                                              ),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    currentQuestion.content,
                                                    // Use the variable for dynamic content
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    learningCubit.speak(
                                                        currentQuestion.content,
                                                        "en-US");
                                                  },
                                                  icon: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: const Icon(
                                                      Icons.volume_up,
                                                      color: Color(0xff0a0a0a),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 50),
                                            ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    shuffledChoices.length,
                                                itemBuilder:
                                                    (context, index) {
                                                  final choice =
                                                      shuffledChoices[index];

                                                  Color borderColor =
                                                      AppColors.lightColor;
                                                  Color textColor =
                                                      Colors.white;
                                                  Color backgroundColor =
                                                      Colors.transparent;

                                                  // If the question was answered before (fetched from API)
                                                  if (isPreviouslySelected) {
                                                    if (choice.trim() ==
                                                        selectedAnswer[
                                                                "answerContent"]
                                                            .trim()) {
                                                      if (selectedAnswer[
                                                          "correct"]) {
                                                        borderColor =
                                                            Colors.green;
                                                        textColor =
                                                            Colors.green;
                                                        backgroundColor =
                                                            Colors.green
                                                                .withOpacity(
                                                                    0.1);
                                                      } else {
                                                        borderColor =
                                                            Colors.red;
                                                        textColor =
                                                            Colors.red;
                                                        backgroundColor =
                                                            Colors.red
                                                                .withOpacity(
                                                                    0.1);
                                                      }
                                                    } else if (choice
                                                            .trim() ==
                                                        currentQuestion
                                                            .correctAnswer
                                                            .trim()) {
                                                      borderColor =
                                                          Colors.green;
                                                      textColor =
                                                          Colors.green;
                                                      backgroundColor = Colors
                                                          .green
                                                          .withOpacity(0.1);
                                                    }
                                                  }

                                                  return InkWell(
                                                    onTap:
                                                        isPreviouslySelected
                                                            ? null
                                                            : () async {
                                                                setState(() {
                                                                  isLoadingAnswer =
                                                                      true;
                                                                  taskCubit
                                                                      .userPoints += (choice.trim() ==
                                                                          currentQuestion.correctAnswer
                                                                              .trim())
                                                                      ? widget
                                                                          .rewardPoints
                                                                      : -widget
                                                                          .deducePoints;
                                                                  taskCubit
                                                                      .pointsToShowQuestionExam += (choice.trim() ==
                                                                          currentQuestion.correctAnswer
                                                                              .trim())
                                                                      ? widget
                                                                          .rewardPoints
                                                                      : -widget
                                                                          .deducePoints;
                                                                });

                                                                taskCubit
                                                                    .previousAnswers
                                                                    .add({
                                                                  "id": currentQuestion
                                                                      .questionId,
                                                                  "questionId":
                                                                      currentQuestion
                                                                          .questionId,
                                                                  "answerContent":
                                                                      choice
                                                                          .trim(),
                                                                  "grade": (choice.trim() ==
                                                                          currentQuestion.correctAnswer
                                                                              .trim())
                                                                      ? widget
                                                                          .rewardPoints
                                                                      : -widget
                                                                          .deducePoints,
                                                                  "correct": choice
                                                                          .trim() ==
                                                                      currentQuestion
                                                                          .correctAnswer
                                                                          .trim(),
                                                                });

                                                                taskCubit
                                                                    .success();
                                                                await taskCubit.postUserExamAnswers(
                                                                    uid!,
                                                                    widget
                                                                        .taskId,
                                                                    currentQuestion
                                                                        .questionId,
                                                                    choice
                                                                        .trim(),
                                                                    choice.trim() ==
                                                                        currentQuestion
                                                                            .correctAnswer
                                                                            .trim(),
                                                                    (choice.trim() ==
                                                                            currentQuestion.correctAnswer
                                                                                .trim())
                                                                        ? widget
                                                                            .rewardPoints
                                                                        : widget
                                                                            .deducePoints,
                                                                    widget
                                                                        .challengeId);
                                                                setState(() {
                                                                  isLoadingAnswer =
                                                                      false;
                                                                });
                                                              },
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .only(bottom: 10),
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 16),
                                                      width: 200,
                                                      decoration:
                                                          BoxDecoration(
                                                        color:
                                                            backgroundColor,
                                                        border: Border.all(
                                                          color: borderColor,
                                                          width: 3,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          choice,
                                                          style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {



                                          taskCubit.moveToPastQuestion(
                                              context,
                                              taskCubit.userPoints,
                                              widget.taskId,
                                              widget.challengeId,
                                              widget.challengesName,
                                              widget.rewardPoints,
                                              widget.deducePoints,
                                              widget
                                                  .challengesRemainingTime,
                                              widget.subscriptionCostPoints,
                                              widget.status,
                                              widget.rankPoints,
                                              widget
                                                  .challengesNumberOfTasks,
                                              widget.numberOfQuestion,
                                              widget
                                                  .challengesNumberOfSubscriptions);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.mainColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.all(15),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Center(
                                              child: Text(
                                                S.of(context).back,
                                                style: const TextStyle(
                                                    color: AppColors
                                                        .whiteColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            // const Positioned(
                                            //   left: 0,
                                            //   child: Icon(
                                            //     Icons.arrow_back,
                                            //     color: Colors.white,
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.height *
                                            .01,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {

                                          if (taskCubit.currentQuestionIndex +1== (taskCubit.questions.length / 2).floor()||taskCubit.currentQuestionIndex +3== taskCubit.questions.length ) {
                                            final mainCubit = MainAppCubit.get(context);
                                            mainCubit.interstitialAd();
                                          }
                                          // Check if current question is answered
                                          bool isAnswered = taskCubit.previousAnswers.any((answer) =>
                                          answer["questionId"] == taskCubit.questions[taskCubit.currentQuestionIndex].questionId);

                                          if (!isAnswered) {
                                            // Show AwesomeDialog if not answered
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.warning,
                                              animType: AnimType.bottomSlide,
                                              title: S.of(context).warning,
                                              desc: S.of(context).pleaseAnswerTheQuestionFirst,
                                              btnCancelOnPress: () {},
                                              btnCancelText: S.of(context).okay,
                                            ).show();
                                            return;
                                          }
                                          taskCubit.moveToNextQuestion(
                                              context,
                                              taskCubit.userPoints,
                                              widget.taskId,
                                              widget.challengeId,
                                              widget.challengesName,
                                              widget.rewardPoints,
                                              widget.deducePoints,
                                              widget
                                                  .challengesRemainingTime,
                                              widget.subscriptionCostPoints,
                                              widget.status,
                                              widget.rankPoints,
                                              widget
                                                  .challengesNumberOfTasks,
                                              widget.numberOfQuestion,
                                              widget
                                                  .challengesNumberOfSubscriptions);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.mainColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.all(15),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Center(
                                              child: Text(
                                                S.of(context).continueExams,
                                                style: const TextStyle(
                                                    color: AppColors
                                                        .whiteColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            // const Positioned(
                                            //   right: 0,
                                            //   child: Icon(
                                            //     Icons.arrow_back,
                                            //     color: Colors.white,
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isBottomBannerLoaded && myBannerBottom != null)
                              Container(
                                height: 60,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: AdWidget(ad: myBannerBottom!),
                              ),
                          ],
                        );
                      },
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
