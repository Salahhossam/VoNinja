import 'dart:async';
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
import 'package:vo_ninja/modules/splash_screen.dart';
import 'generated/l10n.dart';
import 'modules/challenges_page/task_cubit/task_cubit.dart';
import 'modules/challenges_tap_page/challenges_cubit/challenges_tap_cubit.dart';
import 'modules/home_tap_page/home_tap_cubit/home_tap_cubit.dart';
import 'modules/lessons_page/lessons_cubit/lessons_cubit.dart';
import 'shared/main_cubit/bloc_observer.dart';
import 'modules/taps_page/taps_cubit/taps_cubit.dart';
import 'shared/main_cubit/cubit.dart';
import 'shared/main_cubit/states.dart';
import 'shared/network/local/cash_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'shared/network/remote/dio_helper.dart';
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
  @override
  void initState() {
    super.initState();
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
            home: SplashPage(initialRoute: widget.initialRoute),
          );
        },
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  final String initialRoute;

  const SplashPage({super.key, required this.initialRoute});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => widget.initialRoute == '/TapsPage'
              ? const SplashScreen(login: false)
              : const SplashScreen(login: true),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.mainColor, 
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: Image.asset(
              'assets/img/splash_voninja.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
