import 'package:flutter/material.dart';
import 'package:vo_ninja/modules/settings_tap_page/transaction.dart';
import 'package:vo_ninja/modules/taps_page/taps_cubit/taps_cubit.dart';
import 'package:vo_ninja/shared/constant/constant.dart';
import 'package:vo_ninja/shared/style/color.dart';

import '../../generated/l10n.dart';
import '../../shared/network/local/cash_helper.dart';
import '../login_page/login_page.dart';
import 'language_selection_widget.dart';

class SettingsOptionsList extends StatelessWidget {
  final String versionNumber;

  const SettingsOptionsList({
    super.key,
    required this.versionNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            SettingsOption(
              title: S.of(context).language,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                      insetPadding: const EdgeInsets.all(
                          20), // Adjust inset padding as needed
                      content: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor, // Dark background
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondColor
                                    .withOpacity(1), // Shadow color
                                spreadRadius: 3, // Spread of the shadow
                                blurRadius: 2, // Blur effect
                              ),
                            ],
                          ),
                          child: const LanguageSelection()),
                    );
                  },
                );
              },
            ),
            Divider(color: Colors.grey[600]),
            SettingsOption(
                title: S.of(context).transaction,
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => TransactionsPage()));
                }),
            Divider(color: Colors.grey[600]),
            // SettingsOption(title: S.of(context).about, onTap: () {}),
            // Divider(color: Colors.grey[600]),
            SettingsOption(
                title: S.of(context).version,
                trailing: Text(versionNumber,
                    style: const TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }
}

class SettingsOption extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsOption({
    super.key,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(color: Colors.white, fontSize: 20)),
      trailing:
          trailing ?? const Icon(Icons.arrow_forward_ios, color: Colors.white),
      onTap: onTap,
    );
  }
}

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: loading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.white,
            )
            )
          : ElevatedButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                await firebaseAuth.signOut();
                await CashHelper.saveData(key: 'userToken', value: '');
                TapsCubit.get(context).selectTab(0);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
                setState(() {
                  loading = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(S.of(context).logout,
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
            ),
    );
  }
}
