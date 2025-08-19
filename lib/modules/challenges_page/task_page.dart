import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';
import 'package:vo_ninja/generated/l10n.dart';
import 'package:vo_ninja/modules/challenges_page/task_card.dart';
import 'package:vo_ninja/modules/challenges_page/task_cubit/task_cubit.dart';
import 'package:vo_ninja/modules/challenges_page/task_cubit/task_state.dart';
import '../../shared/network/local/cash_helper.dart';
import '../../shared/style/color.dart';
import 'challenges_page.dart';

class TaskPage extends StatefulWidget {
  final String challengesName;
  final String challengeId;
  final double rewardPoints;
  final double subscriptionCostPoints;
  final String status;
  final double challengesNumberOfTasks;
  final double numberOfQuestion;
  final double challengesNumberOfSubscriptions;

  const TaskPage(
      {super.key,
      required this.challengesName,
      required this.challengeId,
      required this.rewardPoints,
      required this.subscriptionCostPoints,
      required this.status,
      required this.challengesNumberOfTasks,
      required this.challengesNumberOfSubscriptions,
      required this.numberOfQuestion});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {



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

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initData() async {
    final taskCubit = TaskCubit.get(context);
    setState(() {
      isLoading = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        String uid;
        // Wait until UID is retrieved
        uid = await CashHelper.getData(key: 'uid');
        await taskCubit.getChallengeData(
            uid, widget.challengeId, false, widget.rewardPoints);
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

      final taskCubit = TaskCubit.get(context);
      String uid = await CashHelper.getData(key: 'uid');

      await taskCubit.getChallengeData(
          uid, widget.challengeId, true, widget.rewardPoints);

      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskCubit = TaskCubit.get(context);

    return BlocConsumer<TaskCubit, TaskState>(
        listener: (BuildContext context, TaskState state) {},
        builder: (BuildContext context, TaskState state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.lightColor,
              body: WillPopScope(
                onWillPop: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ChallengesPage(),
                    ),
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
                        children: [
                          Stack(
                            children: [
                              Image.asset('assets/img/task.png',
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.28,
                                  fit: BoxFit.cover),
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: AppBar(
                                    scrolledUnderElevation: 0,
                                    backgroundColor: Colors.transparent,
                                    leading: IconButton(
                                      icon: const Icon(Icons.arrow_back,
                                          color: Colors.white),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ChallengesPage(),
                                          ),
                                        );
                                      },
                                    ),
                                    title: Text(
                                      S.of(context).bringYourSword,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    centerTitle: true,
                                  )),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: AppColors.lightColor,
                              ),
                              child: ListView.builder(
                                padding: const EdgeInsets.all(20),
                                controller: _scrollController,
                                itemCount: taskCubit.taskCards.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < taskCubit.taskCards.length) {
                                    final task = taskCubit.taskCards[index];
                                    final progress =
                                        taskCubit.taskProgress[index];
                                    return TaskCard(
                                      challengesName: widget.challengesName,
                                      challengeId: widget.challengeId,
                                      rewardPoints: widget.rewardPoints,
                                      subscriptionCostPoints:
                                          widget.subscriptionCostPoints,
                                      status: widget.status,

                                      challengesNumberOfTasks:
                                          widget.challengesNumberOfTasks,
                                      challengesNumberOfSubscriptions: widget
                                          .challengesNumberOfSubscriptions,
                                      isCompleted: progress.userProgress == 1,
                                      taskId: task.taskId!,
                                      taskName: task.title!,
                                      numberOfQuestion:
                                          task.numberOfQuestion!.toDouble(),
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
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        });
  }
}
