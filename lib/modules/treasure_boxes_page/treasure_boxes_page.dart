import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:vo_ninja/modules/treasure_boxes_page/rewarded_ads_service.dart';
import 'package:vo_ninja/modules/treasure_boxes_page/treasure_boxes_cubit/treasure_boxes_cubit.dart';
import 'package:vo_ninja/modules/treasure_boxes_page/treasure_boxes_cubit/treasure_boxes_state.dart';
import '../../../shared/style/color.dart';
import '../../generated/l10n.dart';
import '../../models/treasure_model.dart';
import 'box_card.dart';


class TreasureBoxesPage extends StatelessWidget {
  const TreasureBoxesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TreasureBoxCubit()..load(),
      child: Scaffold(
        backgroundColor: AppColors.lightColor,
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          title: Text(S.of(context).treasureBoxes, style: const TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocConsumer<TreasureBoxCubit, TreasureBoxState>(
          listener: (context, state) {
            if (state is TreasureBoxMessage) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is TreasureBoxFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          builder: (context, state) {
            final c = TreasureBoxCubit.get(context);

            // تحميل أولي للشاشة — isLoading1
            if (c.isLoading1 || state is TreasureBoxInitial) {
              return const Center(
                child: Image(
                  image: AssetImage('assets/img/ninja_gif.gif'),
                  height: 100, width: 100,
                ),
              );
            }

            final unlocked = c.unlockedTier;

            return LoadingOverlay(
              isLoading: c.isLoading2,
              progressIndicator:
              Image.asset('assets/img/ninja_gif.gif', height: 100, width: 100),
              child: DefaultTabController(
                length: 3,
                initialIndex: TreasureTier.values.indexOf(unlocked),
                child: NestedScrollView(
                  // كله Scroll واحد: الهيدر + التابات + محتوى التاب
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                    // SliverToBoxAdapter(child: _fixedNewCycleBanner(context)),
                    // const SliverToBoxAdapter(child: SizedBox(height: 8)),
                    SliverToBoxAdapter(
                        child: _header(userPoints: c.userPoints, cycle: c.cycle, context: context)),
                    SliverToBoxAdapter(
                      child: (c.bronzeIndex >= (c.tiers[TreasureTier.bronze]?.length ?? 0)) &&
                          (c.silverIndex >= (c.tiers[TreasureTier.silver]?.length ?? 0)) &&
                          (c.goldIndex >= (c.tiers[TreasureTier.gold]?.length ?? 0))?
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.restart_alt),
                            label: Text(S.of(context).startNewCycle),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainColor,
                              foregroundColor: AppColors.whiteColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            onPressed: () => _confirmStartNewCycle(context),
                          ),
                        ),
                      ):Container(),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),

                    // TabBar غير مثبت (هيتحرك مع الاسكرول)
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          isScrollable: false,
                          labelColor: Colors.black,
                          indicatorColor: AppColors.secondColor,
                          onTap: (i) {
                            final desired = TreasureTier.values[i];
                            if (desired != unlocked) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(S.of(context).completeCurrentLevel)),
                              );
                              DefaultTabController.of(context).index =
                                  TreasureTier.values.indexOf(unlocked);
                            } else {
                              c.requestSwitchTier(desired,context: context);
                            }
                          },
                          tabs: [
                            Tab(text: S.of(context).bronze),
                            Tab(text: S.of(context).silver),
                            Tab(text: S.of(context).gold),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // الجسم: كل تبويب = CustomScrollView + SliverGrid (مفيش Scroll داخل Scroll)
                  body: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _tierSliverGrid(context, TreasureTier.bronze,
                          locked: unlocked != TreasureTier.bronze),
                      _tierSliverGrid(context, TreasureTier.silver,
                          locked: unlocked != TreasureTier.silver),
                      _tierSliverGrid(context, TreasureTier.gold,
                          locked: unlocked != TreasureTier.gold),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ======= Widgets المساعدة =======

  // static Widget _fixedNewCycleBanner(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 12),
  //     child: Container(
  //       width: double.infinity,
  //       padding: const EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //         color: AppColors.whiteColor,
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: AppColors.secondColor.withOpacity(0.3)),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(S.of(context).wantNewAdventure,
  //               style: const TextStyle(fontWeight: FontWeight.bold)),
  //           const SizedBox(height: 6),
  //           Text(S.of(context).newCycleDescription),
  //           const SizedBox(height: 6),
  //           Text(S.of(context).importantWarning, style: const TextStyle(fontWeight: FontWeight.bold)),
  //           Text(S.of(context).cycleWarning),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  static void _confirmStartNewCycle(BuildContext context) {
    final c = TreasureBoxCubit.get(context);

    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: false,
      btnOkText: S.of(context).confirm,
      btnCancelText: S.of(context).back,
      btnOkColor: AppColors.mainColor,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        // سيطبّق القيود داخل الكيوبت (إنهاء كل الصناديق + حد 25K)
        c.startNewCycleManually(context: context);
      },
      title: S.of(context).confirmNewCycle,
      desc: S.of(context).confirmNewCycleDescription,
    ).show();
  }

  static Widget _header({required int userPoints, required int cycle, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: AppColors.whiteColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                leading: const Icon(Icons.stars, color: AppColors.secondColor),
                title:
                Text(S.of(context).yourPoints, overflow: TextOverflow.ellipsis),
                subtitle: Text('$userPoints',
                    overflow: TextOverflow.ellipsis, maxLines: 1),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Card(
              color: AppColors.whiteColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                leading: const Icon(Icons.refresh, color: AppColors.greenColor),
                title: Text(S.of(context).cycle, overflow: TextOverflow.ellipsis),
                subtitle:
                Text('#$cycle', overflow: TextOverflow.ellipsis, maxLines: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// تبويب واحد: Scroll انسيابي باستخدام SliverGrid داخل CustomScrollView
  static Widget _tierSliverGrid(BuildContext context, TreasureTier tier,
      {required bool locked}) {
    final c = TreasureBoxCubit.get(context);
    final boxes = c.buildTierBoxes(tier);

    // المؤشر المتوقع من تقدّم المستخدم
    final expected = switch (tier) {
      TreasureTier.bronze => c.bronzeIndex,
      TreasureTier.silver => c.silverIndex,
      TreasureTier.gold => c.goldIndex,
    }.clamp(0, boxes.isEmpty ? 0 : boxes.length);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, i) {
                final status = (i < expected)
                    ? BoxCardStatus.done
                    : (i == expected
                    ? BoxCardStatus.next
                    : BoxCardStatus.locked);
                final isCurrent = (tier == c.currentTier) && (i == c.currentIndex);

                return BoxCard(
                  context: context,
                  tier: tier,
                  box: boxes[i],
                  status: locked ? BoxCardStatus.locked : status,
                  userPoints: c.userPoints,
                  isCurrent: !locked && isCurrent,
                  currentAdsWatched: c.currentAdsWatched,
                  onWatchAd: () async {
                    await RewardedAdsService.instance.preload();
                    await c.watchAdForCurrent(context:context,showAd: () {
                      return RewardedAdsService.instance.show();
                    });
                  },
                  onOpen: () => c.tryOpenCurrent(context: context),
                );
              },
              childCount: boxes.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // عمودين
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.80,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}