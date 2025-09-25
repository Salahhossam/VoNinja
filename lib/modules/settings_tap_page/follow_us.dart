
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vo_ninja/modules/settings_tap_page/settings_tap_cubit/settings_tap_state.dart';
import 'package:vo_ninja/shared/style/color.dart';

import '../../generated/l10n.dart';
import '../../shared/local_awesome_dialog.dart';
import '../taps_page/taps_page.dart';
import 'settings_tap_cubit/settings_tap_cubit.dart';

class FollowUs extends StatelessWidget {
  const FollowUs({super.key});

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsTapCubit = SettingsTapCubit.get(context);

    return BlocConsumer<SettingsTapCubit, SettingsTapState>(
        listener: (BuildContext context, SettingsTapState state) {},
        builder: (BuildContext context, SettingsTapState state) {
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: AppColors.lightColor,
              appBar: AppBar(
                backgroundColor: AppColors.mainColor,
                scrolledUnderElevation: 0,
                iconTheme: const IconThemeData(
                  color: AppColors.whiteColor, // makes leading icons white
                ),
                title: Text(
                  S.of(context).socialMedia,
                  style: const TextStyle(
                      color: AppColors.whiteColor),
                ),
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: settingsTapCubit.rewardCodeController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText:
                                '  ${S.of(context).enterYourRewardCode}',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                  color: Color(0xFF535555), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                  color: Color(0xFF535555), width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        state is PostRewardCodeLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    String result =
                                        await settingsTapCubit.postRewardCode(
                                            settingsTapCubit
                                                .rewardCodeController.text,
                                            settingsTapCubit
                                                    .userData?.userId ??
                                                '');
                                    if (result == 'Success') {
                                      LocalAwesomeDialog(
                                        context: context,
                                        dialogType: LocalDialogType.success,
                                        title: 'Success',
                                        desc:
                                            'Transaction completed successfully!',
                                        btnOkOnPress: () {},
                                      ).show();
                                    } else {
                                      LocalAwesomeDialog(
                                        context: context,
                                        dialogType: LocalDialogType.error,
                                        title: 'Error',
                                        desc: result,
                                        btnOkOnPress: () {},
                                      ).show();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.mainColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                  ),
                                  child: Text(
                                    S.of(context).getPoints,
                                    style: const TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                _launchURL('https://www.facebook.com/share/16TodybiRP/');
                              },
                              child: Image.asset(
                                'assets/img/facebook.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                            const SizedBox(width: 20),
                            InkWell(
                              onTap: () {
                                _launchURL('https://www.instagram.com/vo_nin_ja?igsh=MmVtZDlvMGF3eHNy');
                              },
                              child: Image.asset(
                                'assets/img/instagram.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                            const SizedBox(width: 20),
                            InkWell(
                              onTap: () {
                                _launchURL('https://www.tiktok.com/@vo.ninja.app?_t=ZS-8xE13Dsqbnr&_r=1');
                              },
                              child: Image.asset(
                                'assets/img/tiktok.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          S.of(context).followOurSocialMedia,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(128, 128, 128, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
