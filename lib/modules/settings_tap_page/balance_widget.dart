import 'package:flutter/material.dart';
import 'package:vo_ninja/modules/settings_tap_page/switch_coins.dart';
import 'package:vo_ninja/modules/settings_tap_page/technical_support_page.dart';
import 'package:vo_ninja/shared/style/color.dart';

import '../../generated/l10n.dart';
import 'about_voninja_page.dart';
import 'follow_us.dart';
import 'settings_tap_cubit/settings_tap_cubit.dart';

class BalanceSection extends StatelessWidget {
  final double userBalance;

  const BalanceSection({
    super.key,
    required this.userBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${S.of(context).totalBalance}:',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          '${userBalance.toInt()} ${S.of(context).egp}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .039,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const SwitchCoinsPage()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/img/fane.png',
                                      width: 18,
                                      height: 18,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        S.of(context).switchIcons,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                        ),
                                        overflow: TextOverflow
                                            .ellipsis, // Prevents overflow
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  S.of(context).getNewCoins,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Prevents overflow
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16), // Space between rows
          IntrinsicHeight(
            child: Row(
              children: [
                // ------- Card 1 -------
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const FollowUs()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Give the text area flex so it can wrap/ellipsize
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    S.of(context).socialMedia,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 11),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    S.of(context).followUs,
                                    maxLines: 2, // keep up to 2 lines
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_ios,
                                color: Colors.white, size: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: MediaQuery.of(context).size.width * .039),

                // ------- Card 2 -------
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: InkWell(
                      onTap: () => SettingsTapCubit.get(context)
                          .showInviteFriendDialog(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Optional: small leading space if you want
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                S.of(context).inviteFriend,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_ios,
                                color: Colors.white, size: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16), // Space between rows
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min, // <-- shrink-wrap horizontally
              children: [
                // ------- Card 1 -------
                Flexible(
                  fit: FlexFit.loose, // <-- instead of Expanded
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(minWidth: 150, maxWidth: 260),
                    child: SizedBox(
                      height: double.infinity,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const AboutVoninjaPage()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  S.of(context).aboutUs,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white, size: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: MediaQuery.of(context).size.width * .039),

                // ------- Card 2 -------
                Flexible(
                  fit: FlexFit.loose, // <-- instead of Expanded
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(minWidth: 150, maxWidth: 260),
                    child: SizedBox(
                      height: double.infinity,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const TechnicalSupportPage()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.support_agent,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  S.of(context).technicalSupport,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white, size: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
