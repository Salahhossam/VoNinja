import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vo_ninja/shared/style/color.dart';
import '../../generated/l10n.dart';
import 'taps_cubit/taps_cubit.dart';
import 'taps_cubit/taps_state.dart';


class TapsPage extends StatelessWidget {
  const TapsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = TapsCubit.get(context);
    final s = S.of(context); // <-- convenience

    return BlocConsumer<TapsCubit, TapsState>(
      listener: (context, state) {
        if (state is SelectTapError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(s.select_tap_error)), // localized
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.lightColor,
            body: cubit.pages[cubit.currentIndex],
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: BottomNavigationBar(
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color(0xFF1A3037),
                unselectedItemColor: const Color(0xFFDBDEDE),
                selectedItemColor: AppColors.secondColor,
                showSelectedLabels: true,
                items: <BottomNavigationBarItem>[
                  _buildNavBarItem(
                    icon: Icons.home,
                    label: s.nav_home,           // <-- localized
                    isSelected: cubit.currentIndex == 0,
                  ),
                  _buildNavBarItem(
                    icon: Icons.school,
                    label: s.nav_learn,     // <-- localized
                    isSelected: cubit.currentIndex == 1,
                  ),
                  _buildNavBarItem(
                    icon: Icons.leaderboard,
                    label: s.nav_leaderboard,    // <-- localized
                    isSelected: cubit.currentIndex == 2,
                  ),
                  _buildNavBarItem(
                    icon: Icons.diamond,
                    label: s.nav_treasure,       // <-- localized
                    isSelected: cubit.currentIndex == 3,
                  ),
                  _buildNavBarItem(
                    icon: Icons.settings,
                    label: s.nav_settings,       // <-- localized
                    isSelected: cubit.currentIndex == 4,
                  ),
                ],
                currentIndex: cubit.currentIndex,
                onTap: (index) => cubit.selectTab(index),
              ),
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavBarItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: isSelected
          ? Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFDBDEDE),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF1A3037),
        ),
      )
          : Icon(icon),
      label: label,
    );
  }
}
