
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/modules/taps_page/taps_page.dart';
import 'package:vo_ninja/shared/style/color.dart';
import '../../generated/l10n.dart';
import '../../shared/local_awesome_dialog.dart';
import 'settings_tap_cubit/settings_tap_cubit.dart';
import 'settings_tap_cubit/settings_tap_state.dart';

class SwitchCoinsPage extends StatefulWidget {
  const SwitchCoinsPage({super.key});

  @override
  State<SwitchCoinsPage> createState() => _SwitchCoinsPageState();
}

class _SwitchCoinsPageState extends State<SwitchCoinsPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final switchCoinsCubit = SettingsTapCubit.get(context);
    return BlocConsumer<SettingsTapCubit, SettingsTapState>(
      listener: (BuildContext context, SettingsTapState state) {},
      builder: (BuildContext context, SettingsTapState state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.lightColor,
            appBar: AppBar(
              title: Text(
                S.of(context).getYourPoints,
                style: const TextStyle(
                    color: AppColors.mainColor, fontWeight: FontWeight.bold),
              ),
              scrolledUnderElevation: 0,
              centerTitle: true,
              backgroundColor: AppColors.lightColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.mainColor),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const TapsPage()));
                },
              ),
            ),
            body: WillPopScope(
              onWillPop: () async {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const TapsPage()),
                );
                return true;
              },
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info,
                                  color: AppColors.whiteColor, size: 30),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  S.of(context).WithdrawPoints,
                                  style: const TextStyle(
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "${switchCoinsCubit.userData?.pointsNumber?.toInt()}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 48,
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          S.of(context).totalPoints,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(128, 128, 128, 1),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Column(
                          children: [
                            TextFormField(
                              controller:
                                  switchCoinsCubit.pointNumberController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: S.of(context).points,
                                filled: true,
                                fillColor:
                                    const Color.fromRGBO(177, 177, 177, 1),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none),
                              ),
                              onChanged: (val) {
                                double? enteredValue = double.tryParse(val);
                                if (enteredValue != null) {
                                  switchCoinsCubit.cashNumberController.text =
                                      '${(enteredValue * switchCoinsCubit.pointPrice).toStringAsFixed(1)} EGP';
                                } else if (enteredValue == null || val == '') {
                                  switchCoinsCubit.cashNumberController.text =
                                      '';
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a number.";
                                }
                                final numValue = int.tryParse(value);
                                if (numValue == null) {
                                  return "Please enter a valid number.";
                                }
                                if (numValue >
                                    switchCoinsCubit.userData!.pointsNumber!) {
                                  return "The entered number cannot exceed ${switchCoinsCubit.userData!.pointsNumber!}.";
                                }
                                return null;
                              },
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              color: const Color.fromRGBO(177, 177, 177, 1),
                              child: const Icon(
                                Icons.swap_vert,
                                size: 32,
                              ),
                            ),
                            TextFormField(
                              controller: switchCoinsCubit.cashNumberController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: S.of(context).cash,
                                filled: true,
                                fillColor:
                                    const Color.fromRGBO(177, 177, 177, 1),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).cash;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text(
                          S.of(context).enterPhoneNumberToGetCash,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: switchCoinsCubit.phoneNumberController,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: S.of(context).phoneNumber,
                            labelStyle: const TextStyle(
                              fontSize: 18,
                              color: Color.fromRGBO(0, 0, 0, 0.6),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * .04),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a phone number.";
                            }
                            final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
                            if (!phoneRegex.hasMatch(value)) {
                              return "Please enter a valid phone number.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        state is SettingsTapPostTransactionsPhoneNumberLoading
                            ? const Center(
                                child: Image(
                                  image: AssetImage('assets/img/ninja_gif.gif'),
                                  height: 100,
                                  width: 100,
                                ),
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        if (double.tryParse(switchCoinsCubit
                                                .pointNumberController.text)! <
                                            25000) {
                                          LocalAwesomeDialog(
                                            context: context,
                                            dialogType: LocalDialogType.error,
                                            title: 'Error',
                                            desc:
                                                'Transaction failed! Minimum transaction amount is 25000 points',
                                            btnOkOnPress: () {},
                                          ).show();
                                        } else {
                                          bool success = await switchCoinsCubit
                                              .postTransactionsPhoneNumber(
                                            double.tryParse(switchCoinsCubit
                                                .pointNumberController.text)!,
                                            switchCoinsCubit
                                                .phoneNumberController.text,
                                            switchCoinsCubit.userData!.userId!,
                                            double.tryParse(switchCoinsCubit
                                                    .pointNumberController
                                                    .text)! *
                                                switchCoinsCubit.pointPrice,
                                          );
                                          FocusScope.of(context).unfocus();
                                          if (success) {
                                            LocalAwesomeDialog(
                                              context: context,
                                              dialogType: LocalDialogType.success,
                                              title: 'Success',
                                              desc:
                                                  'Transaction completed successfully!',
                                              btnOkOnPress: () {},
                                            ).show();
                                          }
                                        }
                                      } catch (e) {
                                        FocusScope.of(context).unfocus();
                                        LocalAwesomeDialog(
                                          context: context,
                                          dialogType: LocalDialogType.error,
                                          title: 'Error',
                                          desc:
                                              'Transaction failed! Please try again.',
                                          btnOkOnPress: () {},
                                        ).show();
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.mainColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      S.of(context).sendDetails,
                                      style: const TextStyle(
                                          color: AppColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
