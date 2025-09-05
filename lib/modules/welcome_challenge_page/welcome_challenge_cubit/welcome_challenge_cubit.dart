

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ntp/ntp.dart';
import 'package:vo_ninja/modules/welcome_challenge_page/welcome_challenge_cubit/welcome_challenge_state.dart';
import 'package:vo_ninja/shared/constant/constant.dart';

import '../../../generated/l10n.dart';
import '../../../models/lesson_details_model.dart';
import '../../../shared/network/local/cash_helper.dart';
import '../../taps_page/taps_page.dart';

class WelcomeChallengeCubit extends Cubit<WelcomeChallengeState> {
  WelcomeChallengeCubit() : super(InitialWelcomeChallengeState());

  static WelcomeChallengeCubit get(context) {
    return BlocProvider.of(context);
  }

  Future<void> seedQuizQuestionsWithAdd(
      {int total = 10}) async
  {

    try {

      final colRef = fireStore.collection('welcomeChallenge').doc().collection('questions');

      for (int i = 1; i <= total; i++) {
        // add يديك ref فيه ال id الجديد
        final docRef = await colRef.add({
          'content': 'سؤال رقم $i: ما هي الإجابة الصحيحة؟',
          'choices': ['اختيار A', 'اختيار B', 'اختيار C', 'اختيار D'],
          'correct_answer': [
            'اختيار A',
            'اختيار B',
            'اختيار C',
            'اختيار D'
          ][i % 4],
          'image_url': null,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // تحديث الحقل id عشان يتوافق مع كلاسّك
        await docRef.update({'id': docRef.id});
      }



    } catch (e) {}
  }


  int currentQuestionIndex = 0;
  List<Question> questions= [];
  Future<void> getWelcomeChallengeDetailsData(String uid,) async {
    emit(GetWelcomeChallengeDetailsDataLoading());
    try {
      questions= [] ;
      var data = await fireStore
          .collection('welcomeChallenge')
          .doc('fM4rPSWsMWEhvRyW6BCE')
          .collection('questions')
          .get();
      questions =
          data.docs.map((doc) => Question.fromJson(doc.data())).toList();
      emit(GetWelcomeChallengeDetailsDataSuccess());
    } catch (error) {
      // print('Error fetching lesson details: $error');
      emit(GetWelcomeChallengeDetailsDataError(error.toString()));
    }
  }

  List<Map<String, dynamic>> previousAnswers = [];



  final FlutterTts flutterTts = FlutterTts();
  bool isEnglish = true;
  void toggleLanguage() {
    isEnglish = !isEnglish;
    emit(WelcomeChallengeUpdated());
  }

  Future<void> speak(String text, String language) async {
    await flutterTts.setLanguage(language);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  int? selectedOption;
  void selectOption(int index) {
    selectedOption = index;
    emit(WelcomeChallengeUpdated());
  }


  bool isAnswered = false;
  void moveToPastQuestion(
      context,
      ) {
    if (currentQuestionIndex != 0) {
      currentQuestionIndex--;
      selectedOption = null;
      isAnswered = false;
      emit(WelcomeChallengeUpdated());
    }
  }


  void moveToNextQuestion(context,) {
    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      selectedOption = null;
      isAnswered = false;
      emit(WelcomeChallengeUpdated());
    } else {

    }
  }







  // في WelcomeChallengeCubit
  DateTime? challengeStart;     // وقت بدء التحدي
  DateTime? deadline;           // وقت الانتهاء (start + 5 دقائق)
  final Duration totalDuration = const Duration(minutes: 5);

  int get answeredCount => previousAnswers.length;
  int get correctCount =>
      previousAnswers.where((a) => (a["correct"] == true)).length;

  bool get allAnswered => questions.isNotEmpty && answeredCount == questions.length;
  bool get allCorrect  => allAnswered && correctCount == questions.length;

  Future<void> startChallengeUsingNtp() async {
    // استخدم NTP لو متاح عندك داخل الكيوبت، أو مرّره من شاشة المقدمة
    final ntpNow = await NTP.now();
    challengeStart = ntpNow;
    deadline = challengeStart!.add(totalDuration);
    currentQuestionIndex = 0;
    selectedOption = null;
    previousAnswers.clear();
    emit(WelcomeChallengeUpdated());
  }

  bool isLoading3=false;

  Future<void> onFinishChallenge(BuildContext context) async {
    isLoading3 = true;
    try {
      final now = DateTime.now();
      final finishedWithinTime =
      (deadline != null) ? now.isBefore(deadline!) : false;

      final win = allCorrect && finishedWithinTime;

      if (win) {
        final uid = await CashHelper.getData(key: 'uid');
        await fireStore
            .collection('users')
            .doc(uid)
            .set({'pointsNumber': FieldValue.increment(500)}, SetOptions(merge: true));
      }

      await AwesomeDialog(
        context: context,
        dialogType: win ? DialogType.success : DialogType.infoReverse,
        animType: AnimType.scale,
        title: win
            ? S.of(context).final_congrats_title
            : S.of(context).final_tryAgain_title,
        desc: win
            ? S.of(context).final_congrats_desc(
          WelcomeChallengeCubit.get(context).totalDuration.inMinutes,
        )
            : (finishedWithinTime
            ? S.of(context).final_tryAgain_desc_inTimeWrong
            : S.of(context).final_tryAgain_desc_timeOver),
        btnOkText: S.of(context).final_ok,
        btnOkOnPress: () {},
      ).show();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const TapsPage()),
            (route) => false,
      );

      // اعرض الـ dialog هنا (هنجهزه في الصفحة)
      // فقط نبعت إشعار للواجهة إنها تخلص وتعرض الـ dialog
      emit(WelcomeChallengeFinished());
    } catch (e, st) {
      debugPrint('❌ Error in onFinishChallenge: $e\n$st');
      // ممكن كمان تعرض Dialog خطأ لو حابب
    } finally {
      isLoading3 = false;
    }
  }


}

