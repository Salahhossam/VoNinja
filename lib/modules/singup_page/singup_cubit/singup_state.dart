abstract class SingupState {}

class SingupInitial extends SingupState {}

class SingupLoading extends SingupState {}

class SingupPasswordVisibilityChanged extends SingupState {
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  SingupPasswordVisibilityChanged(
      this.isPasswordVisible, this.isConfirmPasswordVisible);
}

class SingupSuccess extends SingupState {}

class SingupFailure extends SingupState {
  final String errorMessage;
  SingupFailure(this.errorMessage);
}


class RegisterCreateUserError extends SingupState {
  final String errorMessage;
  RegisterCreateUserError(this.errorMessage);
}
