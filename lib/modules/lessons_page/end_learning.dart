import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/shared/main_cubit/cubit.dart';
import 'package:vo_ninja/shared/style/color.dart';
import '../../generated/l10n.dart';
import 'exam_page.dart';
import 'learning_cubit/learning_cubit.dart';
import 'learning_cubit/learning_state.dart';
import 'package:vo_ninja/modules/lessons_page/lessons_page.dart';

class EndLearning extends StatefulWidget {
  final String lessonId;
  final String levelId;
  final double page;
  final double size;
  final double order;
  final String title;
  final double userPoints;
  final String collectionName;
  final double rewardedPoints;
  final int numberOfLessons;
  final bool isLastExam;
  const EndLearning(
      {super.key,
      required this.lessonId,
      required this.levelId,
      required this.page,
      required this.size,
      required this.order,
      required this.title,
      required this.userPoints,
      required this.collectionName,
      required this.rewardedPoints,
        required this.numberOfLessons,
        required this.isLastExam
      });

  @override
  State<EndLearning> createState() => _EndLearningState();
}

class _EndLearningState extends State<EndLearning> {
  @override
  void initState() {
    super.initState();
    final mainCubit = MainAppCubit.get(context);
    mainCubit.rewardAds();
  }

  @override
  Widget build(BuildContext context) {
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
                      builder: (context) => LessonsPage(
                            levelId: widget.levelId,
                            page: widget.page,
                            size: widget.size,
                            collectionName: widget.collectionName,
                            rewardedPoints: widget.rewardedPoints,
                            numberOfLessons: widget.numberOfLessons,
                          )),
                );
                // showFinishLessonDialog(context, order, title, userPoints,
                //     levelId, page, size, collectionName);
                return true;
              },
              child: Column(
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
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (context) => LessonsPage(
                                                  levelId: widget.levelId,
                                                  page: widget.page,
                                                  size: widget.size,
                                                  collectionName:
                                                      widget.collectionName,
                                                  rewardedPoints:
                                                      widget.rewardedPoints,
                                                  numberOfLessons: widget.numberOfLessons,
                                                )));
                                    // showFinishLessonDialog(
                                    //     context,
                                    //     order,
                                    //     title,
                                    //     userPoints,
                                    //     levelId,
                                    //     page,
                                    //     size,
                                    //     collectionName);
                                  },
                                ),
                                Expanded(
                                  child: Container(
                                    height: 4,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/img/end_learning.png',
                                    width: 100,
                                    height: 100,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    S.of(context).youAreAllSet,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    S.of(context).youLearned30NewwordsToday,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
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
                            builder: (context) => ExamPage(
                              lessonId: widget.lessonId,
                              levelId: widget.levelId,
                              page: widget.page,
                              size: widget.size,
                              order: widget.order,
                              title: widget.title,
                              userPoints: widget.userPoints,
                              collectionName: widget.collectionName,
                              rewardedPoints: widget.rewardedPoints,
                              isLastExam: widget.isLastExam, numberOfLessons: widget.numberOfLessons,
                            ),
                          ),
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
                        S.of(context).startExam,
                        style: const TextStyle(
                            color: AppColors.whiteColor, fontSize: 16),
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
