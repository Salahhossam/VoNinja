import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// يمكنك تعديل هذه المسارات عالمياً بدون الحاجة لتعديل منطق الكلاس.
// ضع مسارات الـ GIF أو حتى PNG/SVG (مع Image.asset) حسب حاجتك.
String localDialogInfoAsset = 'assets/animations/info.gif';
String localDialogInfoReverseAsset = 'assets/animations/info.gif';
String localDialogWarningAsset = 'assets/animations/warning.gif';
String localDialogErrorAsset = 'assets/animations/error.gif';
String localDialogSuccessAsset = 'assets/animations/success.gif';
String localDialogQuestionAsset = 'assets/animations/question.gif';

/// ----------------------------------------------------------------------------------------------------

// أيقونات افتراضية تُستخدم كـ fallback إذا فشل تحميل الصورة
IconData localDialogInfoIcon = Icons.info_outline;
IconData localDialogInfoReverseIcon = Icons.info_outline;
IconData localDialogWarningIcon = Icons.warning_amber_rounded;
IconData localDialogErrorIcon = Icons.error_outline;
IconData localDialogSuccessIcon = Icons.check_circle_outline;
IconData localDialogQuestionIcon = Icons.help_outline;

// إعدادات الأيقونة الافتراضية (يمكنك تعديلها عالمياً)
double localDialogHeaderIconSize = 100;
Color? localDialogHeaderIconColor; // لو تُركت null سيأخذ من الثيم

/// Lightweight local replacement for awesome_dialog without rive.
/// Uses static image/GIF assets for headers instead of vector animations.
class LocalAwesomeDialog {
  LocalAwesomeDialog({
    required this.context,
    this.dialogType = LocalDialogType.info,
    this.customHeader,
    this.title,
    this.titleTextStyle,
    this.desc,
    this.descTextStyle,
    this.body,
    this.btnOk,
    this.btnCancel,
    this.btnOkText,
    this.btnOkIcon,
    this.btnOkOnPress,
    this.btnOkColor,
    this.btnCancelText,
    this.btnCancelIcon,
    this.btnCancelOnPress,
    this.btnCancelColor,
    this.onDismissCallback,
    this.isDense = false,
    this.dismissOnTouchOutside = true,
    this.alignment = Alignment.center,
    this.padding,
    this.useRootNavigator = false,
    this.autoHide,
    this.keyboardAware = true,
    this.dismissOnBackKeyPress = true,
    this.width,
    this.dialogBorderRadius,
    this.buttonsBorderRadius,
    this.showCloseIcon = false,
    this.closeIcon,
    this.dialogBackgroundColor,
    this.borderSide,
    this.buttonsTextStyle,
    this.autoDismiss = true,
    this.barrierColor = Colors.black54,
    this.enableEnterKey = false,
    this.bodyHeaderDistance = 15.0,
    this.reverseBtnOrder = false,
    this.transitionAnimationDuration = const Duration(milliseconds: 300),
    this.headerGifAssetMapper,
    this.headerIconMapper,
    this.headerIconColor,
    this.headerIconSize,
    // خصائص الطفو خارج الصندوق
    this.floatHeaderOutside = true,
    this.floatHeaderDistance = 40, // المسافة العمودية فوق حافة الصندوق
    this.headerUseCircleBackground = true,
    this.headerCircleBackgroundColor,
    this.headerCircleDecoration,
    this.outsideHeaderBodySpacing = 20, // مسافة إضافية داخل الصندوق أسفل الهيدر العائم
  }) : assert(autoDismiss || onDismissCallback != null, 'If autoDismiss is false, you must provide an onDismissCallback to pop the dialog');

