import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../shared/style/color.dart';

class ChallengeCard extends StatefulWidget {
  final String challengesName;
  final String challengeId;
  final double rewardPoints;
  final double deducePoints;
  final DateTime
      challengesRemainingTime; //   "endTime": "2025-01-28T13:39:50.526Z",
  final double subscriptionCostPoints;
  final String status;
  final List<double> rankPoints;
  final double challengesNumberOfTasks;
  final double challengesNumberOfSubscriptions;
  final double numberOfQuestion;
  final DateTime now;
  const ChallengeCard(
      {super.key,
      required this.challengesName,
      required this.challengeId,
      required this.rewardPoints,
      required this.deducePoints,
      required this.challengesRemainingTime,
      required this.subscriptionCostPoints,
      required this.status,
      required this.rankPoints,
      required this.challengesNumberOfTasks,
      required this.challengesNumberOfSubscriptions,
      required this.now,
      required this.numberOfQuestion});

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> {
  String formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return '${days.toString().padLeft(2, '0')} : '
        '${hours.toString().padLeft(2, '0')} : '
        '${minutes.toString().padLeft(2, '0')} : '
        '${seconds.toString().padLeft(2, '0')}';
  }

  late ValueNotifier<Duration> remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    remainingTime =
        ValueNotifier(widget.challengesRemainingTime.difference(widget.now));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value.inSeconds > 0) {
        remainingTime.value = remainingTime.value - const Duration(seconds: 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    remainingTime.dispose();
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
                '+ ${widget.rewardPoints.toInt()} ${S.of(context).points} | - ${widget.deducePoints.toInt()} ${S.of(context).points}',
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
              const SizedBox(
                width: 15,
              ),
              Flexible(
                child: ValueListenableBuilder<Duration>(
                  valueListenable: remainingTime,
                  builder: (context, time, child) {
                    return AutoSizeText(
                      formatDuration(time),
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
