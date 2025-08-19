import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../generated/l10n.dart';
import '../../shared/style/color.dart';
import 'challenges_cubit/challenges_cubit.dart';
import 'challenges_cubit/challenges_state.dart';
import 'challenges_exam_page.dart';

class TaskCard extends StatelessWidget {
  final String challengesName;
  final String taskName;
  final String challengeId;
  final String taskId;
  final double rewardPoints;
  final DateTime
      challengesRemainingTime; //   "endTime": "2025-01-28T13:39:50.526Z",
  final double subscriptionCostPoints;
  final String status;
  final List<double> rankPoints;
  final double challengesNumberOfTasks;
  final double numberOfQuestion;
  final double challengesNumberOfSubscriptions;
  final bool available;
  final bool isCompleted;
  const TaskCard(
      {super.key,
      required this.challengesName,
      required this.challengeId,
      required this.rewardPoints,

      required this.challengesRemainingTime,
      required this.subscriptionCostPoints,
      required this.status,
      required this.rankPoints,
      required this.challengesNumberOfTasks,
      required this.challengesNumberOfSubscriptions,
        required this.available,
        required this.isCompleted,
        required this.taskId,
        required this.taskName,
        required this.numberOfQuestion
      });

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ChallengeCubit, ChallengeState>(
      listener: (BuildContext context, ChallengeState state) {},
      builder: (BuildContext context, ChallengeState state) {
        return InkWell(
            onTap: () {
              if (!available) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Time Ended',
                  desc: 'The challenge time has ended!',
                  btnOkOnPress: () {},
                ).show();
              }
              else{
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>  ChallengesExamPage(taskId: taskId, title:taskName , challengeId: challengeId, challengesName: challengesName, rewardPoints: rewardPoints,challengesRemainingTime: challengesRemainingTime, subscriptionCostPoints: subscriptionCostPoints, status: status, rankPoints: rankPoints, challengesNumberOfTasks: challengesNumberOfTasks, numberOfQuestion: numberOfQuestion, challengesNumberOfSubscriptions: challengesNumberOfSubscriptions),
                  ),
                );
              }
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
                        taskName,
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
                            ' ${(numberOfQuestion * rewardPoints).toInt()} ${S.of(context).points}',
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
                          color: AppColors.greenColor,
                          size: 40,
                        )
                      : const Icon(
                          Icons.circle_outlined,
                          color: AppColors.lightColor,
                          size: 30,
                        ),
                ],
              ),
            ));
      },
    );
  }
}
