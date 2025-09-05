import 'dart:async';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:loading_overlay/loading_overlay.dart';
import 'package:ntp/ntp.dart';


import 'package:vo_ninja/modules/events_page/events_page.dart';
import 'package:vo_ninja/modules/welcome_challenge_page/welcome_challenge_cubit/welcome_challenge_cubit.dart';
import 'package:vo_ninja/modules/welcome_challenge_page/welcome_challenge_cubit/welcome_challenge_state.dart';
import 'package:vo_ninja/shared/main_cubit/cubit.dart';
import '../../generated/l10n.dart';
import '../../shared/network/local/cash_helper.dart';
import '../../shared/style/color.dart';



// ignore: must_be_immutable
class WelcomeChallengePage extends StatefulWidget {


  const WelcomeChallengePage({
    super.key,

  });

  @override
  State<WelcomeChallengePage> createState() => _WelcomeChallengePageState();
}

class _WelcomeChallengePageState extends State<WelcomeChallengePage> {
  bool isLoading = false;
  bool isLoadingAnswer = false;
  String? uid;
  final Map<String, List<String>> shuffledChoicesMap = {};
  late ConfettiController _confettiController;

  Timer? _ticker;
  int remainingSeconds = 0;

  String _formatMMSS(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _startTicker() {
    final c = WelcomeChallengeCubit.get(context);
    if (c.deadline == null) return;

    _ticker?.cancel();
    void tick() {
      final now = DateTime.now();
      final diff = c.deadline!.difference(now);
      setState(() {
        remainingSeconds = diff.isNegative ? 0 : diff.inSeconds;
      });
      if (remainingSeconds <= 0) {
        _ticker?.cancel();
        // انتهى الوقت -> أنهِ التحدي
        c.onFinishChallenge(context);
      }
    }

    tick(); // أول مرة لحظيًا
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    initData();

  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }



  Future<void> initData() async {
    final welcomeChallengeCubit = WelcomeChallengeCubit.get(context);
    setState(() {
      isLoading = true;
    });
    welcomeChallengeCubit.currentQuestionIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
       // Wait until UID is retrieved
        uid = await CashHelper.getData(key: 'uid');
        await welcomeChallengeCubit.getWelcomeChallengeDetailsData(
          uid!,
        );
        await welcomeChallengeCubit.startChallengeUsingNtp();
        _startTicker();

        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final welcomeChallengeCubit = WelcomeChallengeCubit.get(context);
    return BlocConsumer<WelcomeChallengeCubit, WelcomeChallengeState>(
      listener: (BuildContext context, WelcomeChallengeState state) {},
      builder: (BuildContext context, WelcomeChallengeState state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.lightColor,
            body: LoadingOverlay(
              isLoading: isLoadingAnswer || welcomeChallengeCubit.isLoading3,
              progressIndicator: Image.asset(
                'assets/img/ninja_gif.gif',
                height: 100,
                width: 100,
              ),
              child: isLoading
                  ? const Center(
                child: Image(
                  image: AssetImage('assets/img/ninja_gif.gif'),
                  height: 100,
                  width: 100,
                ),
              )
                  : BlocBuilder<WelcomeChallengeCubit, WelcomeChallengeState>(
                builder: (context, state) {
                  var currentQuestion = welcomeChallengeCubit.questions[welcomeChallengeCubit.currentQuestionIndex];
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
                      (welcomeChallengeCubit.currentQuestionIndex + 1) / welcomeChallengeCubit.questions.length;
                  Map<String, dynamic>? selectedAnswer =
                  welcomeChallengeCubit.previousAnswers.firstWhere(
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
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${welcomeChallengeCubit.currentQuestionIndex + 1} / ${welcomeChallengeCubit.questions.length}",
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
                                        const Spacer(),
                                        // عداد الوقت
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(.15),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Colors.white, width: 1),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.timer, color: Colors.white, size: 18),
                                              const SizedBox(width: 6),
                                              Text(
                                                _formatMMSS(remainingSeconds),
                                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
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
                                            welcomeChallengeCubit.speak(
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

                                            welcomeChallengeCubit
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

                                            welcomeChallengeCubit
                                                .selectOption(index);

                                            setState(() {
                                              if (isCorrect) {
                                                _confettiController
                                                    .play();
                                              }
                                              isLoadingAnswer = false;
                                            });
                                            if (welcomeChallengeCubit.currentQuestionIndex == welcomeChallengeCubit.questions.length - 1) {
                                              welcomeChallengeCubit.onFinishChallenge(context);
                                            }
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
                                        welcomeChallengeCubit.moveToPastQuestion(context);
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

                                        // Check if current question is answered
                                        bool isAnswered = welcomeChallengeCubit
                                            .previousAnswers
                                            .any((answer) =>
                                        answer["questionId"] ==
                                            welcomeChallengeCubit
                                                .questions[welcomeChallengeCubit.currentQuestionIndex]
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
                                        welcomeChallengeCubit.moveToNextQuestion(context,);
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

                            const SizedBox(height: 60)
                        ],
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: ConfettiWidget(
                            confettiController: _confettiController,
                            blastDirection: pi / 2,
                            // ينزل لتحت
                            blastDirectionality:
                            BlastDirectionality.directional,
                            emissionFrequency: 0.05,
                            numberOfParticles: 20,
                            maxBlastForce: 12,
                            minBlastForce: 5,
                            gravity: 0.3,

                            colors: const [
                              Colors.green,
                              Colors.blue,
                              Colors.pink,
                              Colors.orange,
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
