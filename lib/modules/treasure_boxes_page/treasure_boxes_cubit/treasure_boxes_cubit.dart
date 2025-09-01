import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/treasure_model.dart';
import 'treasure_boxes_state.dart';

class TreasureBoxCubit extends Cubit<TreasureBoxState> {
  TreasureBoxCubit() : super(TreasureBoxInitial());

  static TreasureBoxCubit get(context) => BlocProvider.of(context);

  // ========= UI Flags =========
  bool isLoading1 = false; // تحميل أولي لتهيئة الصفحة/الكونفيج/التقدم
  bool isLoading2 = false; // أي عمليات لاحقة (فتح صندوق، مشاهدة إعلان، Reset...)

  // ========= تقدم المستخدم =========
  int userPoints = 0;
  int cycle = 0;
  int bronzeIndex = 0;
  int silverIndex = 0;
  int goldIndex = 0;

  TreasureTier currentTier = TreasureTier.bronze;
  int currentIndex = 0;
  int currentAdsWatched = 0;

  // ========= Firebase =========
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String pointsField = 'pointsNumber';

  // ========= تعريف الصناديق (دYNAMIC) =========
  // تُقرأ من Firestore: treasure
  Map<TreasureTier, List<TreasureBox>> _tiers = {
    TreasureTier.bronze: const [],
    TreasureTier.silver: const [],
    TreasureTier.gold: const [],
  };

  // ======== Helpers ========
  Future<String> _uid() async {
    final u = _auth.currentUser;
    if (u != null) return u.uid;
    throw Exception('No Firebase user signed in');
  }

  Future<DocumentReference<Map<String, dynamic>>> _userDoc() async {
    final uid = await _uid();
    return _db.collection('users').doc(uid);
  }

  Future<DocumentReference<Map<String, dynamic>>> _progressDoc() async {
    final uid = await _uid();
    return _db.collection('users').doc(uid).collection('treasure').doc('progress');
  }

  DocumentReference<Map<String, dynamic>> _treasureDoc() {
    return _db.collection('treasure').doc('hivmoPbiFoXbVnMsK4IM');
  }

  Future<int> _getUserPoints() async {
    final ref = await _userDoc();
    final snap = await ref.get();
    final data = snap.data();
    final v = data?[pointsField];
    if (v is int) return v;
    if (v is num) return v.toInt();
    return 0;
  }

  Future<void> _addPoints(int by) async {
    final ref = await _userDoc();
    await ref.set({pointsField: FieldValue.increment(by)}, SetOptions(merge: true));
  }

  TreasureTier get unlockedTier {
    final bLen = _tiers[TreasureTier.bronze]?.length ?? 0;
    final sLen = _tiers[TreasureTier.silver]?.length ?? 0;
    final gLen = _tiers[TreasureTier.gold]?.length ?? 0;

    if (bLen == 0 && sLen == 0 && gLen == 0) return TreasureTier.bronze; // حماية

    if (bronzeIndex < bLen) return TreasureTier.bronze;
    if (silverIndex < sLen) return TreasureTier.silver;
    if (goldIndex < gLen) return TreasureTier.gold;
    // لو الكل انتهى، يظل آخر مستوى (لن نعيد بناء الدورة تلقائيًا)
    return TreasureTier.gold;
  }

