import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vo_ninja/modules/challenges_page/challenges_cubit/challenges_cubit.dart';
import 'package:vo_ninja/modules/leaderboard_tap_page/leaderboard_tap_cubit/leaderboard_tap_cubit.dart';
import 'package:vo_ninja/modules/lessons_page/learning_cubit/learning_cubit.dart';
import 'package:vo_ninja/modules/login_page/login_cubit/login_cubit.dart';
import 'package:vo_ninja/modules/settings_tap_page/settings_tap_cubit/settings_tap_cubit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vo_ninja/modules/singup_page/singup_cubit/singup_cubit.dart';
import 'generated/l10n.dart';
import 'modules/challenges_page/task_cubit/task_cubit.dart';
import 'modules/challenges_tap_page/challenges_cubit/challenges_tap_cubit.dart';
import 'modules/home_tap_page/home_tap_cubit/home_tap_cubit.dart';
import 'modules/lessons_page/lessons_cubit/lessons_cubit.dart';
import 'modules/login_page/login_page.dart';
import 'modules/taps_page/taps_page.dart';
import 'shared/main_cubit/bloc_observer.dart';
import 'modules/taps_page/taps_cubit/taps_cubit.dart';
import 'shared/main_cubit/cubit.dart';
import 'shared/main_cubit/states.dart';
import 'shared/network/local/cash_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'shared/network/remote/dio_helper.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'shared/style/color.dart';

Future<void> main() async {
  Bloc.observer = MyBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MobileAds.instance.initialize().then(
    (InitializationStatus status) {
      log('Initialization complete: $status');
    },
    onError: (error) {
      log('Initialization failed: $error');
    },
  );
  DioHelperPayment.init();

  // final prefs = await SharedPreferences.getInstance();
  // final String? userToken = prefs.getString('userToken');
  await CashHelper.init();
  final String? userToken = CashHelper.getData(key: 'userToken');
  String language = await CashHelper.getData(key: 'language') ?? 'en';

  runApp(MyApp(
      language: language,
      initialRoute:
          userToken != null && userToken != '' ? '/TapsPage' : '/LoginPage'));
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  final String language;

  const MyApp({
    super.key,
    required this.initialRoute,
    required this.language,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppOpenAd? _appOpenAd;
  bool _isAdShown = false; // Prevents multiple ad displays in the same session

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  /// Loads the ad but does NOT show it immediately
  void _loadAd() {
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-7223929122163665/9538903112', // Test ID
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          log('App Open Ad loaded successfully');
        },
        onAdFailedToLoad: (error) {
          log('Failed to load App Open Ad: $error');
        },
      ),
    );
  }

  /// Shows the ad after the splash screen if it's loaded
  void _showAdIfLoaded() {
    if (_appOpenAd != null && !_isAdShown) {
      _isAdShown = true; // Prevents showing again in the same session
      _appOpenAd!.show();
      log('App Open Ad displayed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainAppCubit()),
        BlocProvider(create: (context) => TapsCubit()),
        BlocProvider(create: (context) => SingupCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => HomeTapCubit()),
        BlocProvider(create: (context) => ChallengeTapCubit()),
        BlocProvider(create: (context) => ChallengeCubit()),
        BlocProvider(create: (context) => LessonCubit()),
        BlocProvider(create: (context) => LearningCubit()),
        BlocProvider(create: (context) => LeaderboardTapCubit()),
        BlocProvider(create: (context) => SettingsTapCubit()),
        BlocProvider(create: (context) => TaskCubit()),
      ],
      child: BlocConsumer<MainAppCubit, MainAppState>(
        listener: (context, state) {},
        builder: (context, state) {
          final language = MainAppCubit.get(context).language;
          return MaterialApp(
              key: Key(MainAppCubit.get(context).language),
              locale: Locale(language),
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              debugShowCheckedModeBanner: false,
              home: EasySplashScreen(
                logoWidth: MediaQuery.of(context).size.width,
                logo: Image.asset(
                  'assets/img/intro.gif',
                ),
                backgroundColor: AppColors.lightColor,
                showLoader: false,
                durationInSeconds: 8,
                navigator: widget.initialRoute == '/TapsPage'
                    ? _navigateWithAd(const TapsPage())
                    : const LoginPage(),
              ));
        },
      ),
    );
  }

  /// Wraps the page navigation with an ad display
  Widget _navigateWithAd(Widget page) {
    Future.delayed(const Duration(seconds: 10), () {
      _showAdIfLoaded();
    });
    return page;
  }
}
