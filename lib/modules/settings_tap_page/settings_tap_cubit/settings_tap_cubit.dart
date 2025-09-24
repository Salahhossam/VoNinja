
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vo_ninja/models/transaction.dart';
import 'package:vo_ninja/models/user_data_model.dart';

import '../../../generated/l10n.dart';
import '../../../shared/companent.dart';
import '../../../shared/constant/constant.dart';
import '../../../shared/style/color.dart';
import 'settings_tap_state.dart';

class SettingsTapCubit extends Cubit<SettingsTapState> {
  SettingsTapCubit() : super(SettingsTapLoading());

  static SettingsTapCubit get(context) => BlocProvider.of(context);

  final TextEditingController rewardCodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController pointNumberController = TextEditingController();
  final TextEditingController cashNumberController = TextEditingController();
  final TextEditingController friendLinkController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String selectedLanguage = 'English';
  UserDataModel? userData;
  double? points;
  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<String> avatarImages = [
    'assets/img/f_ninja1.png',
    'assets/img/f_ninja2.png',
    'assets/img/f_ninja3.png',
    'assets/img/f_ninja4.png',
    'assets/img/ninja1.png',
    'assets/img/ninja2.png',
    'assets/img/ninja3.png',
    'assets/img/avatar.png',
    'assets/img/avatar2.png',
    'assets/img/avatar3.png',
    'assets/img/avatar4.png',
    'assets/img/avatar5.png',
    'assets/img/avatar6.png',
    'assets/img/avatar7.png',
  ];
  Future<bool> putEditAvatar(String newAvatar) async {
    try {
      emit(PutEditProfileLoading());
      await fireStore.collection('users').doc(userData?.userId).update({
        'userAvatar': newAvatar,
      });
      userData?.userAvatar = newAvatar;

      emit(SettingsTapSuccess("Avatar changed successfully!"));
      return true;
    } catch (e) {
      emit(SettingsTapError("Network error: ${e.toString()}"));
      return false;
    }
  }

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible = !isCurrentPasswordVisible;
    emit(SettingsTapPasswordVisibilityChanged(
      isCurrentPasswordVisible,
      isNewPasswordVisible,
      isConfirmPasswordVisible,
    ));
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible = !isNewPasswordVisible;
    emit(SettingsTapPasswordVisibilityChanged(
      isCurrentPasswordVisible,
      isNewPasswordVisible,
      isConfirmPasswordVisible,
    ));
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(SettingsTapPasswordVisibilityChanged(
      isCurrentPasswordVisible,
      isNewPasswordVisible,
      isConfirmPasswordVisible,
    ));
  }

  Future<void> getUserData(String uid) async {
    emit(SettingsTapLoading());
    try {
      var response = await fireStore.collection(USERS).doc(uid).get();
      userData =
          UserDataModel.fromJson(response.data() as Map<String, dynamic>);
      emit(SettingsTapLoaded(userData!, selectedLanguage, points!));
    } catch (error) {
      emit(SettingsTapError(error.toString()));
    }
  }

  String appVersion = 'v1.0.0';

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    emit(SettingsTapGetAppInfo());
  }

  double pointPrice = 0;

  Future<void> getPointPrice() async {
    try {
      var docSnapshot =
          await fireStore.collection('utils').doc('8pjrhA3sgjHkZcCSV0Iv').get();
      if (docSnapshot.exists) {
        var data = docSnapshot.data();
        if (data != null && data.containsKey('pointPrice')) {
          pointPrice = (data['pointPrice'] as num).toDouble();
        }
      }
      emit(SettingsTapGetAppInfo());
    } catch (e) {
      // print('Error fetching pointPrice: $e');
    }
  }

  Future<String> postRewardCode(String rewardCode, String uid) async {
    try {
      emit(PostRewardCodeLoading());
      DateTime now = await NTP.now();
      var query = await fireStore.collection('coupons').doc(rewardCode).get();
      if (query.exists) {
        var query2 = await fireStore
            .collection('coupons')
            .doc(rewardCode)
            .collection('users')
            .doc(uid)
            .get();
        if (query2.exists) {
          emit(PostRewardCodeSuccess());
          return 'You already used this coupon before';
        } else {
          if (now.isAfter(query['expireDate'].toDate())) {
            emit(PostRewardCodeSuccess());
            return 'this coupon is expired';
          } else {
            await fireStore
                .collection('coupons')
                .doc(rewardCode)
                .collection('users')
                .doc(uid)
                .set({'id': uid});
            var user = await fireStore.collection('users').doc(uid).get();
            await fireStore.collection('users').doc(uid).update(
                {'pointsNumber': query['points'] + user['pointsNumber']});
            emit(PostRewardCodeSuccess());
            return 'Success';
          }
        }
      } else {
        emit(PostRewardCodeSuccess());
        return 'This is invalid coupon';
      }
    } catch (e) {
      emit(PostRewardCodeError(e.toString()));
      return 'This is invalid coupon';
    }
  }

  Future<bool> postTransactionsPhoneNumber(double points,
      String contactPhoneNumber, String uid, double price) async {
    try {
      emit(SettingsTapPostTransactionsPhoneNumberLoading());
      await fireStore
          .collection('users')
          .doc(uid)
          .update({'pointsNumber': (userData?.pointsNumber ?? 0) - points});
      var data = fireStore.collection('transaction').doc();
      TransactionDto transactionDto = TransactionDto(
          id: data.id,
          userId: uid,
          price: price,
          contactPhoneNumber: contactPhoneNumber,
          points: points);
      await data.set(transactionDto.toJson());
      userData?.pointsNumber = (userData?.pointsNumber ?? 0) - points;

      emit(SettingsTapPostTransactionsPhoneNumberSuccess());
      return true;
    } catch (e) {
      emit(SettingsTapError("Network error: ${e.toString()}"));
      return false;
    }
  }

  Future<String> postReferralsFriendLink(String referralsFriendLink) async {
    try {
      emit(PostReferralsFriendLinkLoading());
      if (referralsFriendLink == userData?.userId) {
        emit(PostReferralsFriendLinkSuccess());
        return 'This is invalid referrals friend link';
      }
      var query =
          await fireStore.collection('users').doc(referralsFriendLink).get();
      if (query.exists) {
        if (query['isReferred']) {
          emit(PostReferralsFriendLinkSuccess());
          return 'This is  referred previously by another one';
        } else {
          var user =
              await fireStore.collection('users').doc(userData?.userId).get();
          var query2 = await fireStore
              .collection('utils')
              .doc('7k5zIILglLHCl5HzbTkv')
              .get();
          await fireStore.collection('users').doc(userData?.userId).update({
            'pointsNumber': query2['pointsFromInvited'] + user['pointsNumber']
          });

          await fireStore.collection('users').doc(referralsFriendLink).update({
            'pointsNumber': query2['pointsFromInvited'] + query['pointsNumber']
          });
          await fireStore
              .collection('users')
              .doc(referralsFriendLink)
              .update({'isReferred': true});
          userData?.pointsNumber =
              (userData?.pointsNumber ?? 0) + query2['pointsFromInvited'];
          emit(PostReferralsFriendLinkSuccess());
          return 'Success';
        }
      } else {
        emit(PostReferralsFriendLinkSuccess());
        return 'This is invalid referrals friend link';
      }
    } catch (e) {
      emit(PostReferralsFriendLinkError(e.toString()));
      return 'This is invalid referrals friend link';
    }
  }

  Future<bool> putEditProfile(String firstName, String lastName,
      String username, String phoneNumber) async {
    try {
      emit(PutEditProfileLoading());
      await fireStore.collection('users').doc(userData?.userId).update({
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'userNameLowerCase': username.toLowerCase(),
        'phoneNumber': phoneNumber
      });
      userData?.firstName = firstName;
      userData?.lastName = lastName;
      userData?.userName = username;
      userData?.userNameLowerCase = username.toLowerCase();
      userData?.userPhoneNumber = phoneNumber;
      emit(SettingsTapSuccess("Password changed successfully!"));
      return true;
    } catch (e) {
      emit(SettingsTapError("Network error: ${e.toString()}"));
      return false;
    }
  }

  Future<bool> putEditPassword(
      String currentPassword, String newPassword) async {
    try {
      emit(PutEditPasswordLoading());

      // Get the current user
      User? user = firebaseAuth.currentUser;

      if (user != null && user.email != null) {
        // Create a credential with the current password
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        // Re-authenticate the user
        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(newPassword);

        emit(SettingsTapSuccess("Password changed successfully!"));
        return true;
      } else {
        emit(SettingsTapError("User not found or not logged in."));
        return false;
      }
    } catch (e) {
      emit(SettingsTapError("Error changing password: ${e.toString()}"));
      return false;
    }
  }

  Future<void> fetchSettings() async {
    try {
      emit(SettingsTapLoading());

      userData = UserDataModel(
        userName: "salahhossam",
        userBalance: 100,
        userAvatar: 'assets/img/f_ninja3.png',
        pointsNumber: 1000,
        versionNumber: 'v1.0.0',
        userEmail: 'salahhossam@yahoo.com',
        userPhoneNumber: '01129598913',
      );
      emit(SettingsTapLoaded(userData!, selectedLanguage, points!));
    } catch (e) {
      emit(SettingsTapError('Failed to load data'));
    }
  }

  void changeLanguage(String language) {
    selectedLanguage = language;
    // Notify listeners about the language change
    emit(SettingsTapLanguageChanged(language));
  }

