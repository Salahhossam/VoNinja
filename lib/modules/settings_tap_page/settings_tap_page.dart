import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/shared/style/color.dart';

import '../../generated/l10n.dart';
import '../../shared/network/local/cash_helper.dart';
import '../taps_page/taps_cubit/taps_cubit.dart';
import '../treasure_boxes_page/treasure_boxes_page.dart';
import 'balance_widget.dart';
import 'profile_header_widget.dart';
import 'settings_options_list.dart';
import 'settings_tap_cubit/settings_tap_cubit.dart';
import 'settings_tap_cubit/settings_tap_state.dart';

class SettingsTapPage extends StatefulWidget {
  const SettingsTapPage({super.key});

  @override
  State<SettingsTapPage> createState() => _SettingsTapPageState();
}

class _SettingsTapPageState extends State<SettingsTapPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    final settingsTapCubit = SettingsTapCubit.get(context);
    setState(() {
      isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        String uid;
        uid = await CashHelper.getData(key: 'uid');
        await settingsTapCubit.getUserData(uid);
        await settingsTapCubit.getAppVersion();
        await settingsTapCubit.getPointPrice();
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsTapCubit = SettingsTapCubit.get(context);

    return BlocConsumer<SettingsTapCubit, SettingsTapState>(
      listener: (BuildContext context, SettingsTapState state) {},
      builder: (BuildContext context, SettingsTapState state) {
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
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          ProfileHeader(
                            userAvatar: settingsTapCubit.userData?.userAvatar ??
                                'assets/img/ninja1.png',
                            userName: settingsTapCubit.userData?.userName ??
                                'userName',
                            firstName: settingsTapCubit.userData?.firstName ??
                                'firstName',
                          ),
                          const SizedBox(height: 20),
                          BalanceSection(
                            userBalance:
                                (settingsTapCubit.userData?.pointsNumber ?? 0) *
                                    settingsTapCubit.pointPrice,
                          ),
                          const SizedBox(height: 20),
                          SettingsOptionsList(
                              versionNumber:
                                  'v ${settingsTapCubit.appVersion}'),
                          const SizedBox(height: 20),
                          // داخل Column(...) قبل LogoutButton()
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              color: AppColors.mainColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                selectedColor: AppColors.mainColor,
                                leading: const Icon(Icons.card_giftcard, color: AppColors.secondColor),
                                title: Text(
                                  S.of(context).treasureBoxesCard,
                                  style: const TextStyle(color: AppColors.whiteColor),
                                ),
                                subtitle: Text(
                                  S.of(context).treasureBoxesLevels,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: const Icon(Icons.chevron_right, color: AppColors.whiteColor),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const TreasureBoxesPage()),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const LogoutButton(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