  final BuildContext context;
  final LocalDialogType dialogType;
  final Widget? customHeader;
  final String? title;
  final TextStyle? titleTextStyle;
  final String? desc;
  final TextStyle? descTextStyle;
  final Widget? body;
  final String? btnOkText;
  final IconData? btnOkIcon;
  final VoidCallback? btnOkOnPress;
  final Color? btnOkColor;
  final String? btnCancelText;
  final IconData? btnCancelIcon;
  final VoidCallback? btnCancelOnPress;
  final Color? btnCancelColor;
  final Widget? btnOk;
  final Widget? btnCancel;
  final bool dismissOnTouchOutside;
  final void Function(LocalDismissType type)? onDismissCallback;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final bool isDense;
  final bool useRootNavigator;
  final Duration? autoHide;
  final bool keyboardAware;
  final bool dismissOnBackKeyPress;
  final double? width;
  final BorderRadiusGeometry? dialogBorderRadius;
  final BorderRadiusGeometry? buttonsBorderRadius;
  final TextStyle? buttonsTextStyle;
  final bool showCloseIcon;
  final Widget? closeIcon;
  final Color? dialogBackgroundColor;
  final BorderSide? borderSide;
  final bool autoDismiss;
  final Color? barrierColor;
  final bool enableEnterKey;
  final double bodyHeaderDistance;
  bool reverseBtnOrder;
  Duration transitionAnimationDuration;
  final String Function(LocalDialogType type)? headerGifAssetMapper;
  final IconData Function(LocalDialogType type)? headerIconMapper; // تخصيص اختيار الأيقونة
  final Color? headerIconColor; // تخصيص اللون لكل Dialog instance
  final double? headerIconSize; // تخصيص الحجم لكل Dialog instance
  // ------- إعدادات الطفو خارج الصندوق -------
  final bool floatHeaderOutside; // هل يُعرض الهيدر خارج حدود الصندوق
  final double floatHeaderDistance; // كم يخرج للأعلى
  final bool headerUseCircleBackground; // وضع الهيدر داخل دائرة
  final Color? headerCircleBackgroundColor; // لون خلفية الدائرة
  final Decoration? headerCircleDecoration; // ديكور مخصص بدلاً من اللون
  final double outsideHeaderBodySpacing; // المسافة بين محتوى الصندوق والهيدر عندما يكون خارجياً

  LocalDismissType _dismissType = LocalDismissType.other;
  bool _onDismissCallbackCalled = false;

  Future<dynamic> show() => showGeneralDialog(
    context: context,
    useRootNavigator: useRootNavigator,
    barrierDismissible: dismissOnTouchOutside,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor ?? Colors.black54,
    pageBuilder: (_, __, ___) {
      if (autoHide != null) {
        Future.delayed(autoHide!, () {
          _dismissType = LocalDismissType.autoHide;
          dismiss();
        });
      }
      return _buildDialog;
    },
    transitionDuration: transitionAnimationDuration,
    transitionBuilder: (c, a, s, child) {
      final curved = CurvedAnimation(parent: a, curve: Curves.easeOutBack);
      return Transform.scale(
        scale: curved.value,
        child: Opacity(opacity: a.value, child: child),
      );
    },
  ).then((value) => _onDismissCallbackCalled ? null : onDismissCallback?.call(_dismissType));

