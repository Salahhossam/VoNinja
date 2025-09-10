
import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void showTopFlushBar(BuildContext context, String message) {
    Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.TOP, // يخليه يظهر فوق
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.black87,
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TreasureBoxCubit()..load(),
      child: Scaffold(
        backgroundColor: AppColors.lightColor,

        body: BlocConsumer<TreasureBoxCubit, TreasureBoxState>(
          listener: (context, state) {
            if (state is TreasureBoxMessage) {
              showTopFlushBar(context, state.message);
            } else if (state is TreasureBoxFailure) {
              showTopFlushBar(context, state.errorMessage);
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

            // داخل builder بعد ما تجيب c وتتحقق من الـ loading
            final unlocked = c.unlockedTier;
            return LoadingOverlay(
              isLoading: c.isLoading2,
              progressIndicator: Image.asset('assets/img/ninja_gif.gif', height: 100, width: 100),
              child: DefaultTabController(
                length: 3,
                initialIndex: TreasureTier.values.indexOf(unlocked),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // ---------- الجزء الثابت (مش Scroll) ----------
                    _header(userPoints: c.userPoints, cycle: c.cycle, context: context),

                    if ((c.bronzeIndex >= (c.tiers[TreasureTier.bronze]?.length ?? 0)) &&
                        (c.silverIndex >= (c.tiers[TreasureTier.silver]?.length ?? 0)) &&
                        (c.goldIndex >= (c.tiers[TreasureTier.gold]?.length ?? 0)))
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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            onPressed: () => _confirmStartNewCycle(context),
                          ),
                        ),
                      ),

                    const SizedBox(height: 8),

                    Container(
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
                          c.requestSwitchTier(desired, context: context);
                          // (اختياري) لو عايز تربط الحركة يدويًا:
                          // DefaultTabController.of(context).animateTo(i);
                        },
                        tabs: [
                          Tab(text: S.of(context).bronze),
                          Tab(text: S.of(context).silver),
                          Tab(text: S.of(context).gold),
                        ],
                      ),
                    ),

                    // ---------- الجزء المتحرّك فقط ----------
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _tierSliverGrid(context, TreasureTier.bronze,
                              locked: false),
                          _tierSliverGrid(context, TreasureTier.silver,
                              locked: unlocked != TreasureTier.silver && (unlocked != TreasureTier.gold) ),
                          _tierSliverGrid(context, TreasureTier.gold,
                              locked: unlocked != TreasureTier.gold),
                        ],
                      ),
                    ),
                  ],
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

    if (c.userPoints >= 25000) {
      // ممنوع يبدأ دورة جديدة
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        headerAnimationLoop: true,
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: true,
        btnOkText: S.of(context).ok, // زر واحد فقط
        btnOkColor: AppColors.mainColor,
        btnOkOnPress: () {},
        title: S.of(context).cannotStartNewCycle,
        desc: S.of(context).mustTransferPointsFirst,
      ).show();
    } else {
      // يقدر يبدأ دورة جديدة
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        headerAnimationLoop: true,
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: true,
        btnOkText: S.of(context).confirm,
        btnCancelText: S.of(context).back,
        btnOkColor: AppColors.mainColor,
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          // سيطبّق القيود داخل الكيوبت (إنهاء كل الصناديق + حد 25K)
          c.startNewCycleManually(context: context);
        },
        title: S.of(context).confirmNewCycle,
        desc: S.of(context).confirmNewCycleDesc,
      ).show();
    }
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