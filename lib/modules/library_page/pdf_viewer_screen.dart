import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vo_ninja/models/pdf_book_model.dart';

import '../../shared/main_cubit/cubit.dart';
import '../../shared/style/color.dart';

class PDFScreen extends StatefulWidget {
  final PdfBook pdfBook;

  const PDFScreen({super.key, required this.pdfBook});

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  bool _isLoading = true;
  String? _error;
  BannerAd? myBannerTop;
  BannerAd? myBannerBottom;
  bool isTopBannerLoaded = false;
  bool isBottomBannerLoaded = false;
  void _initBannerAds() {
    // Top Banner
    myBannerTop = BannerAd(
      adUnitId: 'ca-app-pub-7223929122163665/1831803488', // استبدل بمعرف وحدة الإعلان الخاصة بك
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isTopBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // print('Failed to load a banner ad: ${error.message}');
          // print('Error code: ${error.code}');
          // print('Error domain: ${error.domain}');
          ad.dispose();
        },
      ),
    )..load();

    // Bottom Banner
    myBannerBottom = BannerAd(
      adUnitId: 'ca-app-pub-7223929122163665/1831803488', // استبدل بمعرف وحدة الإعلان الخاصة بك
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isBottomBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // print('Failed to load a banner ad: ${error.message}');
          // print('Error code: ${error.code}');
          // print('Error domain: ${error.domain}');
          ad.dispose();
        },
      ),
    )..load();
  }
  @override
  void initState() {
    super.initState();
    final mainCubit = MainAppCubit.get(context);
    mainCubit.interstitialAd();
    _initBannerAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightColor,
      appBar: AppBar(
        title: Text(
          widget.pdfBook.title ?? 'PDF Viewer',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildPDFView(widget.pdfBook.url),
    );
  }

  Widget _buildPDFView(String? url) {
    if (url == null || url.isEmpty) {
      return const Center(
        child: Text('PDF URL is empty'),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Failed to load PDF:\n$_error'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _error = null;
                  _isLoading = true;
                });
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.mainColor),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (isTopBannerLoaded && myBannerTop != null)
          Container(
            height: 60,
            width: double.infinity,
            alignment: Alignment.center,
            child: AdWidget(ad: myBannerTop!),
          ),
        Expanded(
          child: PDF(
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: true,
            onError: (error) {
              setState(() {
                _error = error.toString();
              });
            },
            onPageError: (page, error) {
              setState(() {
                _error = '$page: ${error.toString()}';
              });
            },
            onRender: (pages) {
              setState(() {
                _isLoading = false;
              });
            },
          ).cachedFromUrl(
            url,
            placeholder: (progress) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('assets/img/ninja_gif.gif'),
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 20),
                  Text('Loading... $progress%'),
                ],
              ),
            ),
          ),
        ),

        if (isBottomBannerLoaded && myBannerBottom != null)
          Container(
            height: 60,
            width: double.infinity,
            alignment: Alignment.center,
            child: AdWidget(ad: myBannerBottom!),
          ),
      ],
    );
  }
}