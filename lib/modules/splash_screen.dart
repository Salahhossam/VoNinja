import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vo_ninja/modules/taps_page/taps_page.dart';
import 'package:vo_ninja/shared/network/end_points.dart';

import 'login_page/login_page.dart';


class SplashScreen extends StatefulWidget {
 final  bool login;
  const SplashScreen({super.key,required this.login});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  AppOpenAd? _appOpenAd;
  bool _isAdShown = false;

  @override
  void initState() {
    super.initState();
    _startSplashScreen();
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
    return Scaffold(
      backgroundColor: const Color(0xFFDDDDDD),
      body: Center(
        child: Image.asset('assets/img/intro.gif'),
      ),
    );
  }

  void _navigateToNextScreen() {
    if (mounted) {
      if(widget.login) {
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      }
      else{
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
          log('App Open Ad loaded successfully');
          _showAdIfLoaded();
        },
        onAdFailedToLoad: (error) {
          log('Failed to load App Open Ad: $error');
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
          log('App Open Ad dismissed');
          _navigateToNextScreen();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          log('Failed to show ad: $error');
          _navigateToNextScreen();
        },
      );
      _appOpenAd!.show();
    } else {
      _navigateToNextScreen();
    }
  }
}



