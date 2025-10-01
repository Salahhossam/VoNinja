import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../shared/style/color.dart';


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // قائمة الصفحات
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        title: "✨ تعلّم إنجليزي… واربح مكافآت حقيقية مع Voninja 🎯",
        body:
        "Voninja بيجمع بين التعليم والمتعة والجوائز.\nكل إجابة صحيحة = نقاط حقيقية تقدر تستبدلها بمكافآت مالية.",
        image: Center(child: Image.asset('assets/img/f_ninja4.png', height: 200)),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.mainColor,
          ),
          bodyTextStyle: TextStyle(fontSize: 16, color: AppColors.mainColor),
          imagePadding: EdgeInsets.only(top: 40),
        ),
      ),
      PageViewModel(
        title: "مستويات تعليم تناسبك من البداية للاحتراف 📈",
        body:
        "Basic: 135 درس – كل إجابة = +1 نقطة.\nIntermediate: 60 درس – كل إجابة = +2 نقطة.\nAdvanced: 40 درس – كل إجابة = +3 نقاط.\n💡 كل مستوى بيطور لغتك ويضاعف مكافآتك.",
        image: Center(child: Image.asset('assets/img/f_ninja4.png', height: 200)),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.mainColor,
          ),
          bodyTextStyle: TextStyle(fontSize: 16, color: AppColors.mainColor),
          imagePadding: EdgeInsets.only(top: 40),
        ),
      ),
      PageViewModel(
        title: "التحديات – الفعاليات – الكنوز 🎮",
        body:
        "Challenges: مهام بنقاط من +3 لحد +30 حسب الصعوبة.\nEvents: فعاليات محدودة (مثال: حل 1000 سؤال من 1500 = 10,000 نقطة).\nTreasures: كنوز ( Bronze - Silver - Gold ) تحصل عليها كل ما تجمع نقاط وتفتحها لنقاط إضافية.",
        image: Center(child: Image.asset('assets/img/f_ninja4.png', height: 200)),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.mainColor,
          ),
          bodyTextStyle: TextStyle(fontSize: 16, color: AppColors.mainColor),
          imagePadding: EdgeInsets.only(top: 40),
        ),
      ),
      PageViewModel(
        title: "استبدال النقاط 💳",
        body:
        "كل 25,000 نقطة = 100 جنيه.\nالتحويل بيتم خلال 24–48 ساعة بكل سهولة وأمان.\nتابع رصيدك مباشرة من داخل التطبيق.",
        image: Center(child: Image.asset('assets/img/f_ninja4.png', height: 200)),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.mainColor,
          ),
          bodyTextStyle: TextStyle(fontSize: 16, color: AppColors.mainColor),
          imagePadding: EdgeInsets.only(top: 40),
        ),
      ),
      PageViewModel(
        title: "دعم متكامل وخدمات إضافية 🤝",
        body:
        "عندك أي سؤال عن استخدام التطبيق؟\nهتلاقي الإجابة في User Guide داخل صفحة Settings.\nولو واجهتك أي مشكلة أو استفسار:\nتقدر تتواصل مباشرة مع فريق Technical Support عبر الواتساب أو البريد الإلكتروني من خلال صفحة Settings.",
        image: Center(child: Image.asset('assets/img/f_ninja4.png', height: 200)),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.mainColor,
          ),
          bodyTextStyle: TextStyle(fontSize: 16, color: AppColors.mainColor),
          imagePadding: EdgeInsets.only(top: 40),
        ),
      ),
      PageViewModel(
        title: "ابدأ رحلتك مع Voninja الآن 🎁",
        body:
        "جاوب أول 5 أسئلة في 5 دقائق، واحصل على 500 نقطة مجانية كبداية قوية!\n💡 إنجازك الأول = دافعك للاستمرار والتفوق.",
        image: Center(child: Image.asset('assets/img/f_ninja4.png', height: 200)),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.mainColor,
          ),
          bodyTextStyle: TextStyle(fontSize: 16, color: AppColors.mainColor),
          imagePadding: EdgeInsets.only(top: 40),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IntroductionScreen(
          pages: getPages(),
          onDone: () {
            // Navigator.pushReplacementNamed(context, '/home');
          },
          rtl: true,
          dotsFlex: 4,
          nextFlex: 1,

          dotsDecorator: DotsDecorator(
            activeColor: AppColors.secondColor,
            size: const Size(6, 6),
            activeSize: const Size(14, 6), // كانت 22x10
            spacing: const EdgeInsets.symmetric(horizontal: 3), // قلّل المسافة
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          controlsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          controlsMargin: const EdgeInsets.only(bottom: 8),

          showSkipButton: true,
          skip: const Text(
            "تخطي",
            style: TextStyle(fontSize: 14, color: AppColors.secondColor), // صغّر الفونت
          ),
          next: const Icon(Icons.arrow_back, size: 20, color: AppColors.secondColor), // صغّر الأيقونة
          done: const Text(
            "ابدأ الآن",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.secondColor),
          ),

          globalBackgroundColor: AppColors.whiteColor,
        ),

      ),
    );
  }
}