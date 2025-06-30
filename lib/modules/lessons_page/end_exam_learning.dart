import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/modules/taps_page/taps_page.dart';
import 'package:vo_ninja/shared/style/color.dart';

import '../../generated/l10n.dart';
import '../../shared/main_cubit/cubit.dart';
import '../../shared/network/local/cash_helper.dart';
import 'learning_cubit/learning_cubit.dart';
import 'learning_cubit/learning_state.dart';
import 'lesson_learning.dart';
import 'lessons_cubit/lessons_cubit.dart';
import 'lessons_page.dart';

class EndExamLearning extends StatefulWidget {
  final String lessonId;
  final String levelId;
  final double page;
  final double size;
  final double order;
  final double userPoints;
  final String collectionName;
  final double rewardedPoints;
  final double deducedPoints;
  final int numberOfLessons;
  final bool isLastExam;
  const EndExamLearning(
      {super.key,
      required this.userPoints,
      required this.lessonId,
      required this.levelId,
      required this.page,
      required this.size,
      required this.order,
      required this.collectionName,
      required this.rewardedPoints,
      required this.deducedPoints,
        required this.numberOfLessons,
        required this.isLastExam
      });

  @override
  State<EndExamLearning> createState() => _EndExamLearningState();
}

class _EndExamLearningState extends State<EndExamLearning> {
  String? uid;

  @override
  void initState() {
    super.initState();
    _checkUnansweredQuestions();
    final mainCubit = MainAppCubit.get(context);
    mainCubit.rewardAds();
  }
  List<int> unansweredQuestions = [];

  Future<void> _checkUnansweredQuestions() async {
    final learningCubit = LearningCubit.get(context);

    // التأكد من وجود بيانات الأسئلة والإجابات
    if (learningCubit.lessonDetails?.questions != null) {

      List<String> answeredQuestionIds = learningCubit.previousAnswers
          .map((answer) => (answer["questionId"] ?? '').toString())
          .toList();

      // مسح القائمة السابقة إن وجدت
      unansweredQuestions.clear();
      int index=1;
      // التحقق من كل سؤال في الدرس
      for (var question in learningCubit.lessonDetails!.questions!) {
        try {

          String questionId = question.questionId ?? '' ;

          // إذا كان السؤال غير موجود في الإجابات
          if (!answeredQuestionIds.contains(questionId)) {
            unansweredQuestions.add(index);
          }
         index++;

        } catch (e) {
          print('Error parsing questionId: ${question.questionId}');
        }
      }



      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainCubit = MainAppCubit.get(context);
    final learningCubit = LearningCubit.get(context);
    uid = CashHelper.getData(key: 'uid');

    return BlocConsumer<LearningCubit, LearningState>(
      listener: (BuildContext context, LearningState state) {},
      builder: (BuildContext context, LearningState state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.lightColor,
            body: WillPopScope(
              onWillPop: () async {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const TapsPage(),
                  ),
                );
                return true;
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * .75,
                      decoration: const BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
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

                              Image.asset(
                                'assets/img/end_learning.png',
                                height: 100,
                                width: 100,
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * .05),
// Text
                              Text(
                                S.of(context).successfullyPoints,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * .05),
                              Text(
                                '${widget.userPoints}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                S.of(context).pts,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              unansweredQuestions.isEmpty
                                  ? _buildSuccessMessage()
                                  : _buildUnansweredQuestionsMessage(),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * .15),
                              if(learningCubit.lessonDetails!.canShowAd)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await learningCubit.rewardedInterstitialAdLessonExam(uid, widget.levelId, widget.collectionName, widget.lessonId);

                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondColor,
                                    padding: const EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
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
                                              fontWeight: FontWeight.bold),
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
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.all(16),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Get the lessons from LessonsCubit
                                    final lessonsCubit =
                                        LessonCubit.get(context);

                                    // Use a null-safe approach to find the next lesson
                                    final nextLesson = lessonsCubit
                                        .lessonsPage?.lessonsCard
                                        ?.where((lesson) =>
                                            lesson.order == (widget.order + 1))
                                        .firstOrNull;

                                    if (nextLesson != null) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => LessonLearning(
                                            lessonId: nextLesson.lessonId!,
                                            levelId: widget.levelId,
                                            page: widget.page,
                                            size: widget.size,
                                            order: nextLesson.order!,
                                            title: nextLesson.title!,
                                            userPoints: widget.userPoints,
                                            collectionName:
                                                widget.collectionName,
                                            rewardedPoints:
                                                widget.rewardedPoints,
                                            deducedPoints: widget.deducedPoints, numberOfLessons: widget.numberOfLessons, isLastExam: widget.isLastExam,
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Handle case when there's no next lesson (maybe show a dialog or return to lessons page)
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => LessonsPage(
                                            levelId: widget.levelId,
                                            page: widget.page,
                                            size: widget.size,
                                            collectionName:
                                                widget.collectionName,
                                            rewardedPoints:
                                                widget.rewardedPoints,
                                            deducedPoints: widget.deducedPoints, numberOfLessons: widget.numberOfLessons,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    S.of(context).nextLesson,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .08,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const TapsPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: Text(
                          S.of(context).backToHome,
                          style: const TextStyle(
                              color: AppColors.whiteColor, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _buildSuccessMessage() {
    return Column(
      children: [
        Text(
          S.of(context).successfullyCompleted,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          S.of(context).allQuestionsAnswered,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

// ويدجت لعرض الأسئلة غير المجابة
  Widget _buildUnansweredQuestionsMessage() {
    return Column(
      children: [
        Text(
          S.of(context).incompleteLesson,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          S.of(context).unansweredQuestionsTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),

        // عرض أرقام الأسئلة غير المجابة في شكل chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: unansweredQuestions.map((index) {
            return Chip(
              label: Text(
                '#$index',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.secondColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 12),
        Text(
          S.of(context).completeAllQuestions,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
