import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vo_ninja/shared/style/color.dart';

import 'taps_cubit/taps_cubit.dart';
import 'taps_cubit/taps_state.dart';

class TapsPage extends StatelessWidget {
  const TapsPage({super.key});



  @override
  Widget build(BuildContext context) {
    var cubit = TapsCubit.get(context);

    return BlocConsumer<TapsCubit, TapsState>(
      listener: (context, state) {
        if (state is SelectTapError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
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
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color(0xFF1A3037),
                unselectedItemColor:  const Color(0xFFDBDEDE),
                showSelectedLabels: false,
                items: <BottomNavigationBarItem>[
                  _buildNavBarItem(
                    icon: Icons.home,
                    label: 'Home',
                    isSelected: cubit.currentIndex == 0,
                  ),
                  _buildNavBarItem(
                    icon: Icons.school,
                    label: 'Challenges',
                    isSelected: cubit.currentIndex == 1,
                  ),
                  _buildNavBarItem(
                    icon: Icons.leaderboard,
                    label: 'Leaderboard',
                    isSelected: cubit.currentIndex == 2,
                  ),
                  _buildNavBarItem(
                    icon: Icons.settings,
                    label: 'Settings',
                    isSelected: cubit.currentIndex == 3,
                  ),
                ],
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                    cubit.selectTab(index);
                },
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
                      color: Color(0xFFDBDEDE), // Circle color
              ),
              child: Icon(
                icon,
                      color: const Color(0xFF1A3037), // Icon color to match the design
              ),
            )
          : Icon(icon), // Default icon
      label: label,
    );
  }
}