  // ======== تحميل تعريف الصناديق من Firestore ========
  Future<void> _loadTreasure() async {
    try {
      final snap = await _treasureDoc().get();
      if (!snap.exists) {
        throw Exception('Treasure config is missing. Seed it once, then let admin edit.');
      }

      final data = snap.data()!;
      final tiers = (data['tiers'] as Map<String, dynamic>?);

      List<TreasureBox> parseTier(List list) {
        return list.map((e) {
          final m = Map<String, dynamic>.from(e as Map);
          final cond = Map<String, dynamic>.from(m['condition'] ?? {});
          return TreasureBox(
            index: (m['index'] ?? 0) as int,
            rewardPoints: (m['rewardPoints'] ?? 0) as int,
            condition: BoxCondition(
              minPoints: cond['minPoints'] is int
                  ? cond['minPoints'] as int
                  : (cond['minPoints'] as num?)?.toInt(),
              minAds: cond['minAds'] is int
                  ? cond['minAds'] as int
                  : (cond['minAds'] as num?)?.toInt(),
            ),
          );
        }).toList()
          ..sort((a, b) => a.index.compareTo(b.index));
      }

      _tiers = {
        TreasureTier.bronze: parseTier(List.from(tiers?['bronze'] ?? const [])),
        TreasureTier.silver: parseTier(List.from(tiers?['silver'] ?? const [])),
        TreasureTier.gold: parseTier(List.from(tiers?['gold'] ?? const [])),
      };
    } catch (e, stack) {
      // هنا تقدر تطبع أو تسجل الخطأ
      debugPrint('Error loading treasure: $e');
    }
  }


