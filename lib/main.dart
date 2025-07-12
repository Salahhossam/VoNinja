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
import 'modules/library_page/library_cubit/library_cubit.dart';
import 'shared/main_cubit/bloc_observer.dart';
import 'modules/taps_page/taps_cubit/taps_cubit.dart';
import 'shared/main_cubit/cubit.dart';
import 'shared/main_cubit/states.dart';
import 'shared/network/local/cash_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'shared/network/remote/dio_helper.dart';
import 'shared/style/color.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Global connectivity service instance
final connectivityService = ConnectivityService();

Future<void> main() async {
  Bloc.observer = MyBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize connectivity service
  connectivityService.initialize();

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

  await CashHelper.init();
  final String? userToken = CashHelper.getData(key: 'userToken');
  String language = await CashHelper.getData(key: 'language') ?? 'en';

  runApp(MyApp(
      language: language,
      initialRoute:
          userToken != null && userToken != '' ? '/TapsPage' : '/LoginPage'));
}

/// Connectivity service that monitors network status throughout the app
class ConnectivityService {
  // Singleton pattern
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  // Connection status controller
  bool _isOnline = true;
  late StreamSubscription _subscription;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Initialize the service
  void initialize() {
    _checkInitialConnectivity();
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      // Handle the list of results
      // Check if any of the results indicate connectivity
      bool hasConnection =
          results.any((result) => result != ConnectivityResult.none);
      _handleConnectivityChange(hasConnection);
    });
  }

  // Check connectivity at startup
  Future<void> _checkInitialConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _isOnline = result.any((r) => r != ConnectivityResult.none);
  }

  // Handle connectivity changes with a simple boolean
  void _handleConnectivityChange(bool isOnline) {
    final bool wasOnline = _isOnline;
    _isOnline = isOnline;

    // Only navigate when going from online to offline
    if (wasOnline && !_isOnline) {
      _navigateToOfflinePage();
    }
    // Return to previous page when connection is restored
    else if (!wasOnline && _isOnline) {
      _navigateBack();
    }
  }

  // Navigate to offline page
  void _navigateToOfflinePage() {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => const NoInternetScreen(),
          settings: const RouteSettings(name: NoInternetScreen.routeName),
        ),
      );
    }
  }

  // Navigate back when connection is restored
  void _navigateBack() {
    if (navigatorKey.currentState != null &&
        navigatorKey.currentContext != null) {
      Navigator.of(navigatorKey.currentContext!).popUntil((route) {
        return route.settings.name != NoInternetScreen.routeName;
      });
    }
  }

  // Clean up
  void dispose() {
    _subscription.cancel();
  }
}

class NoInternetScreen extends StatefulWidget {
  static const String routeName = '/offline';

  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  late StreamSubscription _subscription;
  bool _isReconnecting = false;

  @override
  void initState() {
    super.initState();
    // مراقبة تغييرات الاتصال
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      _checkIfShouldNavigateBack(result);
    });
  }

  void _checkIfShouldNavigateBack(dynamic result) {
    bool isOnline = false;

    if (result is List<ConnectivityResult>) {
      isOnline = result.any((r) => r != ConnectivityResult.none);
    } else if (result is ConnectivityResult) {
      isOnline = result != ConnectivityResult.none;
    }

    if (isOnline && mounted) {
      _navigateToSplashScreen();
    }
  }

  void _navigateToSplashScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => SplashPage(
          initialRoute: CashHelper.getData(key: 'userToken') != null
              ? '/TapsPage'
              : '/LoginPage',
        ),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.mainColor,
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/Background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wifi_off,
                      size: 80,
                      color: AppColors.lightColor,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "No internet connection",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Please check your internet connection.",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.lightColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    _isReconnecting
                        ? const CircularProgressIndicator(
                            color: AppColors.lightColor,
                          )
                        : ElevatedButton.icon(
                            icon: const Icon(
                              Icons.refresh,
                              color: AppColors.lightColor,
                            ),
                            label: const Text(
                              "Try again",
                              style: TextStyle(
                                color: AppColors.lightColor,
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                _isReconnecting = true;
                              });

                              final result =
                                  await Connectivity().checkConnectivity();
                              bool isOnline = result
                                  .any((r) => r != ConnectivityResult.none);

                              setState(() {
                                _isReconnecting = false;
                              });

                              if (isOnline) {
                                _navigateToSplashScreen();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
        BlocProvider(create: (context) => LibraryCubit()),
      ],
      child: BlocConsumer<MainAppCubit, MainAppState>(
        listener: (context, state) {},
        builder: (context, state) {
          final language = MainAppCubit.get(context).language;
          return MaterialApp(
            key: Key(MainAppCubit.get(context).language),
            // Use the navigatorKey from connectivity service
            navigatorKey: connectivityService.navigatorKey,
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
            routes: {
              NoInternetScreen.routeName: (context) => const NoInternetScreen(),
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up connectivity service
    connectivityService.dispose();
    super.dispose();
  }
}

// تعديل SplashPage للتحقق من الاتصال بالإنترنت عند بدء التشغيل

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
    _checkConnectivityAndNavigate();
  }

  Future<void> _checkConnectivityAndNavigate() async {
    // التحقق من الاتصال بالإنترنت
    final result = await Connectivity().checkConnectivity();
    bool isOnline = true;

    isOnline = result.any((r) => r != ConnectivityResult.none);

    if (!isOnline) {
      // إذا لم يكن هناك اتصال بالإنترنت، عرض صفحة عدم الاتصال
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const NoInternetScreen(),
            settings: const RouteSettings(name: NoInternetScreen.routeName),
          ),
        );
      }
    } else {
      // إذا كان هناك اتصال بالإنترنت، متابعة العملية الطبيعية
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => widget.initialRoute == '/TapsPage'
                  ? const SplashScreen(login: false)
                  : const SplashScreen(login: true),
            ),
          );
        }
      });
    }
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
