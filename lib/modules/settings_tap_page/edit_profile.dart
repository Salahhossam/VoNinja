import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/shared/style/color.dart';
import '../../generated/l10n.dart';
import '../../shared/companent.dart';
import '../taps_page/taps_page.dart';
import 'edit_password.dart';
import 'settings_tap_cubit/settings_tap_cubit.dart';
import 'settings_tap_cubit/settings_tap_state.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsTapCubit = SettingsTapCubit.get(context);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    settingsTapCubit.firstNameController.text =
        settingsTapCubit.userData?.firstName ?? '';
    settingsTapCubit.lastNameController.text =
        settingsTapCubit.userData?.lastName ?? '';
    settingsTapCubit.userNameController.text =
        settingsTapCubit.userData?.userName ?? '';
    settingsTapCubit.phoneNumberController.text =
        settingsTapCubit.userData?.userPhoneNumber ?? '';
    return BlocConsumer<SettingsTapCubit, SettingsTapState>(
      listener: (BuildContext context, SettingsTapState state) {},
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
                      builder: (context) => const TapsPage()));
                },
              ),
              centerTitle: true,
              title: Text(
                S.of(context).editProfile,
                style: const TextStyle(
                    color: AppColors.mainColor, fontWeight: FontWeight.bold),
              ),
            ),
            body: Form(
              key: formKey,
              child: WillPopScope(
                onWillPop: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const TapsPage()),
                  );
                  return true;
                },
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
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
                                Center(
                                  child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      0, 0, 0, 0),
                                              insetPadding: const EdgeInsets
                                                  .all(
                                                  20), // Adjust inset padding as needed
                                              content: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                padding:
                                                    const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .mainColor, // Dark background
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppColors
                                                          .secondColor
                                                          .withOpacity(
                                                              1), // Shadow color
                                                      spreadRadius:
                                                          3, // Spread of the shadow
                                                      blurRadius:
                                                          2, // Blur effect
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize
                                                      .min, // This makes the dialog fit content

                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      S
                                                          .of(context)
                                                          .chooseAnAvatar,
                                                      style: const TextStyle(
                                                        color: AppColors
                                                            .whiteColor,
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    SizedBox(
                                                      width: double.maxFinite,
                                                      child: GridView.builder(
                                                        shrinkWrap: true,
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 3,
                                                          crossAxisSpacing: 10,
                                                          mainAxisSpacing: 10,
                                                        ),
                                                        itemCount:
                                                            settingsTapCubit
                                                                .avatarImages
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final imagePath =
                                                              settingsTapCubit
                                                                      .avatarImages[
                                                                  index];
                                                          return InkWell(
                                                            onTap: () {
                                                              settingsTapCubit
                                                                  .putEditAvatar(
                                                                      imagePath);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: CircleAvatar(
                                                              backgroundImage:
                                                                  AssetImage(
                                                                      imagePath),
                                                              backgroundColor:
                                                                  AppColors
                                                                      .lightColor,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .15,
                                            backgroundColor:
                                                AppColors.lightColor,
                                            backgroundImage: AssetImage(
                                              settingsTapCubit
                                                      .userData?.userAvatar ??
                                                  'assets/img/ninja1.png',
                                            ),
                                          ),
                                          const Icon(
                                            Icons.camera_alt,
                                            size: 40,
                                            color: AppColors.lightColor,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              shape: BoxShape.circle,
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .3,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .3,
                                          ),
                                        ],
                                      )),
                                ),
                                const SizedBox(height: 20.0),
                                Text(S.of(context).fristName,
                                    style: const TextStyle(
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.bold)),
                                TextFormField(
                                  controller:
                                      settingsTapCubit.firstNameController,
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: S
                                        .of(context)
                                        .enterLabel(S.of(context).fristName),
                                    hintStyle: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.6),
                                    ),
                                    filled: true,
                                    fillColor: AppColors.lightColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return S
                                          .of(context)
                                          .enterLabel(S.of(context).fristName);
                                    }
                                    if (value.length < 2) {
                                      return  S
                                        .of(context)
                                        .validFristName;
                                    }
                                    return null; // Valid input
                                  },
                                ),
                                const SizedBox(height: 20.0),
                                Text(S.of(context).lastName,
                                    style: const TextStyle(
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.bold)),
                                TextFormField(
                                  controller:
                                      settingsTapCubit.lastNameController,
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText:  S
                                        .of(context)
                                        .enterLabel(S.of(context).lastName),
                                    hintStyle: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.6),
                                    ),
                                    filled: true,
                                    fillColor: AppColors.lightColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return  S
                                        .of(context)
                                        .enterLabel(S.of(context).lastName);
                                    }
                                    if (value.length < 2) {
                                      return  S
                                        .of(context)
                                      .validLastName;
                                    }

                                    return null; // Valid input
                                  },
                                ),
                                const SizedBox(height: 20.0),
                                Text(S.of(context).userName,
                                    style: const TextStyle(
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.bold)),
                                TextFormField(
                                  controller:
                                      settingsTapCubit.userNameController,
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText:  S
                                        .of(context)
                                        .enterLabel(S.of(context).userName),
                                    hintStyle: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.6),
                                    ),
                                    filled: true,
                                    fillColor: AppColors.lightColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return  S
                                        .of(context)
                                        .enterLabel(S.of(context).userName);
                                    }
                                    if (value.length < 3) {
                                      return  S.of(context).minUserName;
                                    }
                                    if (value.length > 20) {
                                      return S.of(context).maxUserName;
                                    }

                                    return null; // Valid input
                                  },
                                ),
                                const SizedBox(height: 20.0),
                                Text(S.of(context).phoneNumber,
                                    style: const TextStyle(
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.bold)),
                                TextFormField(
                                  onFieldSubmitted: (_) {
                                    log(settingsTapCubit
                                        .phoneNumberController.text);
                                  },
                                  controller:
                                      settingsTapCubit.phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: settingsTapCubit
                                            .userData?.userPhoneNumber ??
                                        "",
                                    hintStyle: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.6),
                                    ),
                                    filled: true,
                                    fillColor: AppColors.lightColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return S.of(context).enterPhoneNumber;
                                    }
                                    if (!RegExp(r'^\+?[0-9]+$')
                                        .hasMatch(value)) {
                                      return S.of(context).validPhoneNumber;
                                    }
                                    return null; // Valid input
                                  },
                                ),
                                const SizedBox(height: 20.0),
                                Text(S.of(context).email,
                                    style: const TextStyle(
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.bold)),
                                TextFormField(
                                  controller: settingsTapCubit.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  readOnly: true,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText:
                                        settingsTapCubit.userData?.userEmail,
                                    hintStyle: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.6),
                                    ),
                                    filled: true,
                                    fillColor: AppColors.lightColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EditPasswordPage()),
                                );
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
                                  S.of(context).changePassword,
                                  style: const TextStyle(
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          state is PutEditProfileLoading
                              ? const Center(
                                  child:CircularProgressIndicator(
                                    color: AppColors.mainColor,
                                  )
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        bool result = await settingsTapCubit
                                            .putEditProfile(
                                          settingsTapCubit
                                              .firstNameController.text,
                                          settingsTapCubit
                                              .lastNameController.text,
                                          settingsTapCubit
                                              .userNameController.text,
                                          settingsTapCubit
                                              .phoneNumberController.text,
                                        );
                                        if (result) {
                                          showSuccessDialog(
                                            context,
                                            title: 'Success',
                                            desc: 'Profile updated successfully!',
                                            onOkPressed: () {},
                                          );
                                        } else {
                                          showErrorDialog(
                                            context,
                                            title: 'Error',
                                            desc: 'Failed to update profile. Please try again.',
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
          ),
        );
      },
    );
  }
}
