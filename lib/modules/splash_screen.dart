import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart'; // 👈 import this
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vo_ninja/modules/taps_page/taps_page.dart';
import 'login_page/login_page.dart';
import '../shared/style/color.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  final String route;

  const SplashScreen({super.key, required this.route});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppOpenAd? _appOpenAd;
  bool _isAdShown = false;

  late VideoPlayerController _controller;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/intro.MP4')
      ..initialize().then((_) {
        _controller.setLooping(true);
        setState(() {});
        _controller.play();
      });

    _startSplashScreen();
  }

  Future<bool> _checkAppVersion() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      // final currentVersion = packageInfo.version;
      // final currentBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;

      final currentVersion =
          int.tryParse(packageInfo.version.replaceAll('.', '')) ?? 0;
      final currentBuildNumber =
          int.tryParse(packageInfo.buildNumber) ?? 0;

      final doc = await _firestore.collection('utils').doc('app_version').get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        // final latestVersion = data['latest_version'] as String? ?? '1.0.0';
        // final latestBuildNumber = data['latest_build_number'] as String?  ?? '0';
        final latestVersion = int.tryParse((data['latest_version'] as String? ?? '1.0.0').replaceAll('.', '')) ?? 0;
        final latestBuildNumber = int.tryParse(data['latest_build_number'] as String?  ?? '0') ?? 0;
        final isMandatory = data['is_mandatory'] as bool? ?? false;
        final appStoreUrl = data['app_store_url'] as String? ?? '';

        if (currentVersion < latestVersion ||
            (currentVersion == latestVersion && currentBuildNumber < latestBuildNumber)) {
          _showUpdateDialog(context, isMandatory, appStoreUrl);
          _controller.pause();
          return false;
        }
      }
      return true;

    } catch (e) {
      debugPrint('Error checking app version: $e');
      return false;
    }
  }

  void _showUpdateDialog(BuildContext context, bool isMandatory, String appStoreUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(isMandatory ? 'Update Required' : 'Update Available'),
          content: Text(isMandatory
              ? 'Please update to the latest version to continue using the app.'
              : 'A new version is available with improvements and bug fixes.'),
          actions: [
            if (!isMandatory)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToNextScreen();
                },
                child: const Text('Later'),
              ),
            TextButton(
              onPressed: () async {
                if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
                  await launchUrl(Uri.parse(appStoreUrl));
                }
                if (isMandatory) {
                  Navigator.pop(context);
                  SystemNavigator.pop();
                }
              },
              child: const Text('Update Now'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startSplashScreen() async {
    bool valid = await _checkAppVersion();
    if(valid){
      await Future.delayed(const Duration(seconds: 3));
      _controller.pause();
      if (widget.route=='LoginPage'||widget.route=='onBoarding') {
        _navigateToNextScreen();
      } else {
        _loadAd();
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.lightColor,
      body: Center(
        child: _controller.value.isInitialized
            ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            : const Center(
                child: Image(
                  image: AssetImage('assets/img/ninja_gif.gif'),
                  height: 100,
                  width: 100,
                ),
              ), // loading placeholder
      ),
    ));
  }

  void _navigateToNextScreen() {
    if (mounted) {
      if (widget.route=='LoginPage') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else if(widget.route=='onBoarding'){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TapsPage()),
        );
      }
    }
  }

  void _loadAd() {
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-7223929122163665/9538903112',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _showAdIfLoaded();
        },
        onAdFailedToLoad: (error) {
          _navigateToNextScreen();
        },
      ),
    );
  }

  void _showAdIfLoaded() {
    if (_appOpenAd != null && !_isAdShown) {
      _isAdShown = true;
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _navigateToNextScreen();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _navigateToNextScreen();
        },
      );
      _appOpenAd!.show();
    } else {
      _navigateToNextScreen();
    }
  }
}
