import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:vo_ninja/modules/taps_page/taps_page.dart';
import 'package:vo_ninja/shared/constant/constant.dart';
import '../../../shared/network/local/cash_helper.dart';
import 'login_state.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) {
    return BlocProvider.of(context);
  }

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailOrUserNameController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  DateTime? lastBackPressTime = DateTime.now();

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(LoginPasswordVisibilityChanged(_isPasswordVisible));
  }

  void toggleRememberMe(bool value) {
    _rememberMe = value;
    emit(LoginRememberMeChanged(_rememberMe));
  }

  Future<void> login(
      context, String emailOrUserName, String password, String fcmToken) async {
    emit(LoginLoading());
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(
              email: emailOrUserName, password: password)
          .then((UserCredential userCredential) async {
        String uid = userCredential.user!.uid;

          if (_rememberMe) {
            await CashHelper.saveData(key: 'userToken', value: fcmToken);
          }
          await CashHelper.saveData(key: 'uid', value: uid);
          await fireStore
              .collection(USERS)
              .doc(uid)
              .update({'fcmToken': fcmToken});
          await requestPermission();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const TapsPage()),
          );
          emit(LoginSuccess());

      });
    } catch (e) {
      emit(LoginFailure("Wrong email or UserName or password"));
    }
  }

  Future<void> forgotPassword(String emailOrUserName, context) async {
    emit(ForgotPasswordLoading());
    try {
      await firebaseAuth
          .sendPasswordResetEmail(email: emailOrUserName)
          .then((value) {
        emit(ForgotPasswordSuccess());
      });
    } catch (e) {
      emit(ForgotPasswordFailure("Failed to send email. Check your network."));
    }
  }


bool doubleBack(BuildContext context) {
  DateTime now = DateTime.now();
  if (lastBackPressTime == null ||
      now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
    lastBackPressTime = now;
    showToast(
      'Press again to exit',
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: const StyledToastPosition(
        align: Alignment.bottomCenter,
        offset: 40,
      ),
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 3),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
    return false;
  }

  if (Platform.isAndroid) {
    SystemNavigator.pop();
  } else if (Platform.isIOS) {
    exit(0);
  }

  return true;
}

}

Future<void> requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    log('User granted permission');
  } else {
    log('User declined or has not accepted permission');
  }
}

Future<String?> getFcmToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  try {
    String? fcmToken = await messaging.getToken();
    log("FCM Token: $fcmToken");
    return fcmToken;
  } catch (e) {
    log("Error getting FCM token: $e");
  }
  return null;
}
