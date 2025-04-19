import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:vo_ninja/generated/l10n.dart';
import 'package:vo_ninja/modules/challenges_page/task_cubit/task_cubit.dart';

import '../../shared/network/local/cash_helper.dart';
import '../../shared/style/color.dart';

class LeaderboardDialog extends StatefulWidget {
  final String challengeId;

  const LeaderboardDialog({super.key, required this.challengeId});

  @override
  State<LeaderboardDialog> createState() => _LeaderboardDialogState();
}

class _LeaderboardDialogState extends State<LeaderboardDialog> {
  bool isLoading = false;
  String? uid;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    final taskCubit = TaskCubit.get(context);
    setState(() {
      isLoading = true;
    });
    taskCubit.currentQuestionIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        // Wait until UID is retrieved
        uid = await CashHelper.getData(key: 'uid');
        await taskCubit.fetchLeaderboards(widget.challengeId);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskCubit = TaskCubit.get(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      insetPadding: const EdgeInsets.all(20), // Adjust inset padding as needed
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.mainColor, // Dark background
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondColor.withOpacity(1), // Shadow color
              spreadRadius: 3, // Spread of the shadow
              blurRadius: 2, // Blur effect
            ),
          ],
        ),
        child: isLoading
            ? const Center(
                child: Image(
                                                image: AssetImage(
                                                    'assets/img/ninja_gif.gif'),
                                                height: 100,
                                                width: 100,
                                              ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).topTen,
                    style: const TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .3,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0)
                          .copyWith(bottom: 80),
                      itemCount:taskCubit.leaderboards.length,
                      itemBuilder: (context, index) {
                        final leaderboardsTap = taskCubit.leaderboards[index];
                         bool isCurrentUserRank=leaderboardsTap.id==uid;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              color: !isCurrentUserRank
                                  ? AppColors.lightColor
                                  : AppColors.secondColor,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.white),
                              boxShadow: !isCurrentUserRank
                                  ? [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.9),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                )
                              ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: _getRankColor(leaderboardsTap.rank!.toInt()),
                                  child: Text(
                                   '${leaderboardsTap.rank?.toInt()}',
                                    style: const TextStyle(
                                      color:
                                      1 <= 3 ? AppColors.mainColor : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: AutoSizeText(
                                          '${leaderboardsTap.username}',
                                          maxLines: 1, // Prevents multi-line overflow
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: !isCurrentUserRank
                                                  ? Colors.black
                                                  : AppColors.whiteColor,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4,),
                                Text(
                                  '${leaderboardsTap.points?.toInt()}',
                                  style: TextStyle(
                                      color: !isCurrentUserRank
                                          ? Colors.black
                                          : AppColors.whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4,),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.lightColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    AssetImage('assets/img/ninja1.png'),
                                backgroundColor: AppColors.lightColor,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                S.of(context).you,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          _buildStatContainer(S.of(context).rank, '${taskCubit.rank}'),
                          _buildStatContainer(S.of(context).points, '${taskCubit.userPoints}'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      }, // Close dialog on press
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: const Text(
                        'Back',
                        style:
                            TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey;
    if (rank == 3) return Colors.brown;
    return AppColors.mainColor;
  }

  Widget _buildStatContainer(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1D3240),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
