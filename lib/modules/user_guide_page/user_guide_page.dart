import 'package:flutter/material.dart';
import '../../shared/style/color.dart';        // عدّل المسار حسب مشروعك
import '../../generated/l10n.dart';           // عدّل المسار حسب مشروعك

class UserGuidePage extends StatelessWidget {
  const UserGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return Scaffold(
      backgroundColor: AppColors.lightColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text(
          t.userGuide,
          style: const TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeaderCard(
            title: t.userGuide_headerTitle,
            subtitle: t.userGuide_headerSubtitle,
          ),
          const SizedBox(height: 12),

          // Sections 1..11
          _GuideSectionCard(number: "1", title: t.ug_1_title, body: t.ug_1_body),
          _GuideSectionCard(number: "2", title: t.ug_2_title, body: t.ug_2_body),
          _GuideSectionCard(number: "3", title: t.ug_3_title, body: t.ug_3_body),
          _GuideSectionCard(number: "4", title: t.ug_4_title, body: t.ug_4_body),
          _GuideSectionCard(number: "5", title: t.ug_5_title, body: t.ug_5_body),
          _GuideSectionCard(number: "6", title: t.ug_6_title, body: t.ug_6_body),
          _GuideSectionCard(number: "7", title: t.ug_7_title, body: t.ug_7_body),
          _GuideSectionCard(number: "8", title: t.ug_8_title, body: t.ug_8_body),

          // 9 & 10 with images
          _GuideSectionCard(
            number: "9",
            title: t.ug_9_title,
            body: t.ug_9_body,
            imageAssets: const [
              'assets/img/ug_social_codes_1.jpeg',
              'assets/img/ug_social_codes_2.jpeg',
            ],
            imageAlts: [t.ug_image_alt_social, t.ug_image_alt_social],
          ),
          _GuideSectionCard(
            number: "10",
            title: t.ug_10_title,
            body: t.ug_10_body,
            imageAssets: const [
              'assets/img/ug_cashout_1.jpeg',
              'assets/img/ug_cashout_2.jpeg',
            ],
            imageAlts: [t.ug_image_alt_cashout, t.ug_image_alt_cashout],
          ),


          _GuideSectionCard(number: "11", title: t.ug_11_title, body: t.ug_11_body),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const _HeaderCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.mainColor, AppColors.secondColor],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 8),
          Text(subtitle,
              style: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 14,
              )),
        ],
      ),
    );
  }
}

class _GuideSectionCard extends StatelessWidget {
  final String number;
  final String title;
  final String body;
  final List<String>? imageAssets; // NEW: أكثر من صورة
  final List<String>? imageAlts;   // NEW: Alt لكل صورة (اختياري)

  const _GuideSectionCard({
    required this.number,
    required this.title,
    required this.body,
    this.imageAssets,
    this.imageAlts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Card(
      color: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.secondColor, width: 1),
                  ),
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: AppColors.secondColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.mainColor,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Body
            _BulletedBodyText(body: body, isRTL: isRTL),

            // Images gallery (اختياري)
            if (imageAssets != null && imageAssets!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _ImagesGallery(assets: imageAssets!, alts: imageAlts),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImagesGallery extends StatelessWidget {
  final List<String> assets;
  final List<String>? alts;
  const _ImagesGallery({required this.assets, this.alts});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final twoCols = constraints.maxWidth >= 420 && assets.length > 1;
        final cross = twoCols ? 2 : 1;

        return GridView.builder(
          itemCount: assets.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cross,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 6 / 9,
          ),
          itemBuilder: (context, i) {
            final alt = (alts != null && i < alts!.length) ? alts![i] : '';
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                assets[i],
                fit: BoxFit.fill,
                errorBuilder: (ctx, err, stack) {
                  return Container(
                    color: AppColors.lightColor,
                    alignment: Alignment.center,
                    child: Text(
                      alt,
                      style: const TextStyle(color: AppColors.mainColor),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}


class _BulletedBodyText extends StatelessWidget {
  final String body;
  final bool isRTL;
  const _BulletedBodyText({required this.body, required this.isRTL});

  @override
  Widget build(BuildContext context) {
    // يدعم السطور العادية + السطور التي تبدأ بالرمز "•"
    final lines = body.split('\n').where((e) => e.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        final isBullet = line.trimLeft().startsWith('•');
        if (!isBullet) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(line, textAlign: TextAlign.start),
          );
        }
        final text = line.replaceFirst('•', '').trimLeft();
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // نقطة التعداد
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.secondColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(text, textAlign: TextAlign.start)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
