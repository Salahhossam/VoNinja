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
  const LessonCard({
    super.key,
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
    required this.deducedPoints
  });

  @override
  Widget build(BuildContext context) {
    bool isCompleted = (userProgress == 1);
    return BlocConsumer<LearningCubit, LearningState>(
      listener: (BuildContext context, LearningState state) {},
      builder: (BuildContext context, LearningState state) {
        return InkWell(
          onTap: () {
            isCompleted?
            showFinishLessonDialog(context, order!, title!, userPoints!, levelId, page, size,collectionName,rewardedPoints,deducedPoints,lessonId!):
            showLessonDialog(context, lessonId!, order!, title!, points!,
                questionsCount!, levelId, page, size, userPoints!,collectionName,rewardedPoints,deducedPoints);

          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.mainColor, // Dark color for card background
              borderRadius: BorderRadius.circular(16),
              border: const Border(
                bottom: BorderSide(
                  color: AppColors.secondColor, // Secondary border color
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
                      style: const TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Image.asset(
                          'assets/img/fane.png', // Replace with your image path
                          width: 20,
                          height: 20,
                          color: AppColors.whiteColor, // Make the icon white
                        ),
                        Text(
                          ' ${points!.toInt()} ${S.of(context).points}',
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                isCompleted
                    ? const Icon(
                        Icons.check_circle,
                        color: AppColors.greenColor, // Green for completed
                        size: 40,
                      )
                    : const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.lightColor, // Light color for ongoing
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
