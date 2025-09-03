import 'package:flutter/material.dart';
import '../../../../shared/style/color.dart';
import '../../generated/l10n.dart';
import '../../models/treasure_model.dart';

enum BoxCardStatus { locked, next, done }

class BoxCard extends StatelessWidget {
  final TreasureTier tier;
  final TreasureBox box;
  final BoxCardStatus status;
  final bool isCurrent;
  final int currentAdsWatched;
  final int userPoints;
  final VoidCallback onOpen;
  final VoidCallback onWatchAd;
  final BuildContext context;

  const BoxCard({
    super.key,
    required this.tier,
    required this.box,
    required this.status,
    required this.isCurrent,
    required this.currentAdsWatched,
    required this.userPoints,
    required this.onOpen,
    required this.onWatchAd,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = status == BoxCardStatus.locked;
    final isNext   = status == BoxCardStatus.next;
    final isDone   = status == BoxCardStatus.done;

    final imagePath = isDone ? tier.openImg : tier.closedImg;

    final needsAds = box.condition.requiresAds;
    final adsReq   = box.condition.minAds ?? 0;
    final adsNow   = currentAdsWatched;

    final bool showWatchAd = isCurrent && isNext && needsAds && (adsNow < adsReq);
    final bool showOpen    = isCurrent && isNext && !showWatchAd;

    // ======= Need Points كـ progress حقيقي للصندوق الجاري فقط =======
    final bool needsPoints = box.condition.requiresPoints;
    final int reqPts       = box.condition.minPoints ?? 0;

    int havePtsDisp;
    if (!needsPoints) {
      havePtsDisp = 0;
    } else if (isDone) {
      havePtsDisp = reqPts;                   // الصندوق المفتوح = مكتمل
    } else if (isCurrent && isNext) {
      havePtsDisp = userPoints.clamp(0, reqPts); // الجاري = المتحقق فعليًا حتى حد req
    } else {
      havePtsDisp = 0;                        // باقي الحالات
    }
    final bool pointsMet = havePtsDisp >= reqPts;
    final int remaining  = (reqPts - havePtsDisp).clamp(0, reqPts);

    // ======= التحقق من الشروط لفتح الصندوق =======
    final bool canOpen = !needsPoints || pointsMet;
    final bool canWatchAd = needsAds && (adsNow < adsReq);

    String pointsLabel() {
      if (!needsPoints) return '';
      if (isCurrent && isNext && !pointsMet && reqPts > 0) {
        return S.of(context).needPointsRemaining(havePtsDisp, reqPts);
      }
      return S.of(context).needPoints2(havePtsDisp, reqPts);
    }

    // ======= شارة الإعلانات =======
    String adsLabel() {
      if (!needsAds) return '';
      if (isDone) return S.of(context).adsProgress(adsReq, adsReq);
      if (isCurrent) return S.of(context).adsProgress(adsNow, adsReq);
      return S.of(context).adsProgress(0, adsReq);
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: isLocked ? 0.6 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDone ? AppColors.greenColor
                : (isNext ? AppColors.secondColor : Colors.grey.shade400),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (ctx, err, st) => Image.asset(
                  'assets/img/ninja_gif.gif',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 6),

            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                  S.of(context).boxNumber(box.index + 1),
                  style: const TextStyle(fontWeight: FontWeight.bold)
              ),
            ),
            const SizedBox(height: 4),

            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                S.of(context).rewardPoints(box.rewardPoints),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 6),

            if (needsPoints)
              _chip(
                pointsLabel(),
                Icons.trending_up,
                background: pointsMet ? AppColors.greenColor.withOpacity(0.12) : AppColors.lightColor,
              ),

            if (needsAds) ...[
              const SizedBox(height: 4),
              _chip(adsLabel(), Icons.ondemand_video),
            ],

            const SizedBox(height: 6),

            if (showWatchAd)
              _ctaButton(
                label: S.of(context).watchAd,
                onPressed: onWatchAd,
                background: AppColors.secondColor,
                foreground: AppColors.whiteColor,
                enabled: true, // زر Watch Ad دائماً مفعل
              )
            else if (showOpen)
              _ctaButton(
                label: S.of(context).open,
                onPressed: canOpen ? onOpen : null, // null يجعل الزر معطلاً
                background: AppColors.mainColor,
                foreground: AppColors.whiteColor,
                enabled: canOpen, // الزر يكون معطلاً إذا لم تتحقق الشروط
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _ctaButton({
    required String label,
    required VoidCallback? onPressed, // تغيير إلى VoidCallback? ليدعم null
    required Color background,
    required Color foreground,
    bool enabled = true, // إضافة معامل enabled
  }) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null, // تعطيل الزر إذا كان enabled = false
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? background : Colors.grey, // تغيير اللون إذا كان معطلاً
          foregroundColor: enabled ? foreground : Colors.white70,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: FittedBox(child: Text(label)),
      ),
    );
  }

  Widget _chip(String label, IconData icon, {Color? background}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: background ?? AppColors.lightColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 12, color: Colors.black87),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}