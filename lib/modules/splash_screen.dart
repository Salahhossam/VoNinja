import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // 👈 import this
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vo_ninja/modules/taps_page/taps_page.dart';
import 'login_page/login_page.dart';
import '../shared/style/color.dart';

class SplashScreen extends StatefulWidget {
  final bool login;
  const SplashScreen({super.key, required this.login});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppOpenAd? _appOpenAd;
  bool _isAdShown = false;

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/intro.MP4')
      ..initialize().then((_) {
        setState(() {}); // rebuild to show video
        _controller.play(); // auto play
      });

    _startSplashScreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startSplashScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      if (widget.login) {
        _navigateToNextScreen();
      } else {
        _loadAd();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
            child: Scaffold(
      backgroundColor: AppColors.lightColor,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const Center(
                      child: Image(
                        image: AssetImage('assets/img/ninja_gif.gif'),
                        height: 100,
                        width: 100,
                      ),
                    ), // loading placeholder
      ),
  )  );
  }

  void _navigateToNextScreen() {
    if (mounted) {
      if (widget.login) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
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
