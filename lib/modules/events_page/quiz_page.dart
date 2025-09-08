import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ntp/ntp.dart';
import 'package:vo_ninja/models/event_model.dart';
import 'package:vo_ninja/modules/events_page/event_cubit/event_state.dart';
import 'package:vo_ninja/modules/events_page/events_page.dart';
import 'package:vo_ninja/shared/main_cubit/cubit.dart';
import '../../generated/l10n.dart';
import '../../shared/network/local/cash_helper.dart';
import '../../shared/style/color.dart';
import '../events_page/event_cubit/event_cubit.dart';
import '../lessons_page/learning_cubit/learning_cubit.dart';

// ignore: must_be_immutable
class QuizPage extends StatefulWidget {
  final AppEvent event;

  const QuizPage({
    super.key,
    required this.event,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
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
      adUnitId: 'ca-app-pub-7223929122163665/1831803488',
      // استبدل بمعرف وحدة الإعلان الخاصة بك
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

  @override
  void dispose() {

    super.dispose();
  }

  DateTime now = DateTime.now();

  Future<void> initData() async {
    final eventCubit = EventCubit.get(context);
    setState(() {
      isLoading = true;
    });
    eventCubit.currentQuestionIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
// Wait until UID is retrieved
        uid = await CashHelper.getData(key: 'uid');
        await eventCubit.getQuizDetailsData(
          uid!,
          widget.event.id,
        );

        await eventCubit.getUserPreviousAnswers(uid, widget.event.id);
        DateTime now = await NTP.now();
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventCubit = EventCubit.get(context);
    return BlocConsumer<EventCubit, EventState>(
      listener: (BuildContext context, EventState state) {},
      builder: (BuildContext context, EventState state) {
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
                    MaterialPageRoute(builder: (context) => const EventsPage()),
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
                    : BlocBuilder<EventCubit, EventState>(
                        builder: (context, state) {
                          var currentQuestion = eventCubit.questions[eventCubit.currentQuestionIndex];
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
                              (eventCubit.currentQuestionIndex + 1) / eventCubit.questions.length;
                          Map<String, dynamic>? selectedAnswer =
                          eventCubit.previousAnswers.firstWhere(
                            (answer) =>
                                answer["questionId"] ==
                                currentQuestion.questionId,
                            orElse: () =>
                                {}, // Return an empty map instead of null
                          );
                          bool isPreviouslySelected = selectedAnswer.isNotEmpty;
                          return Stack(
                            children: [
                              Column(
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

                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.close,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const EventsPage()),
                                                    );

                                                  },
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${eventCubit.currentQuestionIndex + 1} / ${eventCubit.questions.length}",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .6,
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 8.0),
                                                        child:
                                                            LinearProgressIndicator(
                                                          value: progress,
                                                          backgroundColor:
                                                              const Color.fromRGBO(
                                                                  168, 168, 168, 1),
                                                          color:
                                                              AppColors.secondColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            if (currentQuestion.imageUrl != null &&
                                                currentQuestion.imageUrl != '')
                                              const SizedBox(height: 10)
                                            else
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .15,
                                              ),
                                            if (currentQuestion.imageUrl != null &&
                                                currentQuestion.imageUrl != '')
                                              Center(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      currentQuestion.imageUrl ??
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
                                                  errorWidget:
                                                      (context, url, error) =>
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
                                                      color: AppColors.whiteColor,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                    softWrap: true,
                                                    overflow: TextOverflow.visible,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    eventCubit.speak(
                                                        currentQuestion.content,
                                                        "en-US");
                                                  },
                                                  icon: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(50),
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
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: shuffledChoices.length,
                                              itemBuilder: (context, index) {
                                                final choice =
                                                    shuffledChoices[index];

                                                Color borderColor =
                                                    AppColors.lightColor;
                                                Color textColor = Colors.white;
                                                Color backgroundColor =
                                                    Colors.transparent;

                                                if (isPreviouslySelected) {
                                                  if (choice.trim() ==
                                                      selectedAnswer[
                                                              "answerContent"]
                                                          .trim()) {
                                                    if (selectedAnswer["correct"]) {
                                                      borderColor = Colors.green;
                                                      textColor = Colors.green;
                                                      backgroundColor = Colors.green
                                                          .withOpacity(0.1);
                                                    } else {
                                                      borderColor = Colors.red;
                                                      textColor = Colors.red;
                                                      backgroundColor = Colors.red
                                                          .withOpacity(0.1);
                                                    }
                                                  } else if (choice.trim() ==
                                                      currentQuestion.correctAnswer
                                                          .trim()) {
                                                    borderColor = Colors.green;
                                                    textColor = Colors.green;
                                                    backgroundColor = Colors.green
                                                        .withOpacity(0.1);
                                                  }
                                                }

                                                return InkWell(
                                                  onTap: isPreviouslySelected
                                                      ? null
                                                      : () async {
                                                          setState(() {
                                                            isLoadingAnswer = true;
                                                          });
                                                          bool isCorrect =
                                                              choice.trim() ==
                                                                  currentQuestion
                                                                      .correctAnswer
                                                                      .trim();

                                                          eventCubit
                                                              .previousAnswers
                                                              .add({
                                                            "id": currentQuestion
                                                                .questionId,
                                                            "questionId":
                                                                currentQuestion
                                                                    .questionId,
                                                            "answerContent":
                                                                choice.trim(),
                                                            "correct": choice
                                                                    .trim() ==
                                                                currentQuestion
                                                                    .correctAnswer
                                                                    .trim(),
                                                          });

                                                          eventCubit
                                                              .selectOption(index);
                                                          await eventCubit
                                                              .postUserExamAnswers(
                                                            uid!,
                                                            currentQuestion
                                                                .questionId,
                                                            choice.trim(),
                                                            choice.trim() ==
                                                                currentQuestion
                                                                    .correctAnswer
                                                                    .trim(),
                                                            widget.event,
                                                          );

                                                          setState(() {
                                                            if (isCorrect) {
                                                            }
                                                            isLoadingAnswer = false;
                                                          });
                                                        },
                                                  child: Container(
                                                    margin: const EdgeInsets.only(
                                                        bottom: 10),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            vertical: 16),
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                      color: backgroundColor,
                                                      border: Border.all(
                                                        color: borderColor,
                                                        width: 3,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(8),
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
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 8, right: 8, bottom: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                eventCubit.moveToPastQuestion(context);
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
                                                          color:
                                                              AppColors.whiteColor,
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
                                                if (eventCubit.currentQuestionIndex %10==0 || eventCubit.currentQuestionIndex + 3 == eventCubit.questions.length) {
                                                  final mainCubit =
                                                      MainAppCubit.get(context);
                                                  mainCubit.interstitialAd();
                                                }
                                                // Check if current question is answered
                                                bool isAnswered = eventCubit
                                                    .previousAnswers
                                                    .any((answer) =>
                                                        answer["questionId"] ==
                                                        eventCubit
                                                            .questions[eventCubit.currentQuestionIndex]
                                                            .questionId);

                                                if (!isAnswered) {
                                                  // Show AwesomeDialog if not answered
                                                  AwesomeDialog(
                                                    context: context,
                                                    dialogType: DialogType.warning,
                                                    animType: AnimType.bottomSlide,
                                                    title: S.of(context).warning,
                                                    desc: S
                                                        .of(context)
                                                        .pleaseAnswerTheQuestionFirst,
                                                    btnCancelOnPress: () {},
                                                    btnCancelText:
                                                        S.of(context).okay,
                                                  ).show();
                                                  return;
                                                }
                                                eventCubit.moveToNextQuestion(context,);
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
                                                          color:
                                                              AppColors.whiteColor,
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
                                  if (isBottomBannerLoaded &&
                                      myBannerBottom != null)
                                    Container(
                                      height: 60,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: AdWidget(ad: myBannerBottom!),
                                    )
                                  else
                                    const SizedBox(height: 60)
                                ],
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
