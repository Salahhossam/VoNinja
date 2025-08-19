import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../shared/style/color.dart';

class ChallengeCard extends StatefulWidget {
  final String challengesName;
  final String challengeId;
  final double rewardPoints;
  final double subscriptionCostPoints;
  final String status;
  final double challengesNumberOfTasks;
  final double challengesNumberOfSubscriptions;
  final double numberOfQuestion;
  const ChallengeCard(
      {super.key,
      required this.challengesName,
      required this.challengeId,
      required this.rewardPoints,
      required this.subscriptionCostPoints,
      required this.status,
      required this.challengesNumberOfTasks,
      required this.challengesNumberOfSubscriptions,
      required this.numberOfQuestion});

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Expanded(
                child: AutoSizeText(
                  widget.challengesName, // Corrected concatenation
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis, // Ensures it remains in one line
                ),
              ),
              Text(
                '+ ${widget.rewardPoints.toInt()} ${S.of(context).points} ${S.of(context).points}',
                style:
                    const TextStyle(color: AppColors.lightColor, fontSize: 12),
                textAlign: TextAlign.end,
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 2,
                      ),
                      Image.asset(
                        'assets/img/fane.png', // Replace with your image path
                        width: 15,
                        height: 15,
                        color: AppColors.whiteColor, // Make the icon white
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '  ${widget.challengesNumberOfTasks.toInt()} ${S.of(context).tasks}',
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.person,
                        color: AppColors.whiteColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.challengesNumberOfSubscriptions.toInt()}',
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }
}