  // ======== حفظ/قراءة تقدم المستخدم ========
  Future<void> _saveProgress() async {
    final ref = await _progressDoc();
    await ref.set({
      'bronzeIndex': bronzeIndex,
      'silverIndex': silverIndex,
      'goldIndex': goldIndex,
      'cycle': cycle,
      'currentTier': switch (currentTier) {
        TreasureTier.bronze => 'bronze',
        TreasureTier.silver => 'silver',
        TreasureTier.gold => 'gold',
      },
      'currentIndex': currentIndex,
      'currentAdsWatched': currentAdsWatched,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _loadProgressAndClamp() async {
    userPoints = await _getUserPoints();

    final snap = await (await _progressDoc()).get();
    final p = snap.data();

    // أطوال المستويات الديناميكية
    final bLen = _tiers[TreasureTier.bronze]?.length ?? 0;
    final sLen = _tiers[TreasureTier.silver]?.length ?? 0;
    final gLen = _tiers[TreasureTier.gold]?.length ?? 0;

    bronzeIndex = (p?['bronzeIndex'] ?? 0).clamp(0, bLen);
    silverIndex = (p?['silverIndex'] ?? 0).clamp(0, sLen);
    goldIndex = (p?['goldIndex'] ?? 0).clamp(0, gLen);
    cycle = p?['cycle'] ?? 0;

    currentTier = switch ((p?['currentTier'] as String?) ?? 'bronze') {
      'silver' => TreasureTier.silver,
      'gold' => TreasureTier.gold,
      _ => TreasureTier.bronze,
    };

    currentIndex = (p?['currentIndex'] ?? 0);
    currentAdsWatched = p?['currentAdsWatched'] ?? 0;

    // اجبار المؤشر الحالي على مستوى مسموح + داخل الحدود
    final allowed = unlockedTier;
    currentTier = allowed;
    final nextIndex = switch (allowed) {
      TreasureTier.bronze => bronzeIndex,
      TreasureTier.silver => silverIndex,
      TreasureTier.gold => goldIndex,
    };
    currentIndex = nextIndex.clamp(0, (_tiers[allowed]?.length ?? 1) - 1);
  }

  // ======== API عام للواجهة ========
  List<TreasureBox> buildTierBoxes(TreasureTier tier) => _tiers[tier] ?? const [];

  TreasureBox get currentBox {
    final list = _tiers[currentTier] ?? const [];
    if (list.isEmpty) {
      // حماية: في حالة عدم وجود صناديق
      return const TreasureBox(index: 0, rewardPoints: 0, condition: BoxCondition());
    }
    final i = currentIndex.clamp(0, list.length - 1);
    return list[i];
  }

  // ======== تحميل أولي للصفحة (isLoading1) ========
  Future<void> load() async {
    try {
      isLoading1 = true;
      emit(TreasureBoxUpdated()); // نحدث الواجهة لتُظهر التحميل الأول

      await _loadTreasure();           // قراءة تعريف الصناديق من Firestore
      await _loadProgressAndClamp(); // قراءة التقدم وضبط الحدود

      await _saveProgress(); // تأكيد التناسق
      isLoading1 = false;
      emit(TreasureBoxUpdated());
    } catch (e) {
      isLoading1 = false;
      emit(TreasureBoxFailure(e.toString()));
    }
  }

  // ======== مشاهدة إعلان (isLoading2) ========
  Future<void> watchAdForCurrent({required Future<bool> Function() showAd}) async {
    try {
      isLoading2 = true;
      emit(TreasureBoxUpdated());
      final ok = await showAd();
      if (!ok) {
        isLoading2 = false;
        emit(TreasureBoxMessage('الإعلان غير متاح حاليًا، حاول ثانيا بعد لحظات.'));
        emit(TreasureBoxUpdated());
        return;
      }
      currentAdsWatched += 1;
      await _saveProgress();
      isLoading2 = false;
      emit(TreasureBoxUpdated());
    } catch (e) {
      isLoading2 = false;
      emit(TreasureBoxFailure(e.toString()));
    }
  }

  // ======== فتح الصندوق الحالي (isLoading2) ========
  Future<void> tryOpenCurrent() async {
    try {
      isLoading2 = true;
      emit(TreasureBoxUpdated());

      // تأمين المستوى المسموح
      if (currentTier != unlockedTier) {
        isLoading2 = false;
        emit(TreasureBoxMessage('لا يمكنك دخول هذا المستوى قبل إنهاء السابق.'));
        emit(TreasureBoxUpdated());
        return;
      }

      final box = currentBox;
      userPoints = await _getUserPoints();
      final ok = box.condition.isSatisfied(points: userPoints, ads: currentAdsWatched);

      if (!ok) {
        isLoading2 = false;
        final needPts = box.condition.minPoints;
        final needAds = box.condition.minAds;
        final msgPts = (needPts != null && userPoints < needPts) ? 'تحتاج ${needPts - userPoints} نقطة إضافية. ' : '';
        final msgAds = (needAds != null && currentAdsWatched < needAds) ? 'شاهد ${needAds - currentAdsWatched} إعلان/إعلانات.' : '';
        emit(TreasureBoxMessage('$msgPts$msgAds'.trim()));
        emit(TreasureBoxUpdated());
        return;
      }

      // صرف المكافأة
      await _addPoints(box.rewardPoints);
      userPoints += box.rewardPoints;

      // أطوال المستويات الديناميكية
      final bLen = _tiers[TreasureTier.bronze]?.length ?? 0;
      final sLen = _tiers[TreasureTier.silver]?.length ?? 0;
      final gLen = _tiers[TreasureTier.gold]?.length ?? 0;

      // تقدّم المؤشر
      switch (currentTier) {
        case TreasureTier.bronze:
          bronzeIndex = (bronzeIndex + 1).clamp(0, bLen);
          break;
        case TreasureTier.silver:
          silverIndex = (silverIndex + 1).clamp(0, sLen);
          break;
        case TreasureTier.gold:
          goldIndex = (goldIndex + 1).clamp(0, gLen);
          break;
      }

      // تحديد المستوى/المؤشر التالي بدون إعادة بناء تلقائي
      if (bronzeIndex < bLen) {
        currentTier = TreasureTier.bronze;
        currentIndex = bronzeIndex;
      } else if (silverIndex < sLen) {
        currentTier = TreasureTier.silver;
        currentIndex = silverIndex;
      } else if (goldIndex < gLen) {
        currentTier = TreasureTier.gold;
        currentIndex = goldIndex;
      } else {
        // الكل منتهٍ — لا نعمل Reset تلقائيًا
        emit(TreasureBoxMessage('أحسنت! اكتملت جميع الصناديق لهذه الدورة.'));
      }

      currentAdsWatched = 0;
      await _saveProgress();

      isLoading2 = false;
      emit(TreasureBoxMessage('حصلت على ${box.rewardPoints} نقطة.'));
      emit(TreasureBoxUpdated());
    } catch (e) {
      isLoading2 = false;
      emit(TreasureBoxFailure(e.toString()));
    }
  }

  // ======== تبديل المستوى (مانيوال) ========
  void requestSwitchTier(TreasureTier desired) {
    final allowed = unlockedTier;
    if (desired != allowed) {
      emit(TreasureBoxMessage('أكمل المستوى الحالي أولًا.'));
      return;
    }
    currentTier = desired;
    currentIndex = switch (desired) {
      TreasureTier.bronze => bronzeIndex,
      TreasureTier.silver => silverIndex,
      TreasureTier.gold => goldIndex,
    };
    emit(TreasureBoxUpdated());
  }

  // ======== زر “بدء دورة جديدة” (Reset يدوي) (isLoading2) ========
  Future<void> startNewCycleManually() async {
    try {
      isLoading2 = true;
      emit(TreasureBoxUpdated());

      final bLen = _tiers[TreasureTier.bronze]?.length ?? 0;
      final sLen = _tiers[TreasureTier.silver]?.length ?? 0;
      final gLen = _tiers[TreasureTier.gold]?.length ?? 0;

      // يبدأ من الصفر فقط إذا كان أنهى كل الصناديق (أكثر أمانًا)
      final finishedAll = (bronzeIndex >= bLen) && (silverIndex >= sLen) && (goldIndex >= gLen);
      if (!finishedAll) {
        // يمكنك السماح بالإعادة في أي وقت، لكن هذا يمنع خسارة التقدم دون داعي
        isLoading2 = false;
        emit(TreasureBoxMessage('أكمل كل الصناديق أولاً .'));
        emit(TreasureBoxUpdated());
        return;
      }

      bronzeIndex = 0;
      silverIndex = 0;
      goldIndex = 0;
      cycle += 1;
      currentTier = TreasureTier.bronze;
      currentIndex = 0;
      currentAdsWatched = 0;
      final ref = await _userDoc();
      await ref.set({pointsField: 500}, SetOptions(merge: true));
      userPoints = 500;
      await _saveProgress();

      isLoading2 = false;
      emit(TreasureBoxMessage('تم بدء دورة جديدة (#$cycle). بالتوفيق!'));
      emit(TreasureBoxUpdated());
    } catch (e) {
      isLoading2 = false;
      emit(TreasureBoxFailure(e.toString()));
    }
  }

  // ======== SEED: ترفع التعريف مرة واحدة فقط ========
  // نادِها يدويًا مرة واحدة (مثلاً من شاشة أدوات الأدمن أو من زر مخفي)
  Future<void> seedDefaultBoxesOnce() async {
    // مثال تكوين افتراضي — عدّله كما تحب، وسيتخزن في وثيقة واحدة
    List<Map<String, dynamic>> genTier(int basePts, int count) {
      final rewards = <int>[10,20,30,40,50,10,20,30,40,50,100,10,20,30,40,50,200,10,20,50];
      // لو count أكبر/أصغر من 20، هنقص/نزود قائمة الـ rewards تلقائيًا
      List<int> r = [];
      for (int i = 0; i < count; i++) {
        r.add(rewards[i % rewards.length]);
      }

      return List.generate(count, (i) {
        final needPts = basePts + (i % 4) * 100;
        final needAds = (i % 5 == 4) ? 2 : null; // مثال: كل خامس صندوق يحتاج 2 إعلان
        return {
          'index': i,
          'rewardPoints': r[i],
          'condition': {
            'minPoints': needPts,
            'minAds': needAds,
          }
        };
      });
    }

    final doc = _treasureDoc();
    await doc.set({
      'tiers': {
        'bronze': genTier(400, 20), // عدّل الأعداد بحرية (مثلاً 15 أو 25 أو 30)
        'silver': genTier(600, 20),
        'gold': genTier(800, 20),
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: false));
  }
}
