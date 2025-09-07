import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../shared/style/color.dart';

class AboutVoninjaPage extends StatelessWidget {
  const AboutVoninjaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return Scaffold(
      backgroundColor: AppColors.lightColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text(t.aboutUs, style: const TextStyle(
            color: AppColors.whiteColor,)),
        iconTheme: const IconThemeData(
          color: AppColors.whiteColor, // makes leading icons white
        ),
      ),
      body: Directionality(
        textDirection: Directionality.of(context), // يراعي RTL/LTR تلقائياً
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            HeaderCard(
              title: t.about_title,
              subtitle: "${t.about_intro_1}\n${t.about_intro_2}",
            ),
            const SizedBox(height: 12),
            SectionTitle(text: t.features_title),
            BulletTile(text: t.feature_interactive_lessons, icon: Icons.quiz_outlined),
            BulletTile(text: t.feature_challenges, icon: Icons.emoji_events_outlined),
            BulletTile(text: t.feature_library, icon: Icons.menu_book_outlined),
            BulletTile(text: t.feature_treasure, icon: Icons.lock_open_outlined),
            BulletTile(text: t.feature_events, icon: Icons.event_available_outlined),

            const SizedBox(height: 16),
            SectionTitle(text: t.rewards_title),
            InfoCard(
              lines: [t.rewards_intro, t.rewards_cash, t.rewards_time],
              leading: Icons.monetization_on_outlined,
            ),

            const SizedBox(height: 16),
            SectionTitle(text: t.goal_title),
            InfoCard(lines: [t.goal_body], leading: Icons.flag_outlined),
          ],
        ),
      ),
    );
  }
}
class HeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const HeaderCard({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: AppColors.secondColor, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.secondColor,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    );
  }
}

class BulletTile extends StatelessWidget {
  final String text;
  final IconData icon;
  const BulletTile({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          backgroundColor: AppColors.secondColor.withOpacity(.12),
          child: Icon(icon, color: AppColors.secondColor, size: 18),
        ),
        title: Text(text, style: const TextStyle(fontSize: 13)),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final List<String> lines;
  final IconData leading;
  const InfoCard({super.key, required this.lines, required this.leading});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(leading, color: AppColors.greenColor),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: lines.map((l) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(l, style: const TextStyle(fontSize: 13, height: 1.4)),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



