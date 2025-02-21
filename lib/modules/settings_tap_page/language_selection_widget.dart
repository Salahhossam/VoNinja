import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vo_ninja/shared/main_cubit/cubit.dart';
import 'package:vo_ninja/shared/style/color.dart';
import '../../shared/main_cubit/states.dart';

class LanguageSelection extends StatelessWidget {
  const LanguageSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final mainAppCubit = MainAppCubit.get(context);

    return BlocBuilder<MainAppCubit, MainAppState>(
      builder: (BuildContext context, MainAppState state) {
        final selectedLanguage = mainAppCubit.language == 'en' ? 'English' : 'العربية';
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.language, color: Colors.white),
              const SizedBox(width: 20),
              DropdownButton<String>(
                dropdownColor: AppColors.mainColor,
                value: selectedLanguage,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                items: <String>['English', 'العربية'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    String langCode = newValue == 'English' ? 'en' : 'ar';
                    mainAppCubit.changeLanguage(langCode);
                  }
                },
                underline: Container(),
              ),
            ],
          ),
        );
      },
    );
  }
}
  
