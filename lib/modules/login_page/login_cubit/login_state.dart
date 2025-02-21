abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginPasswordVisibilityChanged extends LoginState {
  final bool isVisible;
  LoginPasswordVisibilityChanged(this.isVisible);
}

class LoginRememberMeChanged extends LoginState {
  final bool rememberMe;
  LoginRememberMeChanged(this.rememberMe);
}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String errorMessage;
  LoginFailure(this.errorMessage);
}

class ForgotPasswordLoading extends LoginState {}

class ForgotPasswordSuccess extends LoginState {}

class ForgotPasswordFailure extends LoginState {
  final String message;
  ForgotPasswordFailure(this.message);
}
