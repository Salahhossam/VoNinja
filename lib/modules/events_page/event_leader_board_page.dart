import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';
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
    return '${NumberFormat.decimalPattern().format(value)} EGP';
  }

  int _prizeForRank(int rank) {
    if (rank == 1) {
      return (widget.event.rules['firstPrize'] ?? 0) as int;
    }
    if (rank == 2) {
      return (widget.event.rules['secondPrize'] ?? 0) as int;
    }
    if (rank == 3) {
      return (widget.event.rules['thirdPrize'] ?? 0) as int;
    }
    if (rank >= 4 && rank <= 10) {
      return (widget.event.rules['fourthTenthPrize'] ?? 0) as int;
    }
    return 0;
  }

  Color _rankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFC107);
    if (rank == 2) return const Color(0xFF9EA7B3);
    if (rank == 3) return const Color(0xFFB87333);
    if (rank >= 4 && rank <= 10) return const Color(0xFF1F6FEB);
    return AppColors.mainColor;
  }

  Color _rankBgColor(int rank) {
    if (rank == 1) return const Color(0xFFFFF8E1);
    if (rank == 2) return const Color(0xFFF1F4F8);
    if (rank == 3) return const Color(0xFFFBE9E0);
    if (rank >= 4 && rank <= 10) return const Color(0xFFF4F8FF);
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

  Widget _buildMyStatsCard(EventCubit cubit) {
    if (cubit.myLeaderboardEntry == null) return const SizedBox.shrink();

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
                child: Text(
                  S.of(context).yourDashboard,
                  style: const TextStyle(
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
                  "${S.of(context).rank} #${cubit.myRank ?? '-'}",
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
          Text(
            S.of(context).yourScore,
            style: const TextStyle(
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
                label: S.of(context).correct,
                value: _formatNumber(myEntry.correctAnswers),
              ),
              const SizedBox(width: 10),
              _statChip(
                icon: Icons.quiz_outlined,
                label: S.of(context).answered,
                value: _formatNumber(myEntry.answerCount),
              ),
            ],
          )
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
          Text(
            S.of(context).top3Winners,
            style: const TextStyle(
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "${_formatNumber(item.score)} ${S.of(context).pts}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          S.of(context).you,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "${S.of(context).reward}: ${prize > 0 ? _formatMoney(prize) : '0 EGP'}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 13,
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
    final isTopTen = rank >= 4 && rank <= 10;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.secondColor.withOpacity(.10)
            : _rankBgColor(rank),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMe
              ? AppColors.secondColor
              : isTopTen
              ? _rankColor(rank).withOpacity(.35)
              : Colors.grey.withOpacity(.10),
          width: isMe ? 1.5 : (isTopTen ? 1.1 : 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: isTopTen
                ? _rankColor(rank).withOpacity(.06)
                : Colors.black.withOpacity(.03),
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
              color: isTopTen
                  ? _rankColor(rank).withOpacity(.10)
                  : Colors.grey.withOpacity(.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: isTopTen
                    ? _rankColor(rank).withOpacity(.35)
                    : Colors.transparent,
              ),
            ),
            child: Center(
              child: Text(
                "$rank",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isTopTen ? _rankColor(rank) : Colors.black87,
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
                          fontSize: 14,
                          color: isMe ? AppColors.mainColor : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "${_formatNumber(item.score)} ${S.of(context).pts}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                          color:
                          isTopTen ? _rankColor(rank) : AppColors.secondColor,
                        ),
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          S.of(context).you,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "${S.of(context).reward}: ${prize > 0 ? _formatMoney(prize) : '0 EGP'}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: prize > 0
                        ? (isTopTen ? _rankColor(rank) : Colors.black54)
                        : Colors.black45,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    Text(
                      "${S.of(context).answered}: ${_formatNumber(item.answerCount)}",
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "${S.of(context).correct}: ${_formatNumber(item.correctAnswers)}",
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.black54,
                      ),
                    ),
                  ],
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
    final rest = cubit.leaderboardTop100.length > 3
        ? cubit.leaderboardTop100.skip(3).toList()
        : <LeaderboardEntry>[];

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
            title: Text(
              S.of(context).dashboard,
              style: const TextStyle(
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
              Text(
                S.of(context).leaderboard,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(rest.length, (index) {
                final item = rest[index];
                final rank = index + 4;
                return _buildRankRow(item, rank);
              }),
            ],
          ),
        );
      },
    );
  }
}