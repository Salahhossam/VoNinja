import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../models/event_model.dart';
import '../../shared/main_cubit/cubit.dart';
import '../../shared/network/local/cash_helper.dart';
import '../../shared/style/color.dart';
import 'event_cubit/event_cubit.dart';
import 'event_leader_board_page.dart';

import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../generated/l10n.dart';

import 'event_cubit/event_state.dart';
import 'events_page.dart';

class LeaderboardQuizPage extends StatefulWidget {
  final AppEvent event;

  const LeaderboardQuizPage({
    super.key,
    required this.event,
  });

  @override
  State<LeaderboardQuizPage> createState() => _LeaderboardQuizPageState();
}

class _LeaderboardQuizPageState extends State<LeaderboardQuizPage> {
  bool isLoading = false;
  bool isLoadingAnswer = false;
  String? uid;
  String userName = 'User';

  final Map<String, List<String>> shuffledChoicesMap = {};

  BannerAd? myBannerTop;
  BannerAd? myBannerBottom;
  bool isTopBannerLoaded = false;
  bool isBottomBannerLoaded = false;

  RewardedAd? rewardedAd;
  bool rewardedReady = false;
  bool watchedRewardedAdForCurrentQuestion = false;

  void _initBannerAds() {
    myBannerTop = BannerAd(
      adUnitId: 'ca-app-pub-7223929122163665/1831803488',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() => isTopBannerLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();

    // myBannerBottom = BannerAd(
    //   adUnitId: 'ca-app-pub-7223929122163665/1831803488',
    //   size: AdSize.banner,
    //   request: const AdRequest(),
    //   listener: BannerAdListener(
    //     onAdLoaded: (_) {
    //       setState(() => isBottomBannerLoaded = true);
    //     },
    //     onAdFailedToLoad: (ad, error) {
    //       ad.dispose();
    //     },
    //   ),
    // )..load();
  }


  bool isRewardedLoading = false;


  void _loadRewardedAd() {
    if (isRewardedLoading) return;

    isRewardedLoading = true;
    rewardedReady = false;

    RewardedAd.load(
      adUnitId: 'ca-app-pub-7223929122163665/9327150128',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('Rewarded ad loaded');
          rewardedAd = ad;
          rewardedReady = true;
          isRewardedLoading = false;

          if (mounted) {
            setState(() {});
          }
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded ad failed to load: $error');
          rewardedAd = null;
          rewardedReady = false;
          isRewardedLoading = false;

          if (mounted) {
            setState(() {});
          }

          Future.delayed(const Duration(seconds: 2), () {
            if (mounted && rewardedAd == null && !isRewardedLoading) {
              _loadRewardedAd();
            }
          });
        },
      ),
    );
  }

  Future<void> _watchRewardedAd() async {
    if (rewardedAd == null) {
      debugPrint('Rewarded ad is null');
      _loadRewardedAd();
      return;
    }

    bool rewardEarned = false;

    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('Rewarded ad showed');
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('Rewarded ad dismissed');
        ad.dispose();
        rewardedAd = null;
        rewardedReady = false;

        if (mounted) {
          setState(() {});
        }

        _loadRewardedAd(); // حضّر اللي بعده فورًا
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Rewarded ad failed to show: $error');
        ad.dispose();
        rewardedAd = null;
        rewardedReady = false;

        if (mounted) {
          setState(() {});
        }

        _loadRewardedAd(); // جرّب تحميل إعلان جديد
      },
    );

    await rewardedAd!.show(
      onUserEarnedReward: (_, reward) {
        rewardEarned = true;
        watchedRewardedAdForCurrentQuestion = true;

        debugPrint(
          'Reward earned: amount=${reward.amount}, type=${reward.type}',
        );

        if (mounted) {
          setState(() {});
        }
      },
    );

    if (!rewardEarned) {
      debugPrint('Ad closed before earning reward');
    }
  }





  Future<void> _scrollToTopAnimated() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || !_scrollController.hasClients) return;

      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _scrollToCorrection() async {
    await Future.delayed(const Duration(milliseconds: 150));

    if (!_scrollController.hasClients) return;

    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  NativeAd? inlineNativeAd;
  bool isInlineNativeAdLoaded = false;
  bool isInlineNativeAdLoading = false;

  @override
  void initState() {
    super.initState();
    initData();
    final mainCubit = MainAppCubit.get(context);
    mainCubit.interstitialAd();
    _initBannerAds();
    _loadRewardedAd();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    myBannerTop?.dispose();
    myBannerBottom?.dispose();
    rewardedAd?.dispose();
    inlineNativeAd?.dispose();
    super.dispose();
  }

  Future<void> initData() async {
    final eventCubit = EventCubit.get(context);
    setState(() => isLoading = true);

    uid = await CashHelper.getData(key: 'uid');
    userName = await _resolveUserName(uid!);

    await eventCubit.prepareLeaderboardQuizSession(
      uid: uid!,
      event: widget.event,
    );

    setState(() => isLoading = false);
  }

  Future<String> _resolveUserName(String uid) async {
    try {
      final cachedName = await CashHelper.getData(key: 'name');
      if (cachedName != null && cachedName.toString().trim().isNotEmpty) {
        return cachedName.toString();
      }

      final doc = await EventCubit.get(context).fs.collection('users').doc(uid).get();
      final data = doc.data() ?? {};

      final name = data['username'] ??
          '';

      if (name.toString().trim().isNotEmpty) {
        return name.toString();
      }

      return 'User';
    } catch (_) {
      return 'User';
    }
  }
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final eventCubit = EventCubit.get(context);

    return BlocConsumer<EventCubit, EventState>(
      listener: (_, __) {},
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.lightColor,
            body: LoadingOverlay(
              isLoading: isLoadingAnswer,
              progressIndicator: Image.asset(
                'assets/img/ninja_gif.gif',
                height: 100,
                width: 100,
              ),
              child: WillPopScope(
                onWillPop: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const EventsPage()),
                  );
                  return true;
                },
                child: isLoading
                    ? const Center(
                  child: Image(
                    image: AssetImage('assets/img/ninja_gif.gif'),
                    height: 100,
                    width: 100,
                  ),
                )
                    : BlocBuilder<EventCubit, EventState>(
                  builder: (context, state) {
                    if (eventCubit.leaderboardQuestions.isEmpty) {
                      return const Center(child: Text("No questions"));
                    }

                    final currentQuestion = eventCubit
                        .leaderboardQuestions[
                    eventCubit.leaderboardCurrentQuestionIndex];

                    if (!shuffledChoicesMap
                        .containsKey(currentQuestion.questionId)) {
                      final originalChoices =
                      List<String>.from(currentQuestion.choices);
                      originalChoices.shuffle(Random());
                      shuffledChoicesMap[currentQuestion.questionId] =
                          originalChoices;
                    }

                    final shuffledChoices =
                    shuffledChoicesMap[currentQuestion.questionId]!;

                    final selectedAnswer = eventCubit
                        .leaderboardAnswerForQuestion(
                        currentQuestion.questionId);

                    final isPreviouslySelected =
                        selectedAnswer != null && selectedAnswer.isNotEmpty;

                    // final progress = eventCubit.leaderboardQuestions.isEmpty
                    //     ? 0.0
                    //     : (eventCubit.leaderboardCurrentQuestionIndex + 1) /
                    //     eventCubit.leaderboardQuestions.length;

                    final isGolden = currentQuestion.isGolden(widget.event);
                    final eventProgress =
                    eventCubit.userEventsProgress?[widget.event.id];

                    final rewardedApplied =
                        watchedRewardedAdForCurrentQuestion ||
                            (selectedAnswer?['watchedRewardedAd'] == true);

                    return Stack(
                      children: [
                        Column(
                          children: [
                            // if (isTopBannerLoaded && myBannerTop != null)
                            //   Container(
                            //     height: 60,
                            //     width: double.infinity,
                            //     alignment: Alignment.center,
                            //     child: AdWidget(ad: myBannerTop!),
                            //   ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                ),
                                child: Center(
                                  child: ListView(
                                    padding: const EdgeInsets.all(16.0),
                                    controller: _scrollController,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.18),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.close, color: Colors.white),
                                                  onPressed: () {
                                                    Navigator.of(context).pushReplacement(
                                                      MaterialPageRoute(builder: (_) => const EventsPage()),
                                                    );
                                                  },
                                                ),
                                                Expanded(
                                                  child:Text(
                                                    "${S.of(context).q} ${currentQuestion.order}",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.leaderboard, color: Colors.white),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) => EventLeaderboardPage(event: widget.event),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.12),
                                                borderRadius: BorderRadius.circular(14),
                                                border: Border.all(color: Colors.white.withOpacity(0.15)),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                                                  const SizedBox(width: 8),
                                                  Flexible(
                                                    child: Text(
                                                      "${eventProgress?.eventScore ?? 0}",
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (currentQuestion.imageUrl !=
                                          null &&
                                          currentQuestion.imageUrl != '')
                                        const SizedBox(height: 10)
                                      else
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height *
                                              .08,
                                        ),
                                      if (currentQuestion.imageUrl !=
                                          null &&
                                          currentQuestion.imageUrl != '')
                                        Center(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            currentQuestion.imageUrl!,
                                            height: 200,
                                            width: 200,
                                            placeholder: (context, url) =>
                                            const SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: Center(
                                                child: Image(
                                                  image: AssetImage(
                                                    'assets/img/ninja_gif.gif',
                                                  ),
                                                  height: 100,
                                                  width: 100,
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                            const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      if (isGolden) ...[
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber.withOpacity(.15),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.amber,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                               Row(
                                                children: [
                                                  Icon(Icons.star, color: Colors.amber),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    S.of(context).goldenQuestion,
                                                    style: const TextStyle(
                                                      color: Colors.amber,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                rewardedApplied
                                                    ? "${S.of(context).points}: ${widget.event.goldenQuestionPoints * widget.event.rewardedAdMultiplier}"
                                                    : "${S.of(context).points}: ${widget.event.goldenQuestionPoints}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 10),

                                              if (!isPreviouslySelected && !rewardedApplied)
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: rewardedReady ? _watchRewardedAd : null,
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.amber,
                                                      foregroundColor: Colors.black,
                                                    ),
                                                    child:  Text(
                                                      S.of(context).watchAdToDoublePoints,
                                                    ),
                                                  ),
                                                )
                                              else if (!isPreviouslySelected && rewardedApplied)
                                                Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber.withOpacity(.15),
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(color: Colors.amber),
                                                  ),
                                                  child:  Center(
                                                    child: Text(
                                                      S.of(context).adWatched,
                                                      style: const TextStyle(
                                                        color: Colors.amber,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              currentQuestion.content,
                                              style: const TextStyle(
                                                color: AppColors.whiteColor,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.left,
                                              softWrap: true,
                                              overflow:
                                              TextOverflow.visible,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              eventCubit.speak(
                                                currentQuestion.content,
                                                "en-US",
                                              );
                                            },
                                            icon: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    50),
                                              ),
                                              child: const Icon(
                                                Icons.volume_up,
                                                color:
                                                Color(0xff0a0a0a),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 30),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          for (int i = 0; i < shuffledChoices.length; i++) ...[
                                            if (i == 2)
                                              InlineNativeAdCard(
                                                key: ValueKey(
                                                  'inline-native-${eventCubit.leaderboardCurrentPageIndex}-${currentQuestion.questionId}',
                                                ),
                                                slotId:
                                                '${eventCubit.leaderboardCurrentPageIndex}-${currentQuestion.questionId}',
                                              ),

                                            Builder(
                                              builder: (context) {
                                                final choice = shuffledChoices[i];

                                                Color borderColor = AppColors.lightColor;
                                                Color textColor = Colors.white;
                                                Color backgroundColor = Colors.transparent;

                                                if (isPreviouslySelected) {
                                                  if (choice.trim() == selectedAnswer["answerContent"].trim()) {
                                                    if (selectedAnswer["correct"]) {
                                                      borderColor = Colors.green;
                                                      textColor = Colors.green;
                                                      backgroundColor = Colors.green.withOpacity(0.1);
                                                    } else {
                                                      borderColor = Colors.red;
                                                      textColor = Colors.red;
                                                      backgroundColor = Colors.red.withOpacity(0.1);
                                                    }
                                                  } else if (choice.trim() == currentQuestion.correctAnswer.trim()) {
                                                    borderColor = Colors.green;
                                                    textColor = Colors.green;
                                                    backgroundColor = Colors.green.withOpacity(0.1);
                                                  }
                                                }

                                                return InkWell(
                                                  onTap: isPreviouslySelected
                                                      ? null
                                                      : () async {
                                                    setState(() => isLoadingAnswer = true);

                                                    await eventCubit.submitLeaderboardAnswer(
                                                      uid: uid!,
                                                      event: widget.event,
                                                      question: currentQuestion,
                                                      selectedAnswer: choice.trim(),
                                                      watchedRewardedAd: watchedRewardedAdForCurrentQuestion,
                                                      userName: userName,
                                                    );

                                                    if (mounted) {
                                                      setState(() => isLoadingAnswer = false);
                                                    }

                                                    await _scrollToCorrection();
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets.only(bottom: 10),
                                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                                    decoration: BoxDecoration(
                                                      color: backgroundColor,
                                                      border: Border.all(
                                                        color: borderColor,
                                                        width: 3,
                                                      ),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        choice,
                                                        style: TextStyle(
                                                          color: textColor,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ],
                                      ),
                                      if (isPreviouslySelected) ...[
                                        const SizedBox(height: 16),
                                        Container(
                                          width: double.infinity,
                                          padding:
                                          const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: selectedAnswer[
                                            "correct"]
                                                ? Colors.green
                                                .withOpacity(.10)
                                                : Colors.red
                                                .withOpacity(.10),
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            border: Border.all(
                                              color: selectedAnswer[
                                              "correct"]
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                selectedAnswer["correct"]
                                                    ? "Correct"
                                                    : "Wrong",
                                                style: TextStyle(
                                                  color: selectedAnswer[
                                                  "correct"]
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "Correct Answer: ${currentQuestion.correctAnswer}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                currentQuestion.explanation,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 8,
                                right: 8,
                                bottom: 8,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final isFirstQuestionInPage =
                                              eventCubit.leaderboardCurrentQuestionIndex == 0;

                                          final willLoadPrevPage =
                                              isFirstQuestionInPage && eventCubit.leaderboardCurrentPageIndex > 0;

                                          watchedRewardedAdForCurrentQuestion = false;

                                          if (willLoadPrevPage) {
                                            setState(() => isLoadingAnswer = true);
                                          }

                                          await eventCubit.moveToPastLeaderboardQuestion(
                                            context,
                                            widget.event,
                                            uid!,
                                          );

                                          await _scrollToTopAnimated();

                                          if (mounted) {
                                            setState(() => isLoadingAnswer = false);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.mainColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          padding:
                                          const EdgeInsets.all(15),
                                        ),
                                        child: Center(
                                          child: Text(
                                            S.of(context).back,
                                            style: const TextStyle(
                                              color:
                                              AppColors.whiteColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                    MediaQuery.of(context).size.height *
                                        .01,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final isAnswered =
                                              eventCubit.leaderboardAnswerForQuestion(currentQuestion.questionId) != null;

                                          if (!isAnswered) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  S.of(context).pleaseAnswerTheQuestionFirst,
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          if (eventCubit.leaderboardCurrentQuestionIndex %7==0 || eventCubit.leaderboardCurrentQuestionIndex + 3 == eventCubit.leaderboardQuestions.length) {
                                            final mainCubit = MainAppCubit.get(context);
                                            mainCubit.interstitialAd();
                                          }

                                          final isLastQuestionInPage =
                                              eventCubit.leaderboardCurrentQuestionIndex ==
                                                  eventCubit.leaderboardQuestions.length - 1;

                                          final willLoadNewPage =
                                              isLastQuestionInPage && eventCubit.leaderboardHasNextPage;

                                          watchedRewardedAdForCurrentQuestion = false;

                                          if (willLoadNewPage) {
                                            setState(() => isLoadingAnswer = true);
                                          }

                                          if (rewardedAd == null && !isRewardedLoading) {
                                            _loadRewardedAd();
                                          }

                                          await eventCubit.moveToNextLeaderboardQuestion(
                                            context,
                                            widget.event,
                                            uid!,
                                          );

                                          await _scrollToTopAnimated();

                                          if (mounted) {
                                            setState(() => isLoadingAnswer = false);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.mainColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          padding:
                                          const EdgeInsets.all(15),
                                        ),
                                        child: Center(
                                          child: Text(
                                            S.of(context).continueExams,
                                            style: const TextStyle(
                                              color:
                                              AppColors.whiteColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isBottomBannerLoaded &&
                                myBannerBottom != null)
                              Container(
                                height: 60,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: AdWidget(ad: myBannerBottom!),
                              )
                            else
                              const SizedBox(height: 60),
                          ],
                        ),
                      ],
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
}

class InlineNativeAdCard extends StatefulWidget {
  final String slotId;

  const InlineNativeAdCard({
    super.key,
    required this.slotId,
  });

  @override
  State<InlineNativeAdCard> createState() => _InlineNativeAdCardState();
}

class _InlineNativeAdCardState extends State<InlineNativeAdCard> {
  NativeAd? _nativeAd;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-7223929122163665/4814580348',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _loaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _nativeAd = null;
          if (!mounted) return;
          setState(() {
            _loaded = false;
          });
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: Colors.white,
        cornerRadius: 12,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: AppColors.secondColor,
          style: NativeTemplateFontStyle.bold,
          size: 14,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 14,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black54,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 12,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black45,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 11,
        ),
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _nativeAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      key: ValueKey('native-container-${widget.slotId}'),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        border: Border.all(
          color: AppColors.lightColor,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 72,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: AdWidget(
            key: ValueKey('native-ad-${widget.slotId}'),
            ad: _nativeAd!,
          ),
        ),
      ),
    );
  }
}