import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../models/event_model.dart';
import '../../shared/network/local/cash_helper.dart';
import '../../shared/style/color.dart';
import 'event_cubit/event_cubit.dart';
import 'event_cubit/event_state.dart';

class EventLeaderboardPage extends StatefulWidget {
  final AppEvent event;

  const EventLeaderboardPage({
    super.key,
    required this.event,
  });

  @override
  State<EventLeaderboardPage> createState() => _EventLeaderboardPageState();
}

class _EventLeaderboardPageState extends State<EventLeaderboardPage> {
  bool isLoading = true;
  String currentUid = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cubit = EventCubit.get(context);
    final uid = await CashHelper.getData(key: 'uid');

    currentUid = uid ?? '';

    await cubit.fetchEventLeaderboard(widget.event.id);
    await cubit.fetchMyLeaderboardEntry(widget.event.id, currentUid);
    await cubit.fetchMyRank(widget.event.id, currentUid);

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  String _formatNumber(num value) {
    return NumberFormat.decimalPattern().format(value);
  }

  String _formatMoney(num value) {
    return 'EGP ${NumberFormat.decimalPattern().format(value)}';
  }

  int _prizeForRank(int rank) {
    if (rank == 1) {
      return (widget.event.rules['firstPrize'] ?? 0) as int;
    }
    if (rank == 2 || rank == 3) {
      return (widget.event.rules['secondThirdPrize'] ?? 0) as int;
    }
    if (rank >= 4 && rank <= 10) {
      return (widget.event.rules['fourthTenthPrize'] ?? 0) as int;
    }
    return 0;
  }

  Color _rankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFC107); // Gold
    if (rank == 2) return const Color(0xFF9EA7B3); // Silver واضح
    if (rank == 3) return const Color(0xFFB87333); // Bronze
    return AppColors.mainColor;
  }

  Color _rankBgColor(int rank) {
    if (rank == 1) return const Color(0xFFFFF8E1);
    if (rank == 2) return const Color(0xFFF1F4F8);
    if (rank == 3) return const Color(0xFFFBE9E0);
    return Colors.white;
  }

  LinearGradient _rankGradient(int rank) {
    if (rank == 1) {
      return const LinearGradient(
        colors: [Color(0xFFFFE082), Color(0xFFFFC107)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (rank == 2) {
      return const LinearGradient(
        colors: [Color(0xFFECEFF3), Color(0xFFB0B8C1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (rank == 3) {
      return const LinearGradient(
        colors: [Color(0xFFD7A27B), Color(0xFFB87333)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return LinearGradient(
      colors: [AppColors.mainColor, AppColors.secondColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  LinearGradient _myCardGradient() {
    return LinearGradient(
      colors: [
        AppColors.mainColor,
        AppColors.mainColor.withOpacity(.92),
        AppColors.secondColor.withOpacity(.95),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  LinearGradient _topCardGradient(int rank) {
    if (rank == 1) {
      return const LinearGradient(
        colors: [Color(0xFFFFE082), Color(0xFFFFC107)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (rank == 2) {
      return const LinearGradient(
        colors: [Color(0xFFF4F7FA), Color(0xFFB7C1CB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return const LinearGradient(
      colors: [Color(0xFFD9A27C), Color(0xFFB87333)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  Widget _buildMyStatsCard(EventCubit cubit) {
    if (cubit.myLeaderboardEntry == null) return const SizedBox.shrink();

    final myPrize = _prizeForRank(cubit.myRank ?? 0);
    final myEntry = cubit.myLeaderboardEntry!;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: _myCardGradient(),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withOpacity(.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.14),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "Your Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.14),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Rank #${cubit.myRank ?? '-'}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            "Your Score",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _formatNumber(myEntry.score),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statChip(
                icon: Icons.check_circle_outline,
                label: "Correct",
                value: _formatNumber(myEntry.correctAnswers),
              ),
              const SizedBox(width: 10),
              _statChip(
                icon: Icons.quiz_outlined,
                label: "Answered",
                value: _formatNumber(myEntry.answerCount),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(.14)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white70, size: 18),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildPodium(List<LeaderboardEntry> top3) {
    if (top3.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Top 3 Winners",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.mainColor,
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(top3.length, (index) {
            final rank = index + 1;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTopWinnerCard(top3[index], rank),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopWinnerCard(LeaderboardEntry item, int rank) {
    final isMe = item.uid == currentUid;
    final prize = _prizeForRank(rank);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: _rankGradient(rank),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isMe ? AppColors.secondColor : _rankColor(rank),
          width: isMe ? 2.2 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: _rankColor(rank).withOpacity(.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.22),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "#$rank",
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name.isEmpty ? item.uid : item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (isMe)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "YOU",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${_formatNumber(item.score)} pts",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    prize > 0 ? _formatMoney(prize) : "-",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            Icons.workspace_premium_rounded,
            color: Colors.white.withOpacity(.95),
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildRankRow(LeaderboardEntry item, int rank) {
    final isMe = item.uid == currentUid;
    final prize = _prizeForRank(rank);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color:
        isMe ? AppColors.secondColor.withOpacity(.10) : _rankBgColor(rank),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMe
              ? AppColors.secondColor
              : (rank <= 3 ? _rankColor(rank) : Colors.transparent),
          width: isMe || rank <= 3 ? 1.4 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _rankColor(rank).withOpacity(.16),
              shape: BoxShape.circle,
              border: Border.all(
                color: rank <= 3 ? _rankColor(rank) : Colors.transparent,
              ),
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "$rank",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _rankColor(rank),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name.isEmpty ? item.uid : item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe ? AppColors.mainColor : Colors.black87,
                        ),
                      ),
                    ),
                    if (isMe)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "You",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "Answered: ${_formatNumber(item.answerCount)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Correct: ${_formatNumber(item.correctAnswers)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 105),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "${_formatNumber(item.score)} pts",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondColor,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    prize > 0 ? _formatMoney(prize) : "",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: prize > 0 ? _rankColor(rank) : Colors.black38,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = EventCubit.get(context);
    final top3 = cubit.leaderboardTop100.take(3).toList();

    return BlocBuilder<EventCubit, EventState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.lightColor,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: AppColors.mainColor,
            title: const Text(
              "Dashboard",
              style: TextStyle(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: isLoading
              ? const Center(
            child: Image(
              image: AssetImage('assets/img/ninja_gif.gif'),
              height: 100,
              width: 100,
            ),
          )
              : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildMyStatsCard(cubit),
              _buildPodium(top3),
              const Text(
                "Leaderboard",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(cubit.leaderboardTop100.length, (index) {
                final item = cubit.leaderboardTop100[index];
                final rank = index + 1;
                return _buildRankRow(item, rank);
              }),
            ],
          ),
        );
      },
    );
  }
}
