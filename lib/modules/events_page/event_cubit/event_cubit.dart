import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vo_ninja/modules/events_page/events_page.dart';

import '../../../models/event_model.dart';
import '../../../models/lesson_details_model.dart';
import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(InitialEventState());

  static EventCubit get(context) {
    return BlocProvider.of(context);
  }

  static const _placeholderImg = 'https://picsum.photos/800/400?random=';
  final fs = FirebaseFirestore.instance;

  /// شغلها مرة واحدة لرفع بيانات تجريبية
  Future<void> seedDummyEvents() async {
    emit(SeedDummyEventsLoading());

    try {
      final now = DateTime.now();

      // 1) Welcome Template (لا يحتوي start/end عامين؛ نافذته لكل مستخدم تُحسب من installAt)
      await fs.collection('events').add({
        'type': 'welcome',
        'title': 'Welcome Challenge',
        'description':
        'اجمع 1000 نقطة خلال 48 ساعة من تثبيت التطبيق واحصل على 3000 نقطة.',
        'imageUrl': '${_placeholderImg}1',
        'rules': {
          'welcomeGoal': 1000,
          'welcomeReward': 3000,
        },
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2) Multiplier (مضاعفة النقاط): يبدأ الآن وينتهي بعد 5 أيام
      final multiplierStart =
      now.add(const Duration(hours: 1)); // يبدأ بعد ساعة (لتجربة "Starts in")
      final multiplierEnd = now.add(const Duration(days: 5));
      final multiplierRef = await fs.collection('events').add({
        'type': 'multiplier',
        'title': 'Double Points Weekend',
        'description': 'كل نقطة هتتقلب ×2 خلال فترة العرض.',
        'imageUrl': '${_placeholderImg}2',
        'startAt': Timestamp.fromDate(multiplierStart),
        'endAt': Timestamp.fromDate(multiplierEnd),
        'rules': {
          'multiplier': 2.0,
        },
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3) Target Points: هدف 5000 نقطة خلال 7 أيام + مكافأة 1500
      final targetStart = now; // يبدأ فوراً
      final targetEnd = now.add(const Duration(days: 7));
      await fs.collection('events').add({
        'type': 'target_points',
        'title': 'Reach 5,000 Points',
        'description': 'اجمع 5000 نقطة خلال أسبوع لتحصل على مكافأة 1500 نقطة.',
        'imageUrl': '${_placeholderImg}3',
        'startAt': Timestamp.fromDate(targetStart),
        'endAt': Timestamp.fromDate(targetEnd),
        'rules': {
          'targetGoal': 5000,
          'targetReward': 1500,
        },
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 4) Quiz Event: 100 سؤال، مطلوب 90 صح، مكافأة 2000 — يبدأ غداً وينتهي بعد 10 أيام
      final quizStart = now.add(const Duration(days: 1));
      final quizEnd = now.add(const Duration(days: 10));
      final quizRef = await fs.collection('events').add({
        'type': 'quiz',
        'title': 'General Knowledge Marathon',
        'description':
        'أجب عن كل الأسئلة والصح المطلوب 90/100 لتحصل على 2000 نقطة.',
        'imageUrl': '${_placeholderImg}4',
        'startAt': Timestamp.fromDate(quizStart),
        'endAt': Timestamp.fromDate(quizEnd),
        'rules': {
          'quizTotal': 10,
          'quizMinCorrect': 5,
          'quizReward': 2000,
        },
        'createdAt': FieldValue.serverTimestamp(),
      });

      // رفع أسئلة تجريبية للكويز (10 كفاية كعينة — كررها/ولّدها حتى 100 لو حابب)
      await seedQuizQuestionsWithAdd(quizRef.id, total: 10);

      // 5) مثال لإيفنت "قريب" يبدأ بعد 3 ساعات (لإظهار "Starts in")
      final upcomingStart = now.add(const Duration(hours: 3));
      final upcomingEnd = now.add(const Duration(days: 3));
      await fs.collection('events').add({
        'type': 'target_points',
        'title': 'Sprint 2000',
        'description': 'اجمع 2000 نقطة خلال 3 أيام لتحصل على 800 نقطة.',
        'imageUrl': '${_placeholderImg}5',
        'startAt': Timestamp.fromDate(upcomingStart),
        'endAt': Timestamp.fromDate(upcomingEnd),
        'rules': {
          'targetGoal': 2000,
          'targetReward': 800,
        },
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(SeedDummyEventsSuccess());

    } catch (e) {
      emit(SeedDummyEventsError('فشل في إضافة البيانات التجريبية: ${e.toString()}'));
    }
  }

  /// يضيف أسئلة تجريبية لحدث الكويز
  Future<void> seedQuizQuestionsWithAdd(String eventId,
      {int total = 10}) async {
    emit(SeedQuizQuestionsLoading());

    try {
      final fs = FirebaseFirestore.instance;
      final colRef = fs.collection('events').doc(eventId).collection('questions');

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

      emit(SeedQuizQuestionsSuccess());

    } catch (e) {
      emit(SeedQuizQuestionsError('فشل في إضافة أسئلة الكويز: ${e.toString()}'));
    }
  }

  /// (اختياري) مسح كل الداتا التجريبية — استخدمها بحذر
  Future<void> clearAllEventsAndQuestions() async {
    emit(ClearEventsLoading());

    try {
      final eventsSnap = await fs.collection('events').get();
      for (final e in eventsSnap.docs) {
        final qSnap = await e.reference.collection('questions').get();
        for (final q in qSnap.docs) {
          await q.reference.delete();
        }
        await e.reference.delete();
      }

      emit(ClearEventsSuccess());

    } catch (e) {
      emit(ClearEventsError('فشل في حذف الأحداث والأسئلة: ${e.toString()}'));
    }
  }



  /// يجلب كل الإيفنتات التي لم تنتهِ بعد (أو upcoming)، مرتبة بالأقرب انتهاءً
  ///
  List<AppEvent> events=[];
  Future<void> fetchActiveAndUpcomingEvents(DateTime now) async {
    emit(FetchEventsLoading());

    try {
      events = []; // جعل events null في البداية

      final snap = await fs.collection('events').get();
      final list = snap.docs.map((d) => AppEvent.fromDoc(d)).toList();

      // فلترة: not ended بالنسبة لجميع الأنواع
      final filtered = list.where((e) {
        if (e.type == EventType.welcome) {
          return true;
        }
        if (e.endAt == null) return false;
        return now.isBefore(e.endAt!);
      }).toList();

      filtered.sort((a, b) {
        final aEnd = a.order ?? 0;
        final bEnd = b.order ?? 0;
        return aEnd.compareTo(bEnd);
      });

      events = filtered; // حفظ النتيجة في المتغير
      emit(FetchEventsSuccess());
    } catch (e) {
      emit(FetchEventsError('فشل في جلب الأحداث: ${e.toString()}'));
    }
  }

  /// يضمن وجود وثيقة user_events للـ welcome للمستخدم (لو مش موجودة)


  Future<void> ensureWelcomeForUser({
    required String uid,
    required AppEvent welcomeTemplate,
    required DateTime installAt,
  }) async {
    emit(EnsureWelcomeLoading());

    try {
      final ueRef = fs
          .collection('users')
          .doc(uid)
          .collection('user_events')
          .doc(welcomeTemplate.id);

      final ueSnap = await ueRef.get();
      if (ueSnap.exists) {
        emit(EnsureWelcomeSuccess());
        return;
      }
      final userStart = installAt;
      final userEnd = installAt.add(const Duration(hours: 48));
      final reward = (welcomeTemplate.rules['welcomeReward'] ?? 3000) as int;

      await ueRef.set({
        'eventType': 'welcome',
        'status': 'in_progress',
        'userStartAt': Timestamp.fromDate(userStart),
        'userEndAt': Timestamp.fromDate(userEnd),
        'progress': {
          'pointsAccumulated': 0,
          'correctAnswers': 0,
        },
        'rewardPoints': reward,
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(EnsureWelcomeSuccess());

    } catch (e) {
      emit(EnsureWelcomeError('فشل في تهيئة حدث الترحيب: ${e.toString()}'));
    }
  }


  /// جلب تقدم المستخدم لكل الإيفنتات مرة واحدة (خريطة eventId -> progress)
  Map<String, UserEventProgress>? userEventsProgress;

  Future<void> fetchUserEventsProgress(String uid) async {
    emit(FetchUserEventsProgressLoading());

    try {
      final q = await fs.collection('users').doc(uid).collection('user_events').get();
      final map = <String, UserEventProgress>{};
      for (final d in q.docs) {
        map[d.id] = UserEventProgress.fromDoc(d);
      }

      userEventsProgress = map;
      emit(FetchUserEventsProgressSuccess());

    } catch (e) {
      emit(FetchUserEventsProgressError('فشل في جلب تقدم أحداث المستخدم: ${e.toString()}'));
    }
  }

  /// Join: ينشئ user_events لو مش موجود + يضبط الحالة in_progress
  Future<void> joinEvent(String uid, AppEvent event,) async {
    emit(JoinEventLoading());

    try {
      final ueRef =
      fs.collection('users').doc(uid).collection('user_events').doc(event.id);

      // للأحداث العامة
      final data = {
        'eventType': _toStringType(event.type),
        'status': 'in_progress',
        'progress': {
          'pointsAccumulated': 0,
          'correctAnswers': 0,
          'answerCount':0,
        },
        'rewardPoints': _defaultRewardFor(event),
        'createdAt': FieldValue.serverTimestamp(),
        'lastUpdatedAt': FieldValue.serverTimestamp(),
      };
      // (start/end) مش لازمة هنا لأننا بنرجع لهم من Doc الإيفنت نفسه
      await ueRef.set(data, SetOptions(merge: true));

      emit(JoinEventSuccess());

    } catch (e) {
      emit(JoinEventError('فشل في الانضمام إلى الحدث: ${e.toString()}'));
    }
  }

  /// تستدعيها كل مرة المستخدم يكسب نقاط
  /// - تحسب المضاعف لو في multiplier active
  /// - تضيف النقاط للمستخدم
  /// - تحدث تقدم welcome/target
  /// ترجع النقاط الفعلية المضافة (بعد المضاعفة)
  int pointsAdded = 0;
  Future<void> addPointsWithEvents({
    required String uid,
    required int basePoints,
    required List<AppEvent> events,
    required Map<String, UserEventProgress>? userProgressMap,
    required DateTime now,
  }) async {
    emit(AddPointsLoading());

    try {
      // 1) احسب multiplier الفعّال
      double multiplier = 1.0;
      int add=0;
      for (final e in events.where((e) => e.type == EventType.multiplier)) {
        final up = userProgressMap?[e.id];
        final active = e.isActiveNow(now,
            userStart: up?.userStartAt, userEnd: up?.userEndAt);
        if (active && up != null) {
          final m = (e.rules['multiplier'] ?? 2.0) as num;
          multiplier = multiplier * m.toDouble();
        }
      }
      add = (basePoints * multiplier).round();
      final userRef = fs.collection('users').doc(uid);
      // 2) حدث نقاط المستخدم
      await userRef.update({
        'pointsNumber': FieldValue.increment(add-basePoints),
      });

      // 3) تحديث progress.pointsAccumulated للأحداث النشطة
      for (final e in events.where((x) =>
      x.type == EventType.welcome || x.type == EventType.targetPoints)) {
        final up = userProgressMap?[e.id];
        DateTime? uStart = up?.userStartAt;
        DateTime? uEnd = up?.userEndAt;

        final active = e.isActiveNow(now, userStart: uStart, userEnd: uEnd);
        if (!active || up == null) continue;
        final ueRef = userRef.collection('user_events').doc(e.id);
        final updateData = <String, dynamic>{
          'progress.pointsAccumulated': FieldValue.increment(add),
          'lastUpdatedAt': FieldValue.serverTimestamp(),
        };


        // تحقق وصول الهدف
        final goal = (e.type == EventType.welcome)
            ? (e.rules['welcomeGoal'] ?? 1000) as int
            : (e.rules['targetGoal'] ?? 0) as int;

        final currentAccum = (up.pointsAccumulated) + add;
        if (goal > 0 &&
            currentAccum >= goal &&
            (up.status) != 'reward_claimed') {
          updateData['status'] = 'completed';
        }
        userEventsProgress?[e.id]?.pointsAccumulated =
            (userEventsProgress?[e.id]?.pointsAccumulated ?? 0) + add;

        await ueRef.update(updateData);
      }

      pointsAdded = add;
      emit(AddPointsSuccess());
    } catch (e) {
      emit(AddPointsError('فشل في إضافة النقاط: ${e.toString()}'));
    }
  }

  /// المطالبة بالمكافأة من العميل (Transaction صغيرة)
  Future<void> claimEventReward({
    required String uid,
    required AppEvent event,
  }) async {
    emit(ClaimRewardLoading());

    try {
      final userRef = fs.collection('users').doc(uid);
      final ueRef = userRef.collection('user_events').doc(event.id);

      await fs.runTransaction((tx) async {
        final userSnap = await tx.get(userRef);
        final ueSnap = await tx.get(ueRef);
        if (!ueSnap.exists) {
          throw 'Join the event first';
        }
        final ue = ueSnap.data()!;
        final status = ue['status'] as String? ?? 'not_joined';
        if (status == 'reward_claimed') throw 'Already claimed';

        final now = DateTime.now();
        DateTime? s, e;
        if (event.type == EventType.welcome) {
          s = (ue['userStartAt'] as Timestamp).toDate();
          e = (ue['userEndAt'] as Timestamp).toDate();
        } else {
          s = event.startAt;
          e = event.endAt;
        }
        if (s == null || e == null || !(now.isAfter(s) && now.isBefore(e))) {
          tx.update(ueRef, {'status': 'expired'});
          throw 'Event not active';
        }

        // تحقق شروط كل نوع
        final progress = Map<String, dynamic>.from(ue['progress'] ?? {});
        int reward = 0;
        switch (event.type) {
          case EventType.welcome:
            final goal = (event.rules['welcomeGoal'] ?? 1000) as int;
            if ((progress['pointsAccumulated'] ?? 0) >= goal) {
              reward = (event.rules['welcomeReward'] ?? 3000) as int;
            } else {
              throw 'Goal not reached';
            }
            break;
          case EventType.targetPoints:
            final goal = (event.rules['targetGoal'] ?? 0) as int;
            if ((progress['pointsAccumulated'] ?? 0) >= goal) {
              reward = (event.rules['targetReward'] ?? 0) as int;
            } else {
              throw 'Goal not reached';
            }
            break;
          case EventType.quiz:
            final minC = (event.rules['quizMinCorrect'] ?? 0) as int;
            if ((progress['correctAnswers'] ?? 0) >= minC) {
              reward = (event.rules['quizReward'] ?? 0) as int;
            } else {
              throw 'Not enough correct answers';
            }
            break;
          case EventType.multiplier:
            throw 'No claim for multiplier';
        }

        // أضف النقاط
        final userData = userSnap.data() ?? {};
        final current = (userData['pointsNumber'] ?? 0).toInt();
        tx.update(userRef, {'pointsNumber': current + reward});

        // حدّث حالة الإيفنت
        tx.update(ueRef, {
          'status': 'reward_claimed',
          'claimedAt': FieldValue.serverTimestamp(),
        });
      });

      emit(ClaimRewardSuccess());

    } catch (e) {
      emit(ClaimRewardError('فشل في المطالبة بالمكافأة: ${e.toString()}'));
    }
  }

  String _toStringType(EventType t) {
    switch (t) {
      case EventType.welcome:
        return 'welcome';
      case EventType.multiplier:
        return 'multiplier';
      case EventType.targetPoints:
        return 'target_points';
      case EventType.quiz:
        return 'quiz';
    }
  }

  int _defaultRewardFor(AppEvent e) {
    switch (e.type) {
      case EventType.welcome:
        return (e.rules['welcomeReward'] ?? 3000) as int;
      case EventType.multiplier:
        return 0;
      case EventType.targetPoints:
        return (e.rules['targetReward'] ?? 0) as int;
      case EventType.quiz:
        return (e.rules['quizReward'] ?? 0) as int;
    }
  }


  ///////////////////////////////////////Quiz/////////////////////////////////
  int currentQuestionIndex = 0;
  List<Question> questions= [];
  Future<void> getQuizDetailsData(String uid, String eventId,) async {
    emit(GetQuizDetailsDataLoading());
    try {
      questions= [] ;
        var data = await fs
            .collection('events')
            .doc(eventId)
            .collection('questions')
            .get();
       questions =
        data.docs.map((doc) => Question.fromJson(doc.data())).toList();
      emit(GetQuizDetailsDataSuccess());
    } catch (error) {
     // print('Error fetching lesson details: $error');
      emit(GetQuizDetailsDataError(error.toString()));
    }
  }

  List<Map<String, dynamic>> previousAnswers = [];

  Future<void> getUserPreviousAnswers(String? uid, String eventId) async {
    emit(GetUserPreviousAnswersLoading());

    try {
      previousAnswers=[];
      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await fs
          .collection('users')
          .doc(uid)
          .collection('eventAnswers')
          .where('eventId', isEqualTo: eventId)
          .get();

      // Extract data from documents
      previousAnswers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          "id": doc.id, // Firestore document ID
          "questionId": data["questionId"],
          "answerContent": data["selectedAnswer"],
          "correct": data["correct"],
        };
      }).toList();

      // Emit the loaded state with extracted data
      emit(GetUserPreviousAnswersSuccess());
    } catch (e) {
      emit(GetUserPreviousAnswersError("Error: $e"));
    }
  }

  final FlutterTts flutterTts = FlutterTts();
  bool isEnglish = true;
  void toggleLanguage() {
    isEnglish = !isEnglish;
    emit(LearningUpdated());
  }

  Future<void> speak(String text, String language) async {
    await flutterTts.setLanguage(language);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  int? selectedOption;
  void selectOption(int index) {
    selectedOption = index;
    emit(LearningUpdated());
  }


  Future<void> postUserExamAnswers(
      String uid,
      String questionId,
      String answer,
      bool correct,
      AppEvent e
      ) async {
    emit(PostUserExamAnswersLoading());
    try {
      // Store the answer in the user's answers collection
      int add =correct ?1:0;
      await fs
          .collection('users')
          .doc(uid)
          .collection('eventAnswers')
          .doc(questionId)
          .set({
        'correct': correct,
        'eventId': e.id,
        'questionId': questionId,
        'selectedAnswer': answer,
      });
      final userRef = fs.collection('users').doc(uid);
      final ueRef = userRef.collection('user_events').doc(e.id);
      final updateData = <String, dynamic>{
        'progress.correctAnswers': FieldValue.increment(add),
        'progress.answerCount': FieldValue.increment(1),
        'lastUpdatedAt': FieldValue.serverTimestamp(),
      };
      final up = userEventsProgress?[e.id];

      // تحقق وصول الهدف
      final goal = (e.rules['quizMinCorrect'] ?? 0) as int;
      final goal2 = (e.rules['quizTotal'] ?? 0) as int;
      final currentAccum = (up?.correctAnswers ?? 0) + add;
      final totalAnswer= (up?.answerCount ?? 0) + 1;
      if (goal > 0 &&
          currentAccum >= goal &&
          totalAnswer==goal2 &&
          (up?.status) != 'reward_claimed') {
        updateData['status'] = 'completed';
      }
      userEventsProgress?[e.id]?.correctAnswers = (userEventsProgress?[e.id]?.correctAnswers ?? 0) + add;
      userEventsProgress?[e.id]?.answerCount = (userEventsProgress?[e.id]?.answerCount ?? 0) + 1;
      await ueRef.update(updateData);

      emit(PostUserExamAnswersSuccess());
    } catch (e) {
      emit(PostUserExamAnswersError("Network error: ${e.toString()}"));
    }
  }

  bool isAnswered = false;
  void moveToPastQuestion(
      context,

      ) {
    if (currentQuestionIndex != 0) {
      currentQuestionIndex--;
      selectedOption = null;
      isAnswered = false;
      emit(LearningUpdated());
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const EventsPage()),
      );
    }
  }


  void moveToNextQuestion(context,) {
    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      selectedOption = null;
      isAnswered = false;
      emit(LearningUpdated());
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const EventsPage()),
      );
    }
  }
}


