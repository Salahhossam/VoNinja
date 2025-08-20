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
    await eventCubit.joinEvent(uid, e,);
    await initData();
  }

  Future<void> _claim(AppEvent e) async {
    try {
      String uid = await CashHelper.getData(key: 'uid');
      final eventCubit = EventCubit.get(context);
      await eventCubit.claimEventReward(uid: uid, event: e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reward claimed!')),
      );
      await initData();
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
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
                style: TextStyle(fontSize: 24, color: AppColors.lightColor),
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
                            final endAt =
                                e.type == EventType.welcome ? userEnd : e.endAt;
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

                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
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
                                            const SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/img/ninja_gif.gif'),
                                              height: 100,
                                              width: 100,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(e.title,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 6),
                                        Text(e.description),
                                        const SizedBox(height: 8),
                                        if (isUpcoming && startAt != null)
                                          Row(children: [
                                            const Icon(Icons.schedule,
                                                size: 16),
                                            const SizedBox(width: 6),
                                            Text(
                                                'Starts in ${_fmtRemain(startAt)}'),
                                          ])
                                        else if (active && endAt != null)
                                          Row(children: [
                                            const Icon(Icons.timer, size: 16),
                                            const SizedBox(width: 6),
                                            Text(
                                                'Ends in ${_fmtRemain(endAt)}'),
                                          ])
                                        else if (endAt != null)
                                          Row(children: [
                                            const Icon(Icons.timer_off,
                                                size: 16),
                                            const SizedBox(width: 6),
                                            Text(now.isBefore(endAt)
                                                ? 'Not active yet'
                                                : 'Ended'),
                                          ]),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            if (cta == 'Join')
                                              ElevatedButton(
                                                onPressed: active
                                                    ? () => _join(e)
                                                    : null,
                                                // نسمح بالـ Join قبل البداية
                                                child: const Text('Join'),
                                              ),
                                            if (cta == 'In progress')
                                              const OutlinedButton(
                                                onPressed: null,
                                                child: Text('In progress'),
                                              ),
                                            if (cta == 'Continue')
                                              ElevatedButton(
                                                onPressed: () {
                                                  // افتح صفحة الكويز مثلاً
                                                },
                                                child: const Text('Continue'),
                                              ),
                                            if (cta == 'Claim')
                                              ElevatedButton(
                                                onPressed: () => _claim(e),
                                                child: const Text('Claim'),
                                              ),
                                            if (cta == 'Completed')
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Text('✅ Reward claimed'),
                                              ),
                                          ],
                                        ),
                                        if (up != null &&
                                            (e.type == EventType.welcome ||
                                                e.type ==
                                                    EventType.targetPoints))
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: LinearProgressIndicator(
                                              value: _progressValue(e, up),
                                              minHeight: 8,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                )),
          );
        });
  }

  double _progressValue(AppEvent e, UserEventProgress up) {
    final accumulated = up.pointsAccumulated;
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
    return 0;
  }
}
