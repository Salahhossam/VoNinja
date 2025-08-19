import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../generated/l10n.dart';
import '../../shared/network/local/cash_helper.dart';
import 'lesson_card.dart';
import 'package:vo_ninja/shared/style/color.dart';
import 'package:vo_ninja/modules/taps_page/taps_page.dart';
import 'lessons_cubit/lessons_cubit.dart';
import 'lessons_cubit/lessons_state.dart';

class LessonsPage extends StatefulWidget {
  final String levelId;
  final double? page;
  final double? size;
  final String collectionName;
  final double rewardedPoints;
  final int numberOfLessons;
  const LessonsPage({
    super.key,
    required this.levelId,
    required this.page,
    required this.size,
    required this.collectionName,
    required this.rewardedPoints,
    required this.numberOfLessons
  });

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  bool isLoading = false;
  bool isLoadingMore = false; // Flag for pagination
  final ScrollController _scrollController =
      ScrollController(); // For detecting scroll

  @override
  void initState() {
    super.initState();
    initData();

    // Listen for scrolling and trigger pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        loadMoreLessons();
      }
    });
  }

  Future<void> initData() async {
    final lessonCubit = LessonCubit.get(context);
    setState(() {
      isLoading = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        String uid;
        // Wait until UID is retrieved
        uid = await CashHelper.getData(key: 'uid');

        await lessonCubit.getLessonsPageData(uid, widget.levelId,
            widget.collectionName, false, widget.rewardedPoints);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  Future<void> loadMoreLessons() async {
    if (!isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });

      final lessonCubit = LessonCubit.get(context);
      String uid = await CashHelper.getData(key: 'uid');

      await lessonCubit.getLessonsPageData(uid, widget.levelId,
          widget.collectionName, true, widget.rewardedPoints);

      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessonCubit = LessonCubit.get(context);
    return BlocConsumer<LessonCubit, LessonState>(
      listener: (BuildContext context, LessonState state) {},
      builder: (BuildContext context, LessonState state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.mainColor, // Main color
            appBar: AppBar(
              backgroundColor: AppColors.mainColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const TapsPage()),
                  );
                },
              ),
              title: Text(
                S.of(context).lessons,
                style:
                    const TextStyle(fontSize: 24, color: AppColors.lightColor),
              ),
              centerTitle: true,
            ),
            body: WillPopScope(
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
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).lessonsLearningVocabulary,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.lightColor),
                        ),
                        const SizedBox(height: 20),
                        _buildInfoCard(context),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.lightColor,
                              // Light background for lessons
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35),
                              ),
                            ),
                            child: BlocBuilder<LessonCubit, LessonState>(
                              builder: (context, state) {
                                return ListView.builder(
                                  controller: _scrollController,
                                  // Attach scroll controller
                                  padding: const EdgeInsets.all(20),
                                  itemCount: lessonCubit.lessonCards.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index <
                                        lessonCubit.lessonCards.length) {
                                      final lesson =
                                          lessonCubit.lessonCards[index];
                                      final progress =
                                          lessonCubit.learningProgress[index];
                                      return LessonCard(
                                        lessonId: lesson.lessonId,
                                        title: lesson.title,
                                        order: lesson.order,
                                        questionsCount: progress.questionsCount,
                                        points: progress.points,
                                        userPoints: progress.userPoints,
                                        userProgress: progress.userProgress,
                                        levelId: widget.levelId,
                                        page: widget.page!,
                                        size: widget.size!,
                                        collectionName: widget.collectionName,
                                        rewardedPoints: widget.rewardedPoints,
                                        canTab: (index == 0 || lessonCubit.learningProgress[index-1].userProgress == 1.0),
                                        previousTile: index != 0?lessonCubit.lessonCards[index-1].title:null,
                                        isLastExam: index+1==widget.numberOfLessons, numberOfLessons: widget.numberOfLessons,
                                      );
                                    } else {
                                      // Show loading indicator at bottom when fetching more
                                      return isLoadingMore
                                          ? const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Center(
                                                  child: Image(
                                                image: AssetImage(
                                                    'assets/img/ninja_gif.gif'),
                                                height: 100,
                                                width: 100,
                                              )),
                                            )
                                          : const SizedBox();
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

// Info card with main color icon and light background
  Widget _buildInfoCard(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightColor, // Light color background
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            const Icon(Icons.info, color: AppColors.mainColor, size: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                S.of(context).correctAnswerPoints,
                style: const TextStyle(
                  color: AppColors.mainColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
