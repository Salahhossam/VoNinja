import 'package:vo_ninja/models/user_data_model.dart';

abstract class SettingsTapState {}

class SettingsTapLoading extends SettingsTapState {}

class SettingsTapLoaded extends SettingsTapState {
  final UserDataModel userData;
  final String language;
  final double points;

  SettingsTapLoaded(this.userData, this.language, this.points);
}

class SettingsTapPasswordVisibilityChanged extends SettingsTapState {
  final bool isCurrentPasswordVisible;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;

  SettingsTapPasswordVisibilityChanged(this.isCurrentPasswordVisible,
      this.isNewPasswordVisible, this.isConfirmPasswordVisible);
}

class SettingsTapSuccess extends SettingsTapState {
  final String message;

  SettingsTapSuccess(this.message);
}

class SettingsTapFailure extends SettingsTapState {
  final String errorMessage;
  SettingsTapFailure(this.errorMessage);
}

class SettingsTapError extends SettingsTapState {
  final String error;

  SettingsTapError(this.error);
}

class SettingsTapLanguageChanged extends SettingsTapState {
  final String language;

  SettingsTapLanguageChanged(this.language);
}

class SettingsTapGetAppInfo extends SettingsTapState {}

class SettingsTapPostTransactionsPhoneNumberLoading extends SettingsTapState {}
class SettingsTapPostTransactionsPhoneNumberSuccess extends SettingsTapState {}

class SettingsTapGetAllTransactionLoading extends SettingsTapState {}
class SettingsTapGetAllTransactionSuccess extends SettingsTapState {}
class SettingsTapGetAllTransactionError extends SettingsTapState {
  final String error;
  SettingsTapGetAllTransactionError(this.error);
}


class PostRewardCodeLoading extends SettingsTapState {}
class PostRewardCodeSuccess extends SettingsTapState {}
class PostRewardCodeError extends SettingsTapState {
  final String error;
  PostRewardCodeError(this.error);
}


class PostReferralsFriendLinkLoading extends SettingsTapState {}
class PostReferralsFriendLinkSuccess extends SettingsTapState {}
class PostReferralsFriendLinkError extends SettingsTapState {
  final String error;
  PostReferralsFriendLinkError(this.error);
}

class PutEditProfileLoading extends SettingsTapState {}
class PutEditPasswordLoading extends SettingsTapState {}