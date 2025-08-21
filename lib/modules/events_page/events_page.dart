import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';
import 'package:vo_ninja/modules/events_page/event_cubit/event_state.dart';

import '../../models/event_model.dart';
import '../../shared/network/local/cash_helper.dart';
import '../../shared/style/color.dart';
import '../taps_page/taps_page.dart';
import 'event_cubit/event_cubit.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool isLoading = true;
  DateTime now = DateTime.now();

  Future<void> initData() async {
    final eventCubit = EventCubit.get(context);
    setState(() {
      isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        String uid = '';

        // Wait until UID is retrieved
        uid = await CashHelper.getData(key: 'uid');
        now = await NTP.now();
        await eventCubit.fetchActiveAndUpcomingEvents(now);
        for (final e
            in eventCubit.events.where((x) => x.type == EventType.welcome)) {
          await eventCubit.ensureWelcomeForUser(
            uid: uid,
            welcomeTemplate: e,
            installAt: now,
          );
        }

        await eventCubit.fetchUserEventsProgress(uid);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  Timer? _tick;

  @override
  void initState() {
    super.initState();
    initData();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) async {
      final ntpNow = await NTP.now();
      if (!mounted) return;
      setState(() {
        now = ntpNow;
      });
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  Future<void> _join(AppEvent e) async {
    String uid = await CashHelper.getData(key: 'uid');
    final eventCubit = EventCubit.get(context);
    await eventCubit.joinEvent(
      uid,
      e,
    );
    await initData();
  }

  Future<void> _claim(AppEvent e) async {
    try {
      String uid = await CashHelper.getData(key: 'uid');
      final eventCubit = EventCubit.get(context);
      await eventCubit.claimEventReward(uid: uid, event: e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reward claimed!'),
          backgroundColor: AppColors.greenColor,
        ),
      );
      await initData();
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  String _fmtRemain(DateTime target) {
    final d = target.difference(now);
    if (d.isNegative) return '0s';
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return '${h}h ${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final eventCubit = EventCubit.get(context);
    return BlocConsumer<EventCubit, EventState>(
        listener: (BuildContext context, EventState state) {},
        builder: (BuildContext context, EventState state) {
          return Scaffold(
            backgroundColor: AppColors.lightColor,
            appBar: AppBar(
              backgroundColor: AppColors.mainColor,
              title: const Text(
                'Events',
                style: TextStyle(
                    fontSize: 24,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const TapsPage()),
                  );
                },
              ),
            ),
            body: RefreshIndicator(
              onRefresh: initData,
              backgroundColor: AppColors.mainColor,
              color: AppColors.whiteColor,
              child: WillPopScope(
                onWillPop: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const TapsPage()),
                  );
                  return true;
                },
                child: isLoading
                    ? const Center(
                        child: Image(
                        image: AssetImage('assets/img/ninja_gif.gif'),
                        height: 100,
                        width: 100,
                      ))
                    : eventCubit.events.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 64,
                                  color: AppColors.mainColor.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No events available',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.mainColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: eventCubit.events.length,
                            itemBuilder: (_, i) {
                              final e = eventCubit.events[i];
                              final up = eventCubit.userEventsProgress?[e.id];
                              final isUpcoming = e.type == EventType.welcome
                                  ? false
                                  : e.isUpcoming(now);

                              DateTime? userStart, userEnd;
                              if (e.type == EventType.welcome) {
                                userStart = up?.userStartAt;
                                userEnd = up?.userEndAt;
                              }

                              final active = e.isActiveNow(now,
                                  userStart: userStart, userEnd: userEnd);
                              final endAt = e.type == EventType.welcome
                                  ? userEnd
                                  : e.endAt;
                              final startAt = e.type == EventType.welcome
                                  ? userStart
                                  : e.startAt;

                              String cta;
                              final st = up?.status ?? 'not_joined';
                              if (st == 'reward_claimed') {
                                cta = 'Completed';
                              } else if (st == 'completed') {
                                cta = 'Claim';
                              } else if (st == 'in_progress') {
                                cta = e.type == EventType.quiz
                                    ? 'Continue'
                                    : 'In progress';
                              } else {
                                cta = 'Join';
                              }

                              // حساب التقدم
                              final progressValue = _progressValue(e, up);
                              var accumulated = up?.pointsAccumulated ?? 0;
                              int goal = 0;

                              if (e.type == EventType.welcome) {
                                goal = (e.rules['welcomeGoal'] ?? 1000) as int;
                              } else if (e.type == EventType.targetPoints) {
                                goal = (e.rules['targetGoal'] ?? 0) as int;
                              } else if (e.type == EventType.quiz) {
                                goal = (e.rules['questionsCount'] ?? 0) as int;
                                final correctAnswers = up?.correctAnswers ?? 0;
                                accumulated = correctAnswers;
                              }

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (e.imageUrl.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: e.imageUrl ?? 'http/',
                                          height: 160,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            height: 160,
                                            color: AppColors.lightColor,
                                            child: Center(
                                              child: Image.asset(
                                                'assets/img/ninja_gif.gif',
                                                height: 60,
                                                width: 60,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            height: 160,
                                            color: AppColors.lightColor,
                                            child: const Icon(
                                              Icons.error,
                                              color: AppColors.errorColor,
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.title,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.mainColor,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            e.description,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                              height: 1.4,
                                            ),
                                          ),
                                          const SizedBox(height: 12),

                                          // معلومات الوقت
                                          if (isUpcoming && startAt != null)
                                            _buildInfoRow(
                                                Icons.schedule,
                                                'Starts in ${_fmtRemain(startAt)}',
                                                AppColors.secondColor)
                                          else if (active && endAt != null)
                                            _buildInfoRow(
                                                Icons.timer,
                                                'Ends in ${_fmtRemain(endAt)}',
                                                AppColors.secondColor)
                                          else if (endAt != null)
                                            _buildInfoRow(
                                                Icons.timer_off,
                                                now.isBefore(endAt)
                                                    ? 'Not active yet'
                                                    : 'Ended',
                                                Colors.grey),

                                          const SizedBox(height: 12),

                                          // معلومات التقدم
                                          if (up != null && goal > 0)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (e.type == EventType.quiz)
                                                  Text(
                                                    'Correct answers: $accumulated/$goal',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.mainColor,
                                                    ),
                                                  )
                                                else
                                                  Text(
                                                    'Points: $accumulated/$goal',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.mainColor,
                                                    ),
                                                  ),
                                                const SizedBox(height: 6),
                                                LinearProgressIndicator(
                                                  value: progressValue,
                                                  minHeight: 8,
                                                  backgroundColor:
                                                      AppColors.lightColor,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    progressValue >= 1
                                                        ? AppColors.greenColor
                                                        : AppColors.secondColor,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  '${(progressValue * 100).toStringAsFixed(0)}% completed',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                              ],
                                            ),

                                          // زر الإجراء
                                          SizedBox(
                                            width: double.infinity,
                                            child: _buildActionButton(
                                                cta, e, active),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ),
          );
        });
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String cta, AppEvent e, bool active) {
    switch (cta) {
      case 'Join':
        return ElevatedButton(
          onPressed: active ? () => _join(e) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondColor,
            foregroundColor: AppColors.whiteColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Join',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );

      case 'In progress':
        return OutlinedButton(
          onPressed: null,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: const BorderSide(color: AppColors.secondColor),
          ),
          child: const Text(
            'In progress',
            style: TextStyle(
              color: AppColors.secondColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

      case 'Continue':
        return ElevatedButton(
          onPressed: () {
            // افتح صفحة الكويز
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greenColor,
            foregroundColor: AppColors.whiteColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Continue Quiz',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );

      case 'Claim':
        return ElevatedButton(
          onPressed: () => _claim(e),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greenColor,
            foregroundColor: AppColors.whiteColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Claim Reward',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );

      case 'Completed':
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.greenColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.greenColor),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: AppColors.greenColor, size: 20),
              SizedBox(width: 8),
              Text(
                'Reward Claimed',
                style: TextStyle(
                  color: AppColors.greenColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  double _progressValue(AppEvent e, UserEventProgress? up) {
    final accumulated = up?.pointsAccumulated ?? 0;
    if (e.type == EventType.welcome) {
      final goal = (e.rules['welcomeGoal'] ?? 1000) as int;
      if (goal <= 0) return 0;
      return (accumulated / goal).clamp(0.0, 1.0);
    }
    if (e.type == EventType.targetPoints) {
      final goal = (e.rules['targetGoal'] ?? 0) as int;
      if (goal <= 0) return 0;
      return (accumulated / goal).clamp(0.0, 1.0);
    }
    if (e.type == EventType.quiz) {
      final goal = (e.rules['questionsCount'] ?? 0) as int;
      final correctAnswers = up?.correctAnswers ?? 0;
      if (goal <= 0) return 0;
      return (correctAnswers / goal).clamp(0.0, 1.0);
    }
    return 0;
  }
}