//  void changeLanguage(String language) {
//     selectedLanguage = language;
//     if (userData != null) {
//       emit(SettingsTapLoaded(userData!, selectedLanguage));
//     } else {
//       emit(SettingsTapError('User data not loaded'));
//     }
//   }
  void showInviteFriendDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
          insetPadding: const EdgeInsets.all(20),
          content: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondColor.withOpacity(1),
                  spreadRadius: 3,
                  blurRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      S.of(context).inviteFriend,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.secondColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${userData!.referLink}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: "${userData!.referLink}"));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Copied to clipboard")),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: friendLinkController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: S.of(context).enterFriendLink,
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
                const SizedBox(height: 16),
                BlocConsumer<SettingsTapCubit, SettingsTapState>(
                    listener: (BuildContext context, SettingsTapState state) {},
                    builder: (BuildContext context, SettingsTapState state) {
                      return state is PostReferralsFriendLinkLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                ),
                                onPressed: () async {
                                  var result = await postReferralsFriendLink(
                                      friendLinkController.text);
                                  if (result == 'Success') {
                                    showSuccessDialog(
                                      context,
                                      title: 'Success',
                                      desc: 'Transaction completed successfully!',
                                      onOkPressed: () {},
                                    );
                                  } else {
                                    showErrorDialog(
                                      context,
                                      title: 'Error',
                                      desc: result,
                                      onOkPressed: () {},
                                    );
                                  }
                                },
                                child: Text(
                                  S.of(context).getPoints,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  List<TransactionDto> transactions = [];

  Future<void> getAllTransaction(String uid) async {
    try {
      emit(SettingsTapGetAllTransactionLoading());
      transactions.clear(); // Better than reassigning a new list

      var data = await fireStore
          .collection('transaction')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      for (var doc in data.docs) {
        // Use data.docs to iterate correctly
        transactions.add(TransactionDto.fromJson(doc.data()));
      }

      emit(SettingsTapGetAllTransactionSuccess());
    } catch (e) {
      emit(SettingsTapGetAllTransactionError(e.toString()));
    }
  }
}
