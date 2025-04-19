
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/modules/login_page/login_page.dart';
import '../../../models/user_data_model.dart';
import '../../../shared/constant/constant.dart';
import 'singup_state.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class SingupCubit extends Cubit<SingupState> {
  SingupCubit() : super(SingupInitial());
  static SingupCubit get(context) {
    return BlocProvider.of(context);
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController fristNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void toggleNewPasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(SingupPasswordVisibilityChanged(
      isPasswordVisible,
      isConfirmPasswordVisible,
    ));
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(SingupPasswordVisibilityChanged(
      isPasswordVisible,
      isConfirmPasswordVisible,
    ));
  }


  Future<void> singup(
      context,
      String firstName,
      String lastName,
      String userName,
      String phoneNumber,
      String email,
      String password) async {
    emit(SingupLoading());

    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await userCreate(
          email: email,
          firstName: firstName,
          lastName: lastName,
          uId: userCredential.user!.uid,
          userName: userName,
          phone: phoneNumber
      );
      emit(SingupSuccess());
      emailController.clear();
      passwordController.clear();
      userNameController.clear();
      phoneNumberController.clear();
      fristNameController.clear();
      lastNameController.clear();
      confirmPasswordController.clear();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      showToast(
        'Email Created',
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        position: const StyledToastPosition(
            offset: 140, align: Alignment.bottomCenter),
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );

    } catch (error) {
      String errorMessage;
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'email-already-in-use':
            errorMessage = 'The email address is already in use by another account.';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many attempts. Please try again later.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          default:
            errorMessage = 'An unexpected error occurred. Please try again later.';
        }
      } else {
        errorMessage = 'An unexpected error occurred. Please try again later.';
      }
      showToast(
        errorMessage,
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        position: const StyledToastPosition(
            offset: 140, align: Alignment.bottomCenter),
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );


      emit(SingupFailure(error.toString()));
    }
  }


  Future<void> userCreate({
    required String email,
    required String firstName,
    required String lastName,
    required String userName,
    required String phone,
    required String uId,
  }) async {
    try {
      UserDataModel userModel = UserDataModel(
        userId: uId,
        firstName: firstName,
        lastName: lastName,
        userName: userName,
        userPhoneNumber: phone,
        userEmail: email,
        userAvatar: 'assets/img/ninja1.png',
      );

      await fireStore.collection(USERS).doc(uId).set(userModel.toJson());
    } catch (error) {
      emit(RegisterCreateUserError(error.toString()));
    }
  }

}