  Widget? get _buildHeaderRaw {
    if (customHeader != null) return customHeader;
    if (dialogType == LocalDialogType.noHeader) return null;
    final assetPath = headerGifAssetMapper?.call(dialogType) ?? _defaultHeaderForType(dialogType);
    // تجهيز الأيقونة fallback
    final IconData fallbackIcon = headerIconMapper?.call(dialogType) ?? _defaultIconForType(dialogType);
    final Color? iconClr = headerIconColor ?? localDialogHeaderIconColor;
    final double iconSz = headerIconSize ?? localDialogHeaderIconSize;

    if (assetPath == null) {
      return Icon(fallbackIcon, size: iconSz, color: iconClr);
    }

    return Image.asset(
      assetPath!,
      height: 100,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stack) {
        return Icon(fallbackIcon, size: iconSz, color: iconClr);
      },
    );
  }

  Widget? get _buildHeader {
    final raw = _buildHeaderRaw;
    if (raw == null) return null;
    if (!headerUseCircleBackground) return raw;
    return Container(
      padding: EdgeInsets.zero,
      height: 100,
      width: 100,
      decoration: headerCircleDecoration ?? BoxDecoration(
        shape: BoxShape.circle,
        color: headerCircleBackgroundColor ?? (dialogBackgroundColor ?? Colors.white),
      ),
      child: raw,
    );
  }

  String? _defaultHeaderForType(LocalDialogType type) {
    switch (type) {
      case LocalDialogType.info:
        return localDialogInfoAsset;
      case LocalDialogType.infoReverse:
        return localDialogInfoReverseAsset;
      case LocalDialogType.warning:
        return localDialogWarningAsset;
      case LocalDialogType.error:
        return localDialogErrorAsset;
      case LocalDialogType.success:
        return localDialogSuccessAsset;
      case LocalDialogType.question:
        return localDialogQuestionAsset;
      case LocalDialogType.noHeader:
        return null;
    }
  }

  IconData _defaultIconForType(LocalDialogType type) {
    switch (type) {
      case LocalDialogType.info:
        return localDialogInfoIcon;
      case LocalDialogType.infoReverse:
        return localDialogInfoReverseIcon;
      case LocalDialogType.warning:
        return localDialogWarningIcon;
      case LocalDialogType.error:
        return localDialogErrorIcon;
      case LocalDialogType.success:
        return localDialogSuccessIcon;
      case LocalDialogType.question:
        return localDialogQuestionIcon;
      case LocalDialogType.noHeader:
        return localDialogInfoIcon;
    }
  }

  Widget get _buildDialog => WillPopScope(
        onWillPop: _onWillPop,
        child: Align(
          alignment: alignment,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // صندوق المحتوى
              Container(
                width: width ?? (isDense ? null : MediaQuery.of(context).size.width * 0.75),
                margin: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: (floatHeaderOutside && _buildHeader != null) ? (floatHeaderDistance) : 0,
                ),
                padding: padding ?? const EdgeInsets.fromLTRB(16, 8, 16, 16),
                decoration: ShapeDecoration(
                  color: dialogBackgroundColor ?? Theme.of(context).dialogBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: dialogBorderRadius as BorderRadius? ?? BorderRadius.circular(16),
                    side: borderSide ?? BorderSide.none,
                  ),
                ),
                child: _buildContent,
              ),
              if (_buildHeader != null && floatHeaderOutside)
                Positioned(
                  top: -(floatHeaderDistance),
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: _buildHeader!,
                  ),
                ),
            ],
          ),
        ),
      );

  Widget get _buildContent {
    final List<Widget> columnChildren = [];

    if (showCloseIcon) {
      columnChildren.add(
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              _dismissType = LocalDismissType.topIcon;
              dismiss();
            },
            child: closeIcon ?? const Icon(Icons.close, size: 20),
          ),
        ),
      );
    }

    // إذا الهيدر عائم نضيف مسافة فقط، وإلا نضيف الهيدر داخل الصندوق
    if (_buildHeader != null && floatHeaderOutside) {
      columnChildren.add(SizedBox(height: outsideHeaderBodySpacing));
    } else if (_buildHeader != null && !floatHeaderOutside) {
      columnChildren.add(Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: _buildHeader!,
      ));
    } else if (dialogType == LocalDialogType.noHeader) {
      columnChildren.add(SizedBox(height: bodyHeaderDistance));
    }

    if (body != null) {
      columnChildren.add(body!);
    } else {
      if (title != null) {
        columnChildren.add(
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(title!, style: titleTextStyle ?? Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
          ),
        );
      }
      if (desc != null) {
        columnChildren.add(
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(desc!, style: descTextStyle ?? Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
          ),
        );
      }
    }

    final okButton = btnOk ?? (btnOkOnPress != null ? _buildOkButton : null);
    final cancelButton = btnCancel ?? (btnCancelOnPress != null ? _buildCancelButton : null);
    final buttons = [if (okButton != null) okButton, if (cancelButton != null) cancelButton];

    if (buttons.isNotEmpty) {
      final ordered = reverseBtnOrder ? buttons.reversed.toList() : buttons;
      columnChildren.add(
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ordered
                .map(
                  (w) => Expanded(
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: w),
                  ),
                )
                .toList(),
          ),
        ),
      );
    }

    return _wrapWithEnterKey(Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: columnChildren));
  }

  Widget get _buildOkButton => _buildActionButton(
    text: btnOkText ?? 'Ok',
    color: btnOkColor ?? const Color(0xFF00CA71),
    icon: btnOkIcon,
    onPressed: () {
      _dismissType = LocalDismissType.btnOk;
      dismiss();
      btnOkOnPress?.call();
    },
  );

  Widget get _buildCancelButton => _buildActionButton(
    text: btnCancelText ?? 'Cancel',
    color: btnCancelColor ?? Colors.red,
    icon: btnCancelIcon,
    onPressed: () {
      _dismissType = LocalDismissType.btnCancel;
      dismiss();
      btnCancelOnPress?.call();
    },
  );

  Widget _buildActionButton({required String text, required Color color, IconData? icon, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
      label: Text(text, style: buttonsTextStyle ?? const TextStyle(fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: buttonsBorderRadius as BorderRadius? ?? BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _wrapWithEnterKey(Widget child) {
    if (!enableEnterKey) return child;
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.numpadEnter) {
          if (btnOkOnPress != null) {
            _dismissType = LocalDismissType.btnOk;
            dismiss();
            btnOkOnPress?.call();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }

  void dismiss() {
    if (_onDismissCallbackCalled) return;
    if (autoDismiss) {
      Navigator.of(context, rootNavigator: useRootNavigator).pop();
    }
    onDismissCallback?.call(_dismissType);
    _onDismissCallbackCalled = true;
  }

  Future<bool> _onWillPop() async {
    if (!dismissOnBackKeyPress) return false;
    _dismissType = LocalDismissType.androidBackButton;
    dismiss();
    return false;
  }
}

enum LocalDialogType { info, infoReverse, warning, error, success, question, noHeader }

enum LocalDismissType { btnOk, btnCancel, topIcon, modalBarrier, androidBackButton, autoHide, other }
