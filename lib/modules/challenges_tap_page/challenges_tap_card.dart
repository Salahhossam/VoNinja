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
  final bool? canTab;
  final String? previousTile;
  const ChallengesTapCard({
    super.key,
    required this.levelId,
    required this.levelDifficulty,
    required this.rewardedPoints,
    required this.deducedPoints,
    required this.numberOfLessons,
    required this.levelProgress,
    this.canTab,
    this.previousTile
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
        if(canTab==null||canTab!) {
          Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => LessonsPage(
                    levelId: levelId!,
                    page: page,
                    size: size,
                    collectionName: 'lessons',
                    rewardedPoints: rewardedPoints!,
                    deducedPoints: deducedPoints!,
                   numberOfLessons: numberOfLessons??0,
                  )),
        );
        }
        else{
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
                      // Warning Icon with Level Number
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
                          S.of(context).completePreviousLevel,
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Level Info Container
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Previous Level Title
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
                        S.of(context).mustCompleteLevel(previousTile??''),
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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Level Image مع إمكانية إضافة القفل فوقها
            Stack(
              children: [
                levelImage,
                if ((canTab!=null&&!canTab!)) // افترض أن لديك متغير isLocked يحدد إذا كان المستوى مقفولاً
                  Positioned.fill(
                    child: Container(
                      color: Colors.black54,
                      child: const Center(
                        child: Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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
                          '$numberOfLessons ${S.of(context).lessons}',
                          style: const TextStyle(
                              color: AppColors.lightColor, fontSize: 14),
                          maxLines: 1,
                        ),
                      ),
                      if ((canTab!=null&&!canTab!)) // إضافة أيقونة قفل صغيرة بجوار النقاط
                        const Icon(
                          Icons.lock,
                          color: AppColors.lightColor,
                          size: 16,
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
                          child: (canTab!=null&&!canTab!)
                              ? Container(
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          )
                              : LinearProgressIndicator(
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
                        (canTab!=null&&!canTab!) ? 'Locked' : '${(levelProgress! * 100).toInt()}%',
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
          ],
        ),
      ),
    );
  }
}
