import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../generated/l10n.dart';
import '../../shared/style/color.dart';
import 'learning_cubit/learning_cubit.dart';
import 'learning_cubit/learning_state.dart';
import 'lessons_cubit/lessons_cubit.dart';

class LessonCard extends StatelessWidget {
  final String? lessonId;
  final String? title;
  final double? order;
  final double? questionsCount;
  final double? points;
  final double? userProgress;
  final double? userPoints;
  final String levelId;
  final double page;
  final double size;
  final String collectionName;
  final double rewardedPoints;
  final double deducedPoints;
  final bool? canTab;
  final String? previousTile;
  final bool isLastExam;
  final int  numberOfLessons;
  const LessonCard(
      {super.key,
      required this.lessonId,
      required this.title,
      required this.order,
      required this.questionsCount,
      required this.points,
      required this.userProgress,
      required this.userPoints,
      required this.levelId,
      required this.page,
      required this.size,
      required this.collectionName,
      required this.rewardedPoints,
      required this.deducedPoints,
      this.canTab,
      this.previousTile,
        required this.isLastExam,
        required this.numberOfLessons,
      });

  @override
  Widget build(BuildContext context) {
    bool isCompleted = (userProgress == 1);
    return BlocConsumer<LearningCubit, LearningState>(
      listener: (BuildContext context, LearningState state) {},
      builder: (BuildContext context, LearningState state) {
        return InkWell(
          onTap: () {
            if (canTab == null || canTab!) {
              isCompleted
                  ? showFinishLessonDialog(
                      context,
                      order!,
                      title!,
                      userPoints!,
                      levelId,
                      page,
                      size,
                      collectionName,
                      rewardedPoints,
                      deducedPoints,
                      lessonId!,
                     numberOfLessons,
                   isLastExam
              )
                  : showLessonDialog(
                      context,
                      lessonId!,
                      order!,
                      title!,
                      points!,
                      questionsCount!,
                      levelId,
                      page,
                      size,
                      userPoints!,
                      collectionName,
                      rewardedPoints,
                      deducedPoints,
                numberOfLessons,
                isLastExam
              );
            } else {
              showDialog(
                context: context,
                builder: (context) {
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
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondColor.withOpacity(1),
                            spreadRadius: 3,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Warning Icon with Lesson Number
                          const Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.secondColor,
                                radius: 30,
                              ),
                              Icon(
                                Icons.warning_rounded,
                                color: AppColors.whiteColor,
                                size: 40,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // Title
                          Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              S.of(context).completePreviousLesson,
                              style: const TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Lesson Info Container
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.mainColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                // Previous Lesson Title
                                Text(
                                  previousTile ?? '',
                                  style: const TextStyle(
                                    color: AppColors.secondColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),

                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Message
                          Text(
                            S.of(context).mustCompleteLesson(previousTile??''),
                            style: const TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 25),

                          // Buttons
                          Column(
                            children: [
                              // Okay Button
                              buildActionButton(
                                context,
                                S.of(context).okay,
                                AppColors.lightColor,
                                    () => Navigator.pop(context),
                                Colors.black,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
          child:Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(16),
              border: const Border(
                bottom: BorderSide(
                  color: AppColors.secondColor,
                  width: 4,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${S.of(context).lessonNumber} ${order!.toInt()}',
                      style: const TextStyle(
                        color: AppColors.lightColor,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title!,
                      style: TextStyle(
                        color:  (canTab!=null&&!canTab!) ? Colors.grey[400] : AppColors.whiteColor, // تغيير لون النص إذا كان مقفولاً
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Image.asset(
                          'assets/img/fane.png',
                          width: 20,
                          height: 20,
                          color:  (canTab!=null&&!canTab!) ? Colors.grey[400] : AppColors.whiteColor, // تغيير لون الأيقونة إذا كان مقفولاً
                        ),
                        Text(
                          ' ${points!.toInt()} ${S.of(context).points}',
                          style: TextStyle(
                            color:  (canTab!=null&&!canTab!) ? Colors.grey[400] : AppColors.whiteColor, // تغيير لون النص إذا كان مقفولاً
                            fontSize: 16,
                          ),
                        ),
                        if ( (canTab!=null&&!canTab!)) // إضافة أيقونة القفل بجانب النقاط إذا كان الدرس مقفولاً
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.lock,
                              color: Colors.grey,
                              size: 16,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                // الجزء الأيمن (الأيقونة)
                if (isCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.greenColor,
                    size: 40,
                  )
                else if ( (canTab!=null&&!canTab!)) // حالة القفل
                  const Icon(
                    Icons.lock,
                    color: Colors.grey,
                    size: 30,
                  )
                else
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.lightColor,
                    size: 30,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
