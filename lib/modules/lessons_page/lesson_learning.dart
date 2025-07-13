import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vo_ninja/generated/l10n.dart';

import 'package:vo_ninja/modules/lessons_page/learning_cubit/learning_state.dart';
import 'package:vo_ninja/modules/lessons_page/lessons_page.dart';
import 'package:vo_ninja/shared/style/color.dart';

import '../../shared/main_cubit/cubit.dart';
import '../../shared/network/local/cash_helper.dart';
import 'learning_cubit/learning_cubit.dart';

class LessonLearning extends StatefulWidget {
  final String lessonId;
  final String levelId;
  final String collectionName;
  final double page;
  final double size;
  final double order;
  final String title;
  final double userPoints;
  final double rewardedPoints;
  final double deducedPoints;
  final int numberOfLessons;
  final bool isLastExam;
  const LessonLearning(
      {super.key,
      required this.lessonId,
      required this.levelId,
      required this.page,
      required this.size,
      required this.order,
      required this.title,
      required this.userPoints,
      required this.collectionName,
      required this.rewardedPoints,
      required this.deducedPoints,
       required this.numberOfLessons,
        required this.isLastExam
      });

  @override
  State<LessonLearning> createState() => _LessonLearningState();
}

class _LessonLearningState extends State<LessonLearning> {
  bool isLoading = false;
  BannerAd? myBannerTop;
  BannerAd? myBannerBottom;
  bool isTopBannerLoaded = false;
  bool isBottomBannerLoaded = false;
  void _initBannerAds() {
    // Top Banner
    myBannerTop = BannerAd(
      adUnitId: 'ca-app-pub-7223929122163665/1831803488',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isTopBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // print('Failed to load a banner ad: ${error.message}');
          // print('Error code: ${error.code}');
          // print('Error domain: ${error.domain}');
          ad.dispose();
        },
      ),
    )..load();

    // Bottom Banner
    myBannerBottom = BannerAd(
      adUnitId: 'ca-app-pub-7223929122163665/1831803488',
      //adUnitId: 'ca-app-pub-7223929122163665/1831803488', // استبدل بمعرف وحدة الإعلان الخاصة بك
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isBottomBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // print('Failed to load a banner ad: ${error.message}');
          // print('Error code: ${error.code}');
          // print('Error domain: ${error.domain}');
          ad.dispose();
        },
      ),
    )..load();
  }
  @override
  void initState() {
    super.initState();
    initData();
    final mainCubit = MainAppCubit.get(context);
    mainCubit.interstitialAd();
    _initBannerAds();
  }

  Future<void> initData() async {
    final learningCubit = LearningCubit.get(context);
    setState(() {
      isLoading = true;
    });
    learningCubit.currentVocabIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        String uid;

        // Wait until UID is retrieved

        uid = await CashHelper.getData(key: 'uid');

        await learningCubit.getLessonsDetailsData(
            uid,
            widget.levelId,
            widget.collectionName,
            widget.lessonId,
            widget.title,
            widget.order.toInt(),
            vocab: true);
        setState(() {
          isLoading = false;
        });
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myBannerTop?.dispose();
    myBannerBottom?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final learningCubit = LearningCubit.get(context);
    return BlocConsumer<LearningCubit, LearningState>(
      listener: (BuildContext context, LearningState state) {},
      builder: (BuildContext context, LearningState state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.lightColor,
            body: WillPopScope(
              onWillPop: () async {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => LessonsPage(
                            levelId: widget.levelId,
                            page: widget.page,
                            size: widget.size,
                            collectionName: widget.collectionName,
                            rewardedPoints: widget.rewardedPoints,
                            deducedPoints: widget.deducedPoints, numberOfLessons: widget.numberOfLessons,
                          )),
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
                  : SingleChildScrollView(
                      child: BlocBuilder<LearningCubit, LearningState>(
                        builder: (context, state) {
                          final vocabularies =
                              learningCubit.lessonDetails?.vocabularies ?? [];
                          final currentVocab = vocabularies.isNotEmpty
                              ? vocabularies[learningCubit.currentVocabIndex]
                              : null;
                          final double progress = vocabularies.isNotEmpty
                              ? (learningCubit.currentVocabIndex + 1) /
                                  vocabularies.length
                              : 0;

                          if (currentVocab == null) {
                            return Center(
                                child: Text(
                                    S.of(context).noVocabulariesAvailable));
                          }

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Top Banner (only show if loaded)

                              // Blue container with rounded bottom
                              Container(
                                width: double.infinity,
                                height:
                                MediaQuery.of(context).size.height * .75,
                                decoration: const BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 30.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        if (isTopBannerLoaded && myBannerTop != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                                            height: 80,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            child: AdWidget(ad: myBannerTop!),
                                          ),
                                        // Small blue line at the top
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                color: AppColors.lightColor,
                                                size: 35,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LessonsPage(
                                                          levelId: widget.levelId,
                                                          page: widget.page,
                                                          size: widget.size,
                                                          collectionName:
                                                          widget.collectionName,
                                                          rewardedPoints:
                                                          widget.rewardedPoints,
                                                          deducedPoints:
                                                          widget.deducedPoints,
                                                          numberOfLessons: widget.numberOfLessons,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                            Expanded(
                                              child: LinearProgressIndicator(
                                                value: progress,
                                                backgroundColor:
                                                const Color.fromRGBO(
                                                    168, 168, 168, 1),
                                                color: AppColors.secondColor,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 0),
                                        if (currentVocab.imageUrl != null &&
                                            currentVocab.imageUrl != '')
                                        // Image
                                          CachedNetworkImage(
                                            imageUrl: currentVocab.imageUrl ??
                                                'http/',
                                            height: 200,
                                            width: 200,
                                            placeholder: (context, url) =>
                                            const SizedBox(
                                              height:
                                              30, // Adjust the size as needed
                                              width: 30,
                                              child: Center(
                                                  child: Image(
                                                    image: AssetImage(
                                                        'assets/img/ninja_gif.gif'),
                                                    height: 100,
                                                    width: 100,
                                                  )
                                                // Thinner indicator
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

                                        const SizedBox(height: 10),

                                        // Title Text
                                        Text(
                                          learningCubit.isEnglish
                                              ? currentVocab.word
                                              : currentVocab.translation,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 17),

                                        // Points display
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            // Button 1: Icon for Sound (Headphone)
                                            ElevatedButton(
                                              onPressed: () =>
                                                  learningCubit.speak(
                                                      learningCubit.isEnglish
                                                          ? currentVocab.word
                                                          : currentVocab
                                                          .translation,
                                                      learningCubit.isEnglish
                                                          ? "en-US"
                                                          : ""),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                    vertical: 17),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                  side: const BorderSide(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.volume_up,
                                                color: Color(0xff080808),
                                              ),
                                            ),
                                            const SizedBox(width: 15),

                                            ElevatedButton(
                                              onPressed: () {
                                                learningCubit.toggleLanguage();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                    vertical: 17),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                  side: const BorderSide(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.translate,
                                                color: Color(0xff050505),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 35),

                                        Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondColor,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 10, 0, 10),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    currentVocab.statement,
                                                    style: const TextStyle(
                                                      color: Colors.white,
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
                                                    learningCubit.speak(
                                                        currentVocab.statement,
                                                        "en-US");
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
                                                      color: Color(0xff0a0a0a),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                        Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondColor,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 10, 10, 10),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                // IconButton(
                                                //   onPressed: () {
                                                //     learningCubit.speak(
                                                //         currentVocab
                                                //             .statementTranslation,
                                                //         "ar-SA");
                                                //   },
                                                //   icon: Container(
                                                //     decoration: BoxDecoration(
                                                //       color: Colors.white,
                                                //       borderRadius:
                                                //           BorderRadius.circular(
                                                //               50),
                                                //     ),
                                                //     child: const Icon(
                                                //       Icons.volume_up,
                                                //       color: Color(0xff0a0a0a),
                                                //     ),
                                                //   ),
                                                // ),

                                                Expanded(
                                                  child: Text(
                                                    currentVocab
                                                        .statementTranslation,
                                                    // Use the variable for dynamic content
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                    softWrap: true,
                                                    overflow:
                                                    TextOverflow.visible,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Row of buttons with icons (new section)
                              const SizedBox(height: 40),

                              // Back to home button
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            learningCubit.pastVocabulary(
                                                context,
                                                widget.lessonId,
                                                widget.levelId,
                                                widget.page,
                                                widget.size,
                                                widget.order,
                                                widget.title,
                                                widget.userPoints,
                                                widget.collectionName,
                                                widget.rewardedPoints,
                                                widget.deducedPoints,widget.numberOfLessons,widget.isLastExam);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            AppColors.mainColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.all(15),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Center(
                                                child: Text(
                                                  S.of(context).back,
                                                  style: const TextStyle(
                                                      color:
                                                      AppColors.whiteColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                              // const Positioned(
                                              //   left: 0,
                                              //   child: Icon(
                                              //     Icons.arrow_back,
                                              //     color: Colors.white,
                                              //   ),
                                              // )
                                            ],
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
                                          onPressed: () {
                                            if (learningCubit.currentVocabIndex +1== (learningCubit.lessonDetails!.vocabularies!.length / 2).floor()||learningCubit.currentVocabIndex +3== learningCubit.lessonDetails!.vocabularies!.length) {
                                              final mainCubit = MainAppCubit.get(context);
                                              mainCubit.interstitialAd();
                                            }
                                            learningCubit.nextVocabulary(
                                                context,
                                                widget.lessonId,
                                                widget.levelId,
                                                widget.page,
                                                widget.size,
                                                widget.order,
                                                widget.title,
                                                widget.userPoints,
                                                widget.collectionName,
                                                widget.rewardedPoints,
                                                widget.deducedPoints,widget.numberOfLessons,widget.isLastExam);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            AppColors.mainColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.all(15),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Center(
                                                child: Text(
                                                  S.of(context).continueExams,
                                                  style: const TextStyle(
                                                      color:
                                                      AppColors.whiteColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                              // const Positioned(
                                              //   right: 0,
                                              //   child: Icon(
                                              //     Icons.arrow_back,
                                              //     color: Colors.white,
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (isBottomBannerLoaded && myBannerBottom != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  height: 80,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: AdWidget(ad: myBannerBottom!),
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
