import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vo_ninja/generated/l10n.dart';
import 'package:vo_ninja/shared/style/color.dart'; // Localization class

// Success Dialog
Future<void> showSuccessDialog(
    BuildContext context, {
      required String title,
      required String desc,
      required VoidCallback onOkPressed,
      bool isDismissible = true, // Optional dismissible parameter
    }) async {
  await SmartDialog.show(
    animationType: SmartAnimationType.scale,
    animationTime: const Duration(milliseconds: 400),
    clickMaskDismiss: isDismissible, // Control dismiss on background tap
    builder: (_) => Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.greenColor.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppColors.greenColor,
              size: 50,
            ),
          )
              .animate()
              .scale(duration: 400.ms, curve: Curves.elasticOut)
              .fadeIn(),
          const SizedBox(height: 15),
          Text(
            S.of(context).success, // Localized title
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'njnaruto',
              color: AppColors.mainColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc, // Custom description
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.mainColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenColor,
              foregroundColor: AppColors.whiteColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              minimumSize: const Size(120, 48),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              SmartDialog.dismiss();
              onOkPressed();
            },
            child: Text(
              S.of(context).ok, // Localized "OK"
              style: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Error Dialog
Future<void> showErrorDialog(
    BuildContext context, {
      required String title,
      required String desc,
      required VoidCallback onOkPressed,
      bool isDismissible = true, // Optional dismissible parameter
    }) async {
  await SmartDialog.show(
    animationType: SmartAnimationType.scale,
    animationTime: const Duration(milliseconds: 400),
    clickMaskDismiss: isDismissible, // Control dismiss on background tap
    builder: (_) => Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.errorColor.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.close,
              color: AppColors.errorColor,
              size: 50,
            ),
          )
              .animate()
              .scale(duration: 400.ms, curve: Curves.elasticOut)
              .fadeIn(),
          const SizedBox(height: 15),
          Text(
            S.of(context).error, // Localized title
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'njnaruto',
              color: AppColors.mainColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc, // Custom description
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.mainColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              foregroundColor: AppColors.whiteColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              minimumSize: const Size(120, 48),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              SmartDialog.dismiss();
              onOkPressed();
            },
            child: Text(
              S.of(context).ok, // Localized "OK"
              style: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Warning Dialog
Future<void> showWarningDialog(
    BuildContext context, {
      required String title,
      required String desc,
      required VoidCallback onOkPressed,
      bool isDismissible = true, // Optional dismissible parameter
    }) async {
  await SmartDialog.show(
    animationType: SmartAnimationType.scale,
    animationTime: const Duration(milliseconds: 400),
    clickMaskDismiss: isDismissible, // Control dismiss on background tap
    builder: (_) => Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondColor.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.warning,
              color: AppColors.secondColor,
              size: 50,
            ),
          )
              .animate()
              .scale(duration: 400.ms, curve: Curves.elasticOut)
              .fadeIn(),
          const SizedBox(height: 15),
          Text(
            title, // Custom or localized title
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'njnaruto',
              color: AppColors.mainColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc, // Custom description
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.mainColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cancel Button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.mainColor,
                  side: BorderSide(color: AppColors.mainColor),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  SmartDialog.dismiss();
                },
                child: Text(
                  S.of(context).back, // Localized "Back"
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 16),
              // OK Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondColor,
                  foregroundColor: AppColors.whiteColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  minimumSize: const Size(120, 48),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  SmartDialog.dismiss();
                  onOkPressed();
                },
                child: Text(
                  S.of(context).ok, // Localized "OK"
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// Info Dialog
Future<void> showInfoDialog(
    BuildContext context, {
      required String title,
      required String desc,
      required VoidCallback onOkPressed,
      bool isDismissible = true,
    }) async {
  await SmartDialog.show(
    animationType: SmartAnimationType.scale,
    animationTime: const Duration(milliseconds: 400),
    clickMaskDismiss: isDismissible,
    builder: (_) => Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondColor.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.info,
              color: AppColors.secondColor,
              size: 50,
            ),
          )
              .animate()
              .scale(duration: 400.ms, curve: Curves.elasticOut)
              .fadeIn(),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'njnaruto',
              color: AppColors.mainColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.mainColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cancel Button (optional)
              if (isDismissible)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.mainColor,
                    side: BorderSide(color: AppColors.mainColor),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    SmartDialog.dismiss(result: false); // Dismiss without OK
                  },
                  child: Text(
                    S.of(context).back,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              if (isDismissible) const SizedBox(width: 16),
              // OK Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondColor,
                  foregroundColor: AppColors.whiteColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  minimumSize: const Size(120, 48),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  SmartDialog.dismiss(result: true); // Dismiss with OK
                  onOkPressed();
                },
                child: Text(
                  S.of(context).ok,
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

