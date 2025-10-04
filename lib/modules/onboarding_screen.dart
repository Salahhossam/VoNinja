// lib/main.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vo_ninja/modules/login_page/login_page.dart';
import 'package:vo_ninja/modules/singup_page/singup_page.dart';

import '../shared/network/local/cash_helper.dart';
import '../shared/style/color.dart';
import 'home_tap_page/home_tap_cubit/home_tap_cubit.dart';



class OnboardingSlide {
  final String title;
  final List<String> bullets; // each line shown with a leading icon
  final String image;
  const OnboardingSlide({
    required this.title,
    required this.bullets,
    required this.image,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

   final List<OnboardingSlide> slides = [
    OnboardingSlide(
      title: 'أهلاً بيك في رحلتك مع Voninja',
      bullets: [
        'اتعلّم إنجليزي بخطوات سهلة وممتعة،',
        'وكل ما تطوّر مستواك تجمع نقاط أكتر وتحوّلها لفلوس حقيقية',
      ],
      image: 'assets/onboarding/slide1.png',
    ),
    OnboardingSlide(
      title: 'مستويات تعليم تناسبك\nمن البداية للاحتراف',
      bullets: [
        'كل مستوى بيطور لغتــــك ويضاعف مكافآتــــــــك',
      ],
      image: 'assets/onboarding/slide2.png',
    ),
    OnboardingSlide(
      title: 'التحديات – الفعاليات – الكنوز',
      bullets: [
        'في Voninja هتزود نقاطك مش بس من الدروس،',
        'لكن كمان من التحديات ، الفعاليات المحدودة،',
        'وفتح الكنوز Bronze – Silver – Gold اللي بتوفرلك مكافآت إضافية.',
      ],
      image: 'assets/onboarding/slide3.png',
    ),
    OnboardingSlide(
      title: 'مكافآتك توصلك كاش بسهولة',
      bullets: [
        'كل 25,000 نقطة = 100 جنيه.',
        'التحويل بيتم خلال 24–48 ساعة بكل سهولة وأمان.',
        'تابع رصيدك مباشرة من داخل التطبيق',
      ],
      image: 'assets/onboarding/slide4.png',
    ),
    OnboardingSlide(
      title: 'ابدأ رحلتك الآن مع Voninja',
      bullets: [
        'جاوب أول 5 أسئلة في 5 دقائق،',
        'واحصــل على 500 نقطة مجانية كبداية قوية!',
        'إنجازك الأول = دافعك للاستمرار والتفوق.',
      ],
      image: 'assets/onboarding/slide5.png',
    ),
  ];


  void _next() {
    if (_index < slides.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    }
  }

  void _previous() {
    if (_index > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }





  @override
  Widget build(BuildContext context) {
    final homeTapCubit = HomeTapCubit.get(context);
    return WillPopScope(
      onWillPop: () async => homeTapCubit.doubleBack(context),
      child: Scaffold(
        backgroundColor: AppColors.lightColor,
        body: Column(
          children: [
            Expanded(
              child:Directionality(
                textDirection: TextDirection.rtl,
                child: PageView.builder(
                  allowImplicitScrolling: true,
                  controller: _controller,
                  itemCount: slides.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final slide = slides[i];
                    return _SlideCard(slide: slide);
                  },
                ),
              ),
            ),

            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(_index==slides.length - 1)...[
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              unawaited(CashHelper.saveData(key: 'onBoarding', value: true));
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const LoginPage()),
                                    (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainColor, // mainColor
                              foregroundColor: AppColors.whiteColor, // لون النص
                            ),
                            child:  Text('تسجيل دخول',style:  GoogleFonts.alexandria(
                              fontWeight: FontWeight.w400,
                              fontSize: 12
                            ),),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              unawaited(CashHelper.saveData(key: 'onBoarding', value: true));
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const SingupPage()),
                                    (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondColor, // secondColor
                              foregroundColor: AppColors.whiteColor,
                            ),
                            child:  Text('انشاء حساب',
                                style:  GoogleFonts.alexandria(
                                 fontWeight: FontWeight.w400,
                                  fontSize: 12
                                ),
                            ),
                          ),
                        ],
                      )


                    ],
                    if(_index!=slides.length - 1)
                      InkWell(
                          onTap: _next,
                          child:
                          Image(image: AssetImage('assets/onboarding/leftArrow.png'),width: 40,height: 40,)
                      ),
                    if(_index!=0)
                      InkWell(
                          onTap: _previous,
                          child:
                          Image(image: AssetImage('assets/onboarding/rightArrow.png'),width: 40,height: 40,)
                      ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class _SlideCard extends StatelessWidget {
  const _SlideCard({required this.slide});
  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(75),
                  bottomRight: Radius.circular(75),
                ),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
            Expanded(
              child: SingleChildScrollView(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // يفضل start هنا علشان rtl
                      children: [
                        // Title
                        Text(slide.title, style:  GoogleFonts.alexandria(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),),
                        const SizedBox(height: 12),
                    
                        // Bullets
                        ...slide.bullets.map(
                              (b) => Text(b, style:  GoogleFonts.alexandria(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )


          ],
        ),
        Image.asset(
          slide.image,
          fit: BoxFit.contain,
          errorBuilder: (ctx, err, st) => Image.asset(
            'assets/img/ninja_gif.gif',
            fit: BoxFit.contain,
          ),
        )
      ],
    );
  }
}








