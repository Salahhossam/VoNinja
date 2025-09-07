import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import '../../generated/l10n.dart';
import '../../shared/style/color.dart';
import 'about_voninja_page.dart';

class TechnicalSupportPage extends StatelessWidget {
  const TechnicalSupportPage({super.key});

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $uri');
    }
  }

  Future<void> _launchWhatsApp(String phoneRaw) async {
    final phone = phoneRaw.replaceAll('+', '').replaceAll(' ', '');
    final uri = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $uri');
    }
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).copied ?? 'Copied')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.lightColor,
      
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    // --------- HERO / BANNER ---------
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.mainColor, AppColors.secondColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.support_title, // 🛠️ Technical Support
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            t.support_intro,
                            style: Colors.white70.textStyle,
                          ),
                          const SizedBox(height: 16),
                          // Quick Actions
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.mainColor,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  icon: const Icon(Icons.email_outlined),
                                  label: Text(t.support_email_label),
                                  onPressed: () => _launchEmail(t.support_email_value),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF25D366), // واتساب
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  icon: const FaIcon(FontAwesomeIcons.whatsapp),
                                  label: Text(t.support_whatsapp_label),
                                  onPressed: () => _launchWhatsApp(t.support_whatsapp_value),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
      
                    // --------- CONTENT ---------
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // HeaderCard
                          _HeaderCard(
                            title: t.support_title,
                            subtitle: t.support_intro,
                          ),
                          const SizedBox(height: 12),
      
                          // Email Card
                          _ContactCard(
                            iconBg: AppColors.secondColor.withOpacity(.12),
                            icon: const Icon(Icons.email_outlined, color: Colors.blue),
                            title: t.support_email_label,
                            subtitle: t.support_email_value,
                            trailing: const Icon(Icons.arrow_outward, size: 18, color: AppColors.mainColor),
                            onTap: () => _launchEmail(t.support_email_value),
                            onCopy: () => _copyToClipboard(context, t.support_email_value),
                          ),
      
                          // WhatsApp Card
                          _ContactCard(
                            iconBg: const Color(0xFF25D366).withOpacity(.12),
                            icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366)),
                            title: t.support_whatsapp_label,
                            subtitle: t.support_whatsapp_value,
                            trailing: const Icon(Icons.arrow_outward, size: 18, color: AppColors.mainColor),
                            onTap: () => _launchWhatsApp(t.support_whatsapp_value),
                            onCopy: () => _copyToClipboard(context, t.support_whatsapp_value),
                          ),
      
                          const SizedBox(height: 12),
                          InfoCard(
                            lines: [t.support_note],
                            leading: Icons.info_outline,
                          ),
      
                          const SizedBox(height: 20),
      
                          // --------- FAQ ---------
                          SectionTitle(text: t.faq_title ?? 'FAQ'),
                          const SizedBox(height: 8),
                          _FaqItem(
                            question: t.faq_q1 ?? 'How fast do you respond?',
                            answer: t.faq_a1 ??
                                'We usually reply within a few hours. During events and peak times, it may take a little longer.',
                          ),
                          _FaqItem(
                            question: t.faq_q2 ?? 'What info should I include in my message?',
                            answer: t.faq_a2 ??
                                'Please share your device type, app version, and a brief description or a screenshot of the issue.',
                          ),
                          _FaqItem(
                            question: t.faq_q3 ?? 'Can I contact you outside business hours?',
                            answer: t.faq_a3 ??
                                'Yes, messages are accepted 24/7. Our team will get back to you in the next available window.',
                          ),
      
                          const SizedBox(height: 24),
      
                          // --------- FOOTER / SPACER ---------
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                'Voninja • ${DateTime.now().year}',
                                style: TextStyle(
                                  color: AppColors.mainColor.withOpacity(.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ===================== Reusable Widgets =====================

class _HeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const _HeaderCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDeco(context),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                color: AppColors.secondColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(fontSize: 13, height: 1.45)),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final Color iconBg;
  final Widget icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;
  final VoidCallback onCopy;

  const _ContactCard({
    super.key,
    required this.iconBg,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDeco(context),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: iconBg,
          child: icon,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: S.of(context).copy,
              icon: const Icon(Icons.copy, size: 18),
              onPressed: onCopy,
            ),
            const SizedBox(width: 6),
            trailing,
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}





class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDeco(context),
      margin: const EdgeInsets.only(bottom: 10),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: AppColors.secondColor.withOpacity(.08),
          highlightColor: AppColors.secondColor.withOpacity(.05),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          title: Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          children: [
            Text(
              answer,
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _cardDeco(BuildContext context) {
  return BoxDecoration(
    color: AppColors.whiteColor,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

extension on Color {
  TextStyle get textStyle => TextStyle(color: this, fontSize: 13);
}
