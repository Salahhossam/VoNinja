import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ntp/ntp.dart';
import 'package:vo_ninja/modules/events_page/event_cubit/event_state.dart';
import 'package:vo_ninja/modules/events_page/quiz_page.dart';

import '../../generated/l10n.dart';
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
  bool isLoading2 = false;
  DateTime now = DateTime.now();

  Future<void> initData() async {
    final eventCubit = EventCubit.get(context);
    setState(() {
      isLoading = true;
      isLoading2 = false;
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
    final eventCubit = EventCubit.get(context);
    setState(() {
      isLoading2 = true;
    });
    String uid = await CashHelper.getData(key: 'uid');

    await eventCubit.joinEvent(
      uid,
      e,
    );
    await initData();
  }

  Future<void> _claim(AppEvent e) async {
    try {
      final eventCubit = EventCubit.get(context);
      setState(() {
        isLoading2 = true;
      });
      String uid = await CashHelper.getData(key: 'uid');
      await eventCubit.claimEventReward(uid: uid, event: e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).rewardClaimedMessage),
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
            title: Text(
              S.of(context).events,
              style: const TextStyle(
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
          body: LoadingOverlay(
            isLoading: isLoading2,
            progressIndicator: Image.asset(
              'assets/img/ninja_gif.gif',
              height: 100,
              width: 100,
            ),
            child: RefreshIndicator(
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
                      Text(
                        S.of(context).noEventsAvailable,
                        style: const TextStyle(
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
                      final active = e.isActiveNow(now,
                          userStart: userStart, userEnd: userEnd);
                      if (!active) {
                        return Container();
                      }
                    }

                    final active = e.isActiveNow(now,
                        userStart: userStart, userEnd: userEnd);
                    final endAt = e.type == EventType.welcome
                        ? userEnd
                        : e.endAt;
                    final startAt = e.type == EventType.welcome
                        ? userStart
                        : e.startAt;

                    // حساب التقدم
                    final progressValue = _progressValue(e, up);
                    var accumulated = up?.pointsAccumulated ?? 0;
                    int goal = 0;
                    int goal2 = 0;
                    int answerCount = 0;

                    // متغيرات حالة الكويز لاستخدامها في الـ CTA ورسالة Good luck
                    bool allQuestionsAnswered = false;
                    bool correctAnswersMet = false;

                    if (e.type == EventType.welcome) {
                      goal = (e.rules['welcomeGoal'] ?? 1000) as int;
                    } else if (e.type == EventType.targetPoints) {
                      goal = (e.rules['targetGoal'] ?? 0) as int;
                    } else if (e.type == EventType.quiz) {
                      goal = (e.rules['quizMinCorrect'] ?? 0) as int; // requiredCorrect
                      goal2 = (e.rules['quizTotal'] ?? 0) as int;     // totalQuestions
                      answerCount = up?.answerCount ?? 0;
                      final correctAnswers = up?.correctAnswers ?? 0;
                      accumulated = correctAnswers;

                      allQuestionsAnswered =
                          (goal2 > 0) && (answerCount == goal2);
                      correctAnswersMet = correctAnswers >= goal;
                    }

                    // تحديد الـ CTA
                    String cta;
                    final st = up?.status ?? 'not_joined';
                    if (st == 'reward_claimed') {
                      cta = 'Completed';
                    } else if (st == 'completed') {
                      cta = 'Claim';
                    } else if (st == 'in_progress') {
                      if (e.type == EventType.quiz) {
                        // لو جاوب كل الأسئلة ولم يحقق الحد الأدنى ⇒ ShowAnswers
                        if (allQuestionsAnswered &&
                            !correctAnswersMet) {
                          cta = 'ShowAnswers';
                        } else {
                          cta = 'Continue';
                        }
                      } else {
                        cta = 'In progress';
                      }
                    } else {
                      cta = 'Join';
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
                                errorWidget:
                                    (context, url, error) =>
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
                                      S
                                          .of(context)
                                          .startsIn(
                                          _fmtRemain(startAt)),
                                      AppColors.secondColor)
                                else if (active && endAt != null)
                                  _buildInfoRow(
                                      Icons.timer,
                                      S
                                          .of(context)
                                          .endsIn(_fmtRemain(endAt)),
                                      AppColors.secondColor)
                                else if (endAt != null)
                                    _buildInfoRow(
                                        Icons.timer_off,
                                        now.isBefore(endAt)
                                            ? S
                                            .of(context)
                                            .notActiveYet
                                            : S.of(context).ended,
                                        Colors.grey),

                                const SizedBox(height: 12),

                                // معلومات التقدم
                                if (up != null && goal > 0)
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      if (e.type == EventType.quiz)
                                        Column(
                                          children: [
                                            Text(
                                              S
                                                  .of(context)
                                                  .correctAnswers(
                                                  accumulated,
                                                  goal),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w500,
                                                color: AppColors
                                                    .mainColor,
                                              ),
                                            ),
                                            Text(
                                              S
                                                  .of(context)
                                                  .totalAnswers(
                                                  answerCount,
                                                  goal2),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w500,
                                                color: AppColors
                                                    .mainColor,
                                              ),
                                            ),
                                          ],
                                        )
                                      else
                                        Text(
                                          S
                                              .of(context)
                                              .points2(
                                              accumulated, goal),
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
                                        S
                                            .of(context)
                                            .completedPercentage(
                                            (progressValue * 100)
                                                .toStringAsFixed(
                                                0)),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),

                                      // رسالة Good luck عند إنهاء كل الأسئلة بدون تحقيق الحد الأدنى
                                      if (e.type ==
                                          EventType.quiz &&
                                          allQuestionsAnswered &&
                                          !correctAnswersMet) ...[
                                        const SizedBox(height: 8),
                                        Container(
                                          width: double.infinity,
                                          padding:
                                          const EdgeInsets.all(
                                              12),
                                          decoration: BoxDecoration(
                                            color: AppColors
                                                .secondColor
                                                .withOpacity(0.08),
                                            borderRadius:
                                            BorderRadius.circular(
                                                8),
                                            border: Border.all(
                                              color: AppColors
                                                  .secondColor
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          child: Text(
                                            // مفاتيح الترجمة:
                                            // goodLuck: "Good luck! Review your answers and try again."
                                            S.of(context).goodLuck,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.w600,
                                              color: AppColors
                                                  .secondColor,
                                            ),
                                          ),
                                        ),
                                      ],

                                      const SizedBox(height: 12),
                                    ],
                                  ),

                                // زر الإجراء
                                SizedBox(
                                  width: double.infinity,
                                  child:
                                  _buildActionButton(cta, e, active),
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
          ),
        );
      },
    );
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
          onPressed: active ? () async => await _join(e) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondColor,
            foregroundColor: AppColors.whiteColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            S.of(context).join,
            style: const TextStyle(fontWeight: FontWeight.bold),
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
          child: Text(
            S.of(context).inProgress,
            style: const TextStyle(
              color: AppColors.secondColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

      case 'Continue':
        return ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => QuizPage(event: e)),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greenColor,
            foregroundColor: AppColors.whiteColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            S.of(context).continueQuiz,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );

      case 'ShowAnswers':
        return ElevatedButton(
          onPressed: () {
            // إذا لديك وضع مراجعة، مرر review: true
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => QuizPage(
                  event: e,
                  // review: true,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondColor,
            foregroundColor: AppColors.whiteColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            // مفاتيح الترجمة: showMyAnswers: "Show my answers"
            S.of(context).showMyAnswers,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );

      case 'Claim':
        return ElevatedButton(
          onPressed: () async => await _claim(e),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greenColor,
            foregroundColor: AppColors.whiteColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            S.of(context).claimReward,
            style: const TextStyle(fontWeight: FontWeight.bold),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle,
                  color: AppColors.greenColor, size: 20),
              const SizedBox(width: 8),
              Text(
                S.of(context).rewardClaimed,
                style: const TextStyle(
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
      final totalQuestions = (e.rules['quizTotal'] ?? 0) as int;
      final requiredCorrect =
      (e.rules['quizMinCorrect'] ?? totalQuestions) as int;
      final correctAnswers = up?.correctAnswers ?? 0;
      final answeredQuestions = up?.answerCount ?? 0;

      if (totalQuestions <= 0) return 0;

      final allQuestionsAnswered = answeredQuestions == totalQuestions;
      final correctAnswersMet = correctAnswers >= requiredCorrect;

      if (!allQuestionsAnswered) {
        // حساب التقدم من عدد الأسئلة المجابة + التقدم في الإجابات الصحيحة
        final progressFromAnswered =
            answeredQuestions / totalQuestions * 0.5;
        final progressFromCorrect =
        (correctAnswers / requiredCorrect * 0.5);

        return (progressFromAnswered + progressFromCorrect)
            .clamp(0.0, 1.0);
      }

      if (allQuestionsAnswered && !correctAnswersMet) {
        return 0.5 +
            (correctAnswers / requiredCorrect * 0.5).clamp(0.0, 0.5);
      }

      if (allQuestionsAnswered && correctAnswersMet) {
        return 1.0;
      }

      return 0;
    }
    return 0;
  }
}

