import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:vo_ninja/models/pdf_book_model.dart';

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

    return PDF(
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
    );
  }
}