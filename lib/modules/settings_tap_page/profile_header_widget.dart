import 'package:flutter/material.dart';
import 'package:vo_ninja/shared/style/color.dart';

import '../../generated/l10n.dart';
import 'edit_profile.dart';

class ProfileHeader extends StatelessWidget {
  final String userAvatar;
  final String userName;
  final String firstName;

  const ProfileHeader({
    super.key,
    required this.userAvatar,
    required this.userName,
    required this.firstName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
              backgroundColor: AppColors.lightColor,

                    backgroundImage: AssetImage(userAvatar),
                  ),
                  const SizedBox(width: 10),
                  Expanded(  // Ensures the text doesn’t exceed the available space
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis, // Prevents text overflow
                        ),
                        Text(
                          '@$userName',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis, // Prevents text overflow
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const EditProfilePage()));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: AppColors.secondColor,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(S.of(context).edit,
                      style: const TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }
}
