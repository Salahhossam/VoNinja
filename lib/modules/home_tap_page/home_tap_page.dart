import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:vo_ninja/shared/style/color.dart';
import '../../generated/l10n.dart';

import '../../shared/network/local/cash_helper.dart';
import 'home_tap_cubit/home_tap_cubit.dart';
import 'home_tap_cubit/home_tap_state.dart';
import 'progress_indicator_widget.dart';

class HomeTapPage extends StatefulWidget {
  const HomeTapPage({
    super.key,
  });

  @override
  State<HomeTapPage> createState() => _HomeTapPageState();
}

class _HomeTapPageState extends State<HomeTapPage> {
  bool isLoading = false;
  String? uid;
  bool isBannerAdLoaded = false;
  BannerAd? _bannerAd;

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
        //await homeTapCubit.loadRewardAds();
        // Now that we have UID, proceed with fetching data
        homeTapCubit.levelsData = [];
        await homeTapCubit.getUserData(uid!);
        if (homeTapCubit.userData != null) {
          await homeTapCubit.getLevelsDataProgress(uid!);
          await homeTapCubit.getUserRank(uid!);
        }
        setState(() {
          isLoading = false;
        });
      });
    });
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(context),
                            const SizedBox(height: 60),
                            _buildProgressSection(context),
                            const SizedBox(height: 60),
                            BlocBuilder<HomeTapCubit, HomeTapState>(
                              builder: (context, state) {
                                return Center(
                                  child: isBannerAdLoaded && _bannerAd != null
                                      ? SizedBox(
                                          height:
                                              _bannerAd!.size.height.toDouble(),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .9,
                                          child: AdWidget(ad: _bannerAd!),
                                        )
                                      : null, // Show nothing until ad is ready
                                );
                              },
                            ),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 80.0),
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
          onTap: homeTapCubit.isAdShowing || !homeTapCubit.isProfileIconEnabled
              ? null
              : () {
                  homeTapCubit.showAds(uid);
                },
          child: Container(
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
           //   color: Colors.white,
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
            if (state is HomeTapPointsLoaded) {
              // points = state.points;
            }
          },
        ),
        BlocListener<HomeTapCubit, HomeTapState>(
          listener: (context, state) {
            if (state is HomeTapRankLoaded) {
              // rank = state.rank;
            }
          },
        ),
      ],
      child: Positioned(
        bottom: -50,
        left: 55,
        right: 55,
        child: Container(
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

  // Stat card widget
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

// Progress section widget
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
                      padding: const EdgeInsets.only(
                          right: 8.0, left: 8.0, bottom: 10.0),
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
