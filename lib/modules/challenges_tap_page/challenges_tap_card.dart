import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../shared/style/color.dart';
import '../lessons_page/lessons_cubit/lessons_cubit.dart';
import '../lessons_page/lessons_page.dart';

// Progress Card Widget with Image and Percentage without Overlap
class ChallengesTapCard extends StatelessWidget {
  final String? levelId;
  final String? levelDifficulty;
  final double? rewardedPoints;
  final double? deducedPoints;
  final int? numberOfLessons;
  final double? levelProgress;

  const ChallengesTapCard({
    super.key,
    required this.levelId,
    required this.levelDifficulty,
    required this.rewardedPoints,
    required this.deducedPoints,
    required this.numberOfLessons,
    required this.levelProgress,
  });

  @override
  Widget build(BuildContext context) {
    double? page = 0;
    double? size = 0;
    // Choose the image based on the levelDifficulty
    Widget levelImage;
    if (levelDifficulty == 'BASIC') {
      levelImage = Image.asset('assets/img/basic.png', height: 60, width: 60);
    } else if (levelDifficulty == 'INTERMEDIATE') {
      levelImage =
          Image.asset('assets/img/intermed.png', height: 60, width: 60);
    } else if (levelDifficulty == 'ADVANCED') {
      levelImage =
          Image.asset('assets/img/Advanced.png', height: 60, width: 60);
    } else {
      levelImage = const Icon(Icons.help, size: 60); // Default icon if no match
    }
    return InkWell(
      onTap: () {
        LessonCubit.get(context).lastDocument = null;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => LessonsPage(
                    levelId: levelId!,
                    page: page,
                    size: size,
                    collectionName: 'lessons',
                    rewardedPoints: rewardedPoints!,
                    deducedPoints: deducedPoints!,
                  )),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Level Image
            levelImage,
            const SizedBox(width: 16),
            // Progress Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          '$numberOfLessons ${S.of(context).lessons}', // Corrected concatenation
                          style: const TextStyle(
                              color: AppColors.lightColor, fontSize: 14),
                          maxLines: 1, // Ensures it remains in one line
                        ),
                      ),
                      Text(
                        '+ ${rewardedPoints!.toInt()} ${S.of(context).points} | - ${deducedPoints!.toInt()} ${S.of(context).points}',
                        style: const TextStyle(
                            color: AppColors.lightColor, fontSize: 12),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  Text(
                    levelDifficulty![0].toUpperCase() +
                        levelDifficulty!.substring(1).toLowerCase(),
                    style: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row with Progress Bar and Percentage
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: levelProgress,
                            backgroundColor: AppColors.lightColor,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.secondColor),
                            minHeight: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(levelProgress! * 100).toInt()}%',
                        style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Points Information
            const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}
