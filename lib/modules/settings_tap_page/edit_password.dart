
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/modules/settings_tap_page/edit_profile.dart';
import 'package:vo_ninja/shared/style/color.dart';
import '../../generated/l10n.dart';
import '../../shared/companent.dart';
import 'settings_tap_cubit/settings_tap_cubit.dart';
import 'settings_tap_cubit/settings_tap_state.dart';

class EditPasswordPage extends StatelessWidget {
  const EditPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsTapCubit = SettingsTapCubit.get(context);
    return BlocBuilder<SettingsTapCubit, SettingsTapState>(
      builder: (BuildContext context, SettingsTapState state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.lightColor,
            appBar: AppBar(
              backgroundColor: AppColors.lightColor,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.mainColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const EditProfilePage()));
                },
              ),
              centerTitle: true,
              title: Text(
                S.of(context).editPassword,
                style: const TextStyle(
                    color: AppColors.mainColor, fontWeight: FontWeight.bold),
              ),
            ),
            body: WillPopScope(
              onWillPop: () async {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const EditProfilePage()),
                );
                return true;
              },
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: settingsTapCubit.formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPasswordField(
                                  context: context,
                                  label: S.of(context).currentPassword,
                                  controller: settingsTapCubit
                                      .currentPasswordController,
                                  isVisible:
                                      settingsTapCubit.isCurrentPasswordVisible,
                                  toggleVisibility: settingsTapCubit
                                      .toggleCurrentPasswordVisibility,
                                  passwordLabel: S.of(context).currentPassword),
                              _buildPasswordField(
                                  context: context,
                                  label: S.of(context).newPassword,
                                  controller:
                                      settingsTapCubit.newPasswordController,
                                  isVisible:
                                      settingsTapCubit.isNewPasswordVisible,
                                  toggleVisibility: settingsTapCubit
                                      .toggleNewPasswordVisibility,
                                  passwordLabel: S.of(context).newPassword),
                              _buildPasswordField(
                                  context: context,
                                  label: S.of(context).confirmPassword,
                                  controller: settingsTapCubit
                                      .confirmPasswordController,
                                  isVisible:
                                      settingsTapCubit.isConfirmPasswordVisible,
                                  toggleVisibility: settingsTapCubit
                                      .toggleConfirmPasswordVisibility,
                                  passwordLabel: S.of(context).confirmPassword),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        state is PutEditPasswordLoading
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
                                    if (settingsTapCubit.formKey.currentState !=
                                            null &&
                                        settingsTapCubit.formKey.currentState!
                                            .validate()) {
                                      bool result = await settingsTapCubit
                                          .putEditPassword(
                                              settingsTapCubit
                                                  .currentPasswordController
                                                  .text,
                                              settingsTapCubit
                                                  .newPasswordController.text);
                                      if (result) {
                                        showSuccessDialog(
                                          context,
                                          title: 'Success',
                                          desc: 'Password changed successfully!',
                                          onOkPressed: () {},
                                        );
                                      } else {
                                        showErrorDialog(
                                          context,
                                          title: 'Error',
                                          desc: 'Failed to update password. The current password is incorrect.',
                                          onOkPressed: () {},
                                        );
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
                                      S.of(context).saveChanges,
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

  Widget _buildPasswordField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    required String passwordLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              color: AppColors.whiteColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !isVisible,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.lightColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: toggleVisibility,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).enterPasswordLabel(passwordLabel);
            }
            if (value !=
                    SettingsTapCubit.get(context).newPasswordController.text &&
                controller ==
                    SettingsTapCubit.get(context).confirmPasswordController) {
              return S.of(context).doNotMatch;
            }
            return null;
          },
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
