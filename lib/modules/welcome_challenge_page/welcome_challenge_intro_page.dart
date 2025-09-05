import 'package:flutter/material.dart';
import 'package:vo_ninja/modules/welcome_challenge_page/welcome_challenge_cubit/welcome_challenge_cubit.dart';
import 'package:vo_ninja/modules/welcome_challenge_page/welcome_challenge_page.dart';
import '../../shared/style/color.dart';
import '../../generated/l10n.dart'; // مهم



class WelcomeChallengeIntroPage extends StatelessWidget {
  const WelcomeChallengeIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = WelcomeChallengeCubit.get(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.lightColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ======= Header =======
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 90),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1A3037), // main
                          Color(0xFF206E7D), // tint of second
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // عنوان
                        Text(
                          S.of(context).intro_appBarTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // سطر تعريفي
                        Text(
                          S.of(context).intro_title,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // أفاتار / صورة في النص
                  Positioned.fill(
                    top: null,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.translate(
                        offset: const Offset(0, 40),
                        child: Container(
                          height: 96,
                          width: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.15),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage('assets/img/avatar7.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 56),

              // ======= Content Card =======
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.06),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _RuleTile(
                        icon: Icons.check_circle_rounded,
                        text: S.of(context).intro_bullet_all_questions,
                      ),
                      const SizedBox(height: 8),
                      _RuleTile(
                        icon: Icons.timer_rounded,
                        text: S.of(context).intro_bullet_five_minutes,
                      ),
                      const SizedBox(height: 8),
                      _RuleTile(
                        icon: Icons.local_fire_department_rounded,
                        text: S.of(context).intro_bullet_reward,
                      ),

                      const SizedBox(height: 18),

                      // Chips: الوقت + النقاط
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.access_time_filled_rounded,
                            label: '05:00',
                            sub: S.of(context).intro_bullet_five_minutes,
                          ),
                          const SizedBox(width: 10),
                          const _InfoChip(
                            icon: Icons.stars_rounded,
                            label: '500',
                            sub: 'Points',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ======= CTA Button =======
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () async {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const WelcomeChallengePage()),
                            (route) => false,
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                    label: Text(
                      S.of(context).intro_startButton,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RuleTile extends StatelessWidget {
  final IconData icon;
  final String text;
  const _RuleTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: AppColors.secondColor.withOpacity(.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.secondColor, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.45,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2E2E2E),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? sub;
  const _InfoChip({required this.icon, required this.label, this.sub});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF262B2E) : const Color(0xFFF6F7F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF2E2E2E) : const Color(0xFFE9ECEF),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.mainColor),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    )),
                // if (sub != null)
                //   Text(sub!,
                //       style: TextStyle(
                //         fontSize: 11.5,
                //         color: Colors.black.withOpacity(.55),
                //       )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

