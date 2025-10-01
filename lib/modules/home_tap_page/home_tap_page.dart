import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'; // NEW
import 'package:vo_ninja/shared/style/color.dart';
import '../../generated/l10n.dart';
import '../../shared/local_awesome_dialog.dart';
import '../../shared/network/local/cash_helper.dart';
import '../library_page/library_screen.dart';

import '../onboarding_screen.dart';
import 'home_tap_cubit/home_tap_cubit.dart';
import 'home_tap_cubit/home_tap_state.dart';
import 'progress_indicator_widget.dart';

class HomeTapPage extends StatefulWidget {
  const HomeTapPage({super.key});

  @override
  State<HomeTapPage> createState() => _HomeTapPageState();
}

class _HomeTapPageState extends State<HomeTapPage> {
  bool isLoading = false;
  String? uid;
  bool isBannerAdLoaded = false;
  BannerAd? _bannerAd;

  // --- Tutorial keys & objects (NEW) ---
  final GlobalKey _scoreCardKey = GlobalKey();
  final GlobalKey _adsIconKey   = GlobalKey();
  final GlobalKey _libraryKey   = GlobalKey();
  final ScrollController _scroll = ScrollController();
  TutorialCoachMark? _homeCoachMark;

  @override
  void initState() {
    super.initState();
    initData();
    HomeTapCubit.get(context).loadRewardAds();

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-7223929122163665/1831803488', // Test ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          log('Banner ad loaded successfully');
          setState(() {
            isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          log('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  Future<void> initData() async {
    final homeTapCubit = HomeTapCubit.get(context);
    setState(() {
      isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        uid = await CashHelper.getData(key: 'uid');
        homeTapCubit.levelsData = [];
        await homeTapCubit.checkUserDailyReward(uid!, context);
        if (homeTapCubit.userData != null) {
          await homeTapCubit.getUserRank(uid!);
        }
        setState(() {
          isLoading = false;
        });

        // --- Show tutorial once (NEW) ---
        final seen = false;//await CashHelper.getData(key: 'seen_tutorial_v1') == true;
        if (!seen && mounted) {
          // ندي فرصة للـ UI يترسم بالكامل
          await Future.delayed(const Duration(milliseconds: 350));
          _showHomeTutorial();
        }
      });
    });
  }

  // --- Build & show tutorial (NEW) ---
  Future<void> _showHomeTutorial() async {
    final targets = <TargetFocus>[
      TargetFocus(
        identify: "score_card",
        keyTarget: _scoreCardKey,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        radius: 16,
        color: AppColors.mainColor.withOpacity(0.80), // overlay بنفس ألوانك
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _bubble(
              title: "نقاطك & ترتيبك",
              body: "ده ملخص نقاطك وترتيبك (Rank). كل إجابة صحيحة بتزوّد رصيدك هنا.",
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "ads_icon",
        keyTarget: _adsIconKey,
        enableOverlayTab: true,
        shape: ShapeLightFocus.Circle,
        color: AppColors.mainColor.withOpacity(0.80),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _bubble(
              title: "مكافآت الإعلانات",
              body: "من هنا تقدر تشوف إعلان — لو متاح — وتاخد مكافأة فورية حسب القواعد.",
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "library_block",
        keyTarget: _libraryKey,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        color: AppColors.mainColor.withOpacity(0.80),
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _bubble(
              title: "Voninja Library",
              body: "مكتبة فيها محتوى إضافي يساعدك تتعلم أسرع وبشكل ممتع.",
            ),
          ),
        ],
      ),
    ];

    _homeCoachMark = TutorialCoachMark(
      targets: targets,
      textSkip: "تخطي",
      hideSkip: false,
      // لون الـ shadow متظبط بالفعل في كل TargetFocus
      onFinish: () async {
        // علّم إن الجولة اتشافت مرّة
        // await CashHelper.saveData(key: 'seen_tutorial_v1', value: true);
        // // اطلب فتح تبويب Learn في TapsPage
        // await CashHelper.saveData(key: 'start_learn_tour', value: true);
      },
      onSkip: () {
        // fire-and-forget
        // CashHelper.saveData(key: 'seen_tutorial_v1', value: true);
        return true; // لازم ترجع bool
      },

    );

    _homeCoachMark!.show(context: context);
  }

  Widget _bubble({required String title, required String body}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor, // أبيض من ألوانك
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.secondColor.withOpacity(.25), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.mainColor, // عنوان باللون الأساسي
              )),
          const SizedBox(height: 8),
          Text(body,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              )),
          const SizedBox(height: 8),
          Text(
            "اضغط في أي مكان للمتابعة",
            style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(.45)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeTapCubit = HomeTapCubit.get(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeTapCubit, HomeTapState>(
          listener: (context, state) {
            // You can add specific logic if needed
          },
        ),
      ],
      child: BlocBuilder<HomeTapCubit, HomeTapState>(
        builder: (BuildContext context, HomeTapState state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.lightColor,
              body: isLoading
                  ? const Center(
                child: Image(
                  image: AssetImage('assets/img/ninja_gif.gif'),
                  height: 100,
                  width: 100,
                ),
              )
                  : WillPopScope(
                onWillPop: () async => homeTapCubit.doubleBack(context),
                child: SingleChildScrollView(
                  controller: _scroll, // NEW
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 80),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LibraryScreen()));
                        },
                        child: Container(
                          key: _libraryKey, // NEW (لـ Library)
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.secondColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 30),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).libraryTitle,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 4,
                                            color: Colors.black26,
                                            offset: Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      S.of(context).librarySubtitle,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 30),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.secondColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'لَا تَدَعُوا التَّطْبِيقَ يُلْهِيكُمْ عَنْ العِبَادَاتِ وَالصَّلَاةِ المَفْرُوضَهْ وَإِذَا وَجَدْتُمْ مَا يُخَالِفُ الدَّيْنَ فَغُضُّوا أَبْصَارَكُم',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      BlocBuilder<HomeTapCubit, HomeTapState>(
                        builder: (context, state) {
                          return Center(
                            child: isBannerAdLoaded && _bannerAd != null
                                ? SizedBox(
                              height: _bannerAd!.size.height.toDouble(),
                              width: MediaQuery.of(context).size.width * .9,
                              child: AdWidget(ad: _bannerAd!),
                            )
                                : null,
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final homeTapCubit = HomeTapCubit.get(context);
    return BlocBuilder<HomeTapCubit, HomeTapState>(
      builder: (context, state) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0),
              decoration: const BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${S.of(context).hi}, ${homeTapCubit.userData?.firstName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@${homeTapCubit.userData?.userName}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      _buildProfileIcon(context),
                    ],
                  ),
                ],
              ),
            ),
            _buildScoreCard(context),
          ],
        );
      },
    );
  }

  // Profile icon widget
  Widget _buildProfileIcon(BuildContext context) {
    final homeTapCubit = HomeTapCubit.get(context);
    return BlocBuilder<HomeTapCubit, HomeTapState>(
      builder: (context, state) {
        return InkWell(
          onTap: homeTapCubit.isAdShowing
              ? null
              : () async {
            if (!homeTapCubit.isProfileIconEnabled) {
              LocalAwesomeDialog(
                context: context,
                dialogType: LocalDialogType.warning,
                title: 'Warning',
                desc: 'Ad is not ready now try again later',
                btnOkOnPress: () {},
              ).show();
            } else {
              final result = await homeTapCubit.showAds(uid);
              LocalAwesomeDialog(
                context: context,
                dialogType: result['success'] ? LocalDialogType.success : LocalDialogType.error,
                title: result['title'],
                desc: result['message'],
                btnOkOnPress: () {},
              ).show();
            }
          },
          child: Container(
            key: _adsIconKey, // NEW
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: Image.asset(
              'assets/img/ADs.png',
              width: 40,
              height: 40,
            ),
          ),
        );
      },
    );
  }

  Widget _buildScoreCard(BuildContext context) {
    final homeTapCubit = HomeTapCubit.get(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeTapCubit, HomeTapState>(
          listener: (context, state) {
            if (state is HomeTapPointsLoaded) {}
          },
        ),
        BlocListener<HomeTapCubit, HomeTapState>(
          listener: (context, state) {
            if (state is HomeTapRankLoaded) {}
          },
        ),
      ],
      child: Positioned(
        bottom: -50,
        left: 55,
        right: 55,
        child: Container(
          key: _scoreCardKey, // NEW
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.lightColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 50,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/img/face.png',
                width: 60,
                height: 60,
              ),
              Flexible(
                child: BlocBuilder<HomeTapCubit, HomeTapState>(
                  builder: (context, state) {
                    return _buildStatCard(
                      '${homeTapCubit.userData?.pointsNumber?.toInt()}',
                      S.of(context).points,
                      context,
                    );
                  },
                ),
              ),
              Flexible(
                child: BlocBuilder<HomeTapCubit, HomeTapState>(
                  builder: (context, state) {
                    return _buildStatCard(
                      '${homeTapCubit.rank.toInt()}',
                      S.of(context).rank,
                      context,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .2,
          child: Text(
            value,
            maxLines: 2,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final homeTapCubit = HomeTapCubit.get(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).progress,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<HomeTapCubit, HomeTapState>(
            builder: (context, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: homeTapCubit.levelsData.map((levelData) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 10.0),
                      child: ProgressIndicatorWidget(
                        label: levelData.levelDifficulty,
                        percentage: levelData.levelProgress,
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
