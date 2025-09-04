import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../../models/treasure_model.dart';
import 'treasure_boxes_state.dart';

class TreasureBoxCubit extends Cubit<TreasureBoxState> {
  TreasureBoxCubit() : super(TreasureBoxInitial());

  static TreasureBoxCubit get(context) => BlocProvider.of(context);

  // ========= UI Flags =========
  bool isLoading1 = false;
  bool isLoading2 = false;

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

  // ========= تعريف الصناديق =========
  Map<TreasureTier, List<TreasureBox>> _tiers = {
    TreasureTier.bronze: const [],
    TreasureTier.silver: const [],
    TreasureTier.gold: const [],
  };

  Map<TreasureTier, List<TreasureBox>> get tiers => _tiers;

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

    if (bLen == 0 && sLen == 0 && gLen == 0) return TreasureTier.bronze;

    if (bronzeIndex < bLen) return TreasureTier.bronze;
    if (silverIndex < sLen) return TreasureTier.silver;
    if (goldIndex < gLen) return TreasureTier.gold;
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
      return const TreasureBox(index: 0, rewardPoints: 0, condition: BoxCondition());
    }
    final i = currentIndex.clamp(0, list.length - 1);
    return list[i];
  }

  // ======== تحميل أولي للصفحة ========
  Future<void> load() async {
    try {
      isLoading1 = true;
      emit(TreasureBoxUpdated());

      await _loadTreasure();
      await _loadProgressAndClamp();

      await _saveProgress();
      isLoading1 = false;
      emit(TreasureBoxUpdated());
    } catch (e) {
      isLoading1 = false;
      emit(TreasureBoxFailure(e.toString()));
    }
  }

  // ======== مشاهدة إعلان ========
  Future<void> watchAdForCurrent({required Future<bool> Function() showAd, BuildContext? context}) async {
    try {
      isLoading2 = true;
      emit(TreasureBoxUpdated());
      final ok = await showAd();
      if (!ok) {
        isLoading2 = false;
        final message = context != null
            ? S.of(context).adNotAvailable
            : 'الإعلان غير متاح حاليًا، حاول ثانيا بعد لحظات.';
        emit(TreasureBoxMessage(message));
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

  // ======== فتح الصندوق الحالي ========
  Future<void> tryOpenCurrent({BuildContext? context}) async {
    try {
      isLoading2 = true;
      emit(TreasureBoxUpdated());

      if (currentTier != unlockedTier) {
        isLoading2 = false;
        final message = context != null
            ? S.of(context).cannotAccessLevel
            : 'لا يمكنك دخول هذا المستوى قبل إنهاء السابق.';
        emit(TreasureBoxMessage(message));
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

        String msgPts = '';
        String msgAds = '';

        // في دالة tryOpenCurrent
        if (context != null) {
          msgPts = (needPts != null && userPoints < needPts)
              ? S.of(context).needPoints(needPts - userPoints) // استخدام دالة بدلاً من خاصية
              : '';
          msgAds = (needAds != null && currentAdsWatched < needAds)
              ? S.of(context).watchAds(needAds - currentAdsWatched) // استخدام دالة بدلاً من خاصية
              : '';
        } else {
          msgPts = (needPts != null && userPoints < needPts)
              ? 'تحتاج ${needPts - userPoints} نقطة إضافية. '
              : '';
          msgAds = (needAds != null && currentAdsWatched < needAds)
              ? 'شاهد ${needAds - currentAdsWatched} إعلان/إعلانات.'
              : '';
        }

        emit(TreasureBoxMessage('$msgPts$msgAds'.trim()));
        emit(TreasureBoxUpdated());
        return;
      }

      await _addPoints(box.rewardPoints);
      userPoints += box.rewardPoints;

      final bLen = _tiers[TreasureTier.bronze]?.length ?? 0;
      final sLen = _tiers[TreasureTier.silver]?.length ?? 0;
      final gLen = _tiers[TreasureTier.gold]?.length ?? 0;

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
        final message = context != null
            ? S.of(context).congratsAllBoxes(cycle)
            : 'أحسنت! اكتملت جميع الصناديق لهذه الدورة.';
        emit(TreasureBoxMessage(message));
      }

      currentAdsWatched = 0;
      await _saveProgress();

      final earnedMessage = context != null
          ? S.of(context).earnedPoints(box.rewardPoints) // استخدام دالة بدلاً من خاصية
          : 'حصلت على ${box.rewardPoints} نقطة.';
      isLoading2 = false;
      if(context!=null) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: S.of(context).congratulations,
          desc: earnedMessage,
          btnOkText: S.of(context).ok,
          btnOkOnPress: () {},
        ).show();
      } else{
        emit(TreasureBoxMessage(earnedMessage));
      }
      emit(TreasureBoxUpdated());
    } catch (e) {
      isLoading2 = false;
      emit(TreasureBoxFailure(e.toString()));
    }
  }

  // ======== تبديل المستوى ========
  void requestSwitchTier(TreasureTier desired, {BuildContext? context}) {
    final allowed = unlockedTier;

    // if (desired != allowed) {
    //   final message = context != null
    //       ? S.of(context).completeCurrentLevel
    //       : 'أكمل المستوى الحالي أولًا.';
    //   emit(TreasureBoxMessage(message));
    //   return;
    // }
    currentTier = desired;
    currentIndex = switch (desired) {
      TreasureTier.bronze => bronzeIndex,
      TreasureTier.silver => silverIndex,
      TreasureTier.gold => goldIndex,
    };
    emit(TreasureBoxUpdated());
  }

  // ======== بدء دورة جديدة ========
  Future<void> startNewCycleManually({BuildContext? context}) async {
    try {
      isLoading2 = true;
      emit(TreasureBoxUpdated());

      final bLen = _tiers[TreasureTier.bronze]?.length ?? 0;
      final sLen = _tiers[TreasureTier.silver]?.length ?? 0;
      final gLen = _tiers[TreasureTier.gold]?.length ?? 0;

      final finishedAll = (bronzeIndex >= bLen) && (silverIndex >= sLen) && (goldIndex >= gLen);
      if (!finishedAll) {
        isLoading2 = false;
        final message = context != null
            ? S.of(context).completeAllBoxesFirst
            : 'أكمل كل الصناديق أولاً .';
        emit(TreasureBoxMessage(message));
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

      final message = context != null
          ? S.of(context).newCycleStarted(cycle)
          : 'تم بدء دورة جديدة (#$cycle). بالتوفيق!';
      isLoading2 = false;
      emit(TreasureBoxMessage(message));
      emit(TreasureBoxUpdated());
    } catch (e) {
      isLoading2 = false;
      emit(TreasureBoxFailure(e.toString()));
    }
  }

  // ======== SEED ========
  Future<void> seedDefaultBoxesOnce() async {
    List<Map<String, dynamic>> genTier(int basePts, int count) {
      final rewards = <int>[10,20,30,40,50,10,20,30,40,50,100,10,20,30,40,50,200,10,20,50];
      List<int> r = [];
      for (int i = 0; i < count; i++) {
        r.add(rewards[i % rewards.length]);
      }

      return List.generate(count, (i) {
        final needPts = basePts + (i % 4) * 100;
        final needAds = (i % 5 == 4) ? 2 : null;
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
        'bronze': genTier(400, 20),
        'silver': genTier(600, 20),
        'gold': genTier(800, 20),
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: false));
  }
}