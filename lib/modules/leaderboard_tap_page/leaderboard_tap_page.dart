import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/shared/style/color.dart';
import '../../generated/l10n.dart';
import '../../shared/network/local/cash_helper.dart';
import '../taps_page/taps_cubit/taps_cubit.dart';
import 'leaderboard_card.dart';
import 'leaderboard_tap_cubit/leaderboard_tap_cubit.dart';
import 'leaderboard_tap_cubit/leaderboard_tap_state.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  bool isLoading = false;
  String uid = '';
  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    final leaderboardTapCubit = LeaderboardTapCubit.get(context);
    setState(() {
      isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        // Wait until UID is retrieved

        uid = await CashHelper.getData(key: 'uid');

        await leaderboardTapCubit.fetchLeaderboards();
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final leaderboardTapCubit = LeaderboardTapCubit.get(context);

    return BlocConsumer<LeaderboardTapCubit, LeaderboardTapState>(
      listener: (BuildContext context, LeaderboardTapState state) {},
      builder: (BuildContext context, LeaderboardTapState state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.lightColor,
            body: WillPopScope(
              onWillPop: () async {
                TapsCubit.get(context).selectTab(0);

                return false;
              },
              child: isLoading
                  ? const Center(
                      child: Image(
                        image: AssetImage('assets/img/ninja_gif.gif'),
                        height: 100,
                        width: 100,
                      ),
                    )
                  : Stack(
                      children: [
                        ClipPath(
                          clipper: BottomSemicircleClipper(),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.mainColor,
                                  AppColors.mainColor,
                                  AppColors.whiteColor,
                                  AppColors.whiteColor,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.5, 0.7, 1, 1.0],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
// Leaderboard Header
                            Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Center(
                                child: Text(
                                  S.of(context).leaderboard,
                                  style: const TextStyle(
                                    color: AppColors.lightColor,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
// Colored container to control item visibility
                            Expanded(
                              child: ShaderMask(
                                shaderCallback: (bounds) {
                                  return const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.white, Colors.transparent],
                                    stops: [0.8, 0.9],
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.dstIn,
                                child: BlocBuilder<LeaderboardTapCubit,
                                    LeaderboardTapState>(
                                  builder: (context, state) {
                                    return ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                              horizontal: 40.0)
                                          .copyWith(bottom: 80),
                                      itemCount: leaderboardTapCubit
                                          .leaderboards.length,
                                      itemBuilder: (context, index) {
                                        final leaderboardsTap =
                                            leaderboardTapCubit
                                                .leaderboards[index];

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: LeaderboardCard(
                                            id: leaderboardsTap.id,
                                            rank: leaderboardsTap.rank,
                                            username: leaderboardsTap.username,
                                            userAvatar:
                                                leaderboardsTap.userAvatar,
                                            points: leaderboardsTap.points,
                                            currentUserId: uid,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

// Custom Clipper for Bottom Semicircle
class BottomSemicircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 80,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
