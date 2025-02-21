import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:vo_ninja/shared/style/color.dart';

class LeaderboardCard extends StatelessWidget {
  final String? id;
  final String? username;
  final String? userAvatar;
  final double? points;
  final double? rank;
  final String? currentUserId;

  const LeaderboardCard({
    super.key,
    required this.id,
    required this.rank,
    required this.username,
    required this.userAvatar,
    required this.points,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    bool isCurrentUserRank = id == currentUserId;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: isCurrentUserRank ? AppColors.lightColor : AppColors.secondColor,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white),
        boxShadow: isCurrentUserRank
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
            backgroundColor: _getRankColor(rank!),
            child: Center(
              // Ensures text is centered
              child: Text(
                '${rank?.toInt()}',
                style: TextStyle(
                  color: rank! <= 3 ? AppColors.mainColor : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Reduce font size for proper fit
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
              backgroundColor:  isCurrentUserRank
                            ? AppColors.mainColor
                            : AppColors.lightColor,
                  
                  backgroundImage: AssetImage(
                    userAvatar ??
                        'assets/img/ninja1.png',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  // Ensure text fits properly
                  child: AutoSizeText(
                    username!,
                    maxLines: 1, // Prevents multi-line overflow
                    overflow:
                        TextOverflow.ellipsis, // Adds "..." if text is too long
                    style: TextStyle(
                        color: isCurrentUserRank
                            ? Colors.black
                            : AppColors.whiteColor,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${points?.toInt()}',
            style: TextStyle(
                color: isCurrentUserRank ? Colors.black : AppColors.whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

// Helper function to determine the rank color based on the rank value
  Color _getRankColor(double rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey;
    if (rank == 3) return Colors.brown;
    return AppColors.mainColor;
  }
}
