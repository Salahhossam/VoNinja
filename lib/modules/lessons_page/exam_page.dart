import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:vo_ninja/shared/main_cubit/cubit.dart';
import '../../generated/l10n.dart';
import '../../shared/network/local/cash_helper.dart';
import '../../shared/style/color.dart';
import 'learning_cubit/learning_cubit.dart';
import 'learning_cubit/learning_state.dart';
import 'lessons_page.dart';

// ignore: must_be_immutable
class ExamPage extends StatefulWidget {
  final String lessonId;
  final String levelId;
  final double page;
  final double size;
  final double order;
  final String title;
  double userPoints;
  final String collectionName;
  final double rewardedPoints;
 final bool isLastExam;
  final int numberOfLessons;
  ExamPage(
      {super.key,
      required this.levelId,
      required this.page,
      required this.size,
      required this.order,
      required this.title,
      required this.userPoints,
      required this.lessonId,
      required this.collectionName,
      required this.rewardedPoints,
       required this.isLastExam,
        required this.numberOfLessons
      });

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
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
      //adUnitId: 'ca-app-pub-3940256099942544/9214589741', // استبدل بمعرف وحدة الإعلان الخاصة بك
      adUnitId: 'ca-app-pub-7223929122163665/1831803488',
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
    final learningCubit = LearningCubit.get(context);
    setState(() {
      isLoading = true;
    });
    learningCubit.currentQuestionIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
// Wait until UID is retrieved
        uid = await CashHelper.getData(key: 'uid');
        await learningCubit.getUserPoints(uid!);
        await learningCubit.getLessonsDetailsData(
            uid!,
            widget.levelId,
            widget.collectionName,
            widget.lessonId,
            widget.title,
            widget.order.toInt(),
            question: true);
        if (learningCubit.lessonDetails != null) {
          await learningCubit.getUserPreviousAnswers(uid, widget.lessonId);
        }

        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final learningCubit = LearningCubit.get(context);
    return BlocConsumer<LearningCubit, LearningState>(
      listener: (BuildContext context, LearningState state) {},
      builder: (BuildContext context, LearningState state) {
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
                        builder: (context) => LessonsPage(
                              levelId: widget.levelId,
                              page: widget.page,
                              size: widget.size,
                              collectionName: widget.collectionName,
                              rewardedPoints: widget.rewardedPoints,
                               numberOfLessons: widget.numberOfLessons,
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
                    : BlocBuilder<LearningCubit, LearningState>(
                      builder: (context, state) {
                        var currentQuestion = learningCubit.lessonDetails!
                            .questions![learningCubit.currentQuestionIndex];
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

                        double progress =
                            (learningCubit.currentQuestionIndex + 1) /
                                learningCubit
                                    .lessonDetails!.questions!.length;
                        Map<String, dynamic>? selectedAnswer =
                            learningCubit.previousAnswers.firstWhere(
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
                                child: Center(
                                  child: ListView(
                                    padding: const EdgeInsets.all(16.0),
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
                                                        LessonsPage(
                                                          levelId: widget
                                                              .levelId,
                                                          page:
                                                              widget.page,
                                                          size:
                                                              widget.size,
                                                          collectionName:
                                                              widget
                                                                  .collectionName,
                                                          rewardedPoints:
                                                              widget
                                                                  .rewardedPoints,
                                                         numberOfLessons: widget.numberOfLessons,
                                                        )),
                                              );
                                              // showFinishLessonDialog(
                                              //   context,
                                              //   widget.order,
                                              //   widget.title,
                                              //   widget.userPoints,
                                              //   widget.levelId,
                                              //   widget.page,
                                              //   widget.size,
                                              //   widget.collectionName,
                                              //   widget.rewardedPoints,
                                              //   widget.deducedPoints,
                                              // );
                                            },
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "${learningCubit.currentQuestionIndex + 1} / ${learningCubit.lessonDetails!.questions!.length}",
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
                                                BlocBuilder<LearningCubit,
                                                    LearningState>(
                                                  builder:
                                                      (context, state) {
                                                    return Text(
                                                      "${learningCubit.pointsToShowQuestionExam.toInt()}",
                                                      style: const TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize: 16),
                                                    );
                                                  },
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
                                              style: const TextStyle(
                                                color:
                                                    AppColors.whiteColor,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.left,
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
                                        itemBuilder: (context, index) {
                                          final choice =
                                              shuffledChoices[index];

                                          Color borderColor =
                                              AppColors.lightColor;
                                          Color textColor =
                                              Colors.white;
                                          Color backgroundColor =
                                              Colors.transparent;

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
                                                backgroundColor = Colors
                                                    .green
                                                    .withOpacity(0.1);
                                              } else {
                                                borderColor =
                                                    Colors.red;
                                                textColor = Colors.red;
                                                backgroundColor = Colors
                                                    .red
                                                    .withOpacity(0.1);
                                              }
                                            } else if (choice.trim() ==
                                                currentQuestion
                                                    .correctAnswer
                                                    .trim()) {
                                              borderColor =
                                                  Colors.green;
                                              textColor = Colors.green;
                                              backgroundColor = Colors
                                                  .green
                                                  .withOpacity(0.1);
                                            }
                                          }

                                          return InkWell(
                                            onTap: isPreviouslySelected
                                                ? null
                                                : () async {
                                                    setState(() {
                                                      isLoadingAnswer =
                                                          true;
                                                      bool isCorrect = choice
                                                              .trim() ==
                                                          currentQuestion
                                                              .correctAnswer
                                                              .trim();
                                                      double
                                                          deltaPoints =
                                                          isCorrect
                                                              ? widget
                                                                  .rewardedPoints
                                                              : 0;

                                                      widget.userPoints +=
                                                          deltaPoints;
                                                      learningCubit
                                                              .pointsToShowQuestionExam +=
                                                          deltaPoints;
                                                    });

                                                    learningCubit
                                                        .previousAnswers
                                                        .add({
                                                      "id": currentQuestion
                                                          .questionId,
                                                      "questionId":
                                                          currentQuestion
                                                              .questionId,
                                                      "answerContent":
                                                          choice.trim(),
                                                      "grade": choice
                                                                  .trim() ==
                                                              currentQuestion
                                                                  .correctAnswer
                                                                  .trim()
                                                          ? widget
                                                              .rewardedPoints
                                                          : 0,
                                                      "correct": choice
                                                              .trim() ==
                                                          currentQuestion
                                                              .correctAnswer
                                                              .trim(),
                                                    });

                                                    learningCubit
                                                        .selectOption(
                                                            index);
                                                    await learningCubit
                                                        .postUserExamAnswers(
                                                      uid!,
                                                      widget.lessonId,
                                                      currentQuestion
                                                          .questionId,
                                                      choice.trim(),
                                                      choice.trim() ==
                                                          currentQuestion
                                                              .correctAnswer
                                                              .trim(),
                                                      choice.trim() ==
                                                              currentQuestion
                                                                  .correctAnswer
                                                                  .trim()
                                                          ? widget
                                                              .rewardedPoints
                                                          : 0,
                                                      widget.levelId,
                                                    );
                                                    if(widget.isLastExam&&learningCubit.previousAnswers.length==learningCubit.lessonDetails!.questions!.length){
                                                      await learningCubit.addUserToCompleteLesson(uid??'', widget.levelId);
                                                    }

                                                    setState(() {
                                                      isLoadingAnswer =
                                                          false;
                                                    });
                                                  },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.only(
                                                      bottom: 10),
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  vertical: 16),
                                              width: 200,
                                              decoration: BoxDecoration(
                                                color: backgroundColor,
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
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 8,right: 8,bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          learningCubit.moveToPastQuestion(
                                              context,
                                              widget.userPoints,
                                              widget.lessonId,
                                              widget.levelId,
                                              widget.page,
                                              widget.size,
                                              widget.order,
                                              widget.collectionName,
                                              widget.rewardedPoints,
                                              widget.numberOfLessons);
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

                                          if (learningCubit.currentQuestionIndex +1  == (learningCubit.lessonDetails!.questions!.length / 2).floor()||learningCubit.currentQuestionIndex +3  == learningCubit.lessonDetails!.questions!.length) {

                                            final mainCubit = MainAppCubit.get(context);
                                            mainCubit.interstitialAd();
                                          }
                                          // Check if current question is answered
                                          bool isAnswered = learningCubit.previousAnswers.any((answer) =>
                                          answer["questionId"] == learningCubit.lessonDetails!
                                              .questions![learningCubit.currentQuestionIndex].questionId);

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
                                          learningCubit.moveToNextQuestion(
                                              context,
                                              widget.userPoints,
                                              widget.lessonId,
                                              widget.levelId,
                                              widget.page,
                                              widget.size,
                                              widget.order,
                                              widget.collectionName,
                                              widget.rewardedPoints,
                                             widget.numberOfLessons,widget.isLastExam);
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
                              )
                            else
                              const SizedBox(height:60)
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
