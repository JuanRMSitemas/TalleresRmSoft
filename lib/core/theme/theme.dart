import 'package:flutter/material.dart';
import 'package:talleres/core/theme/app_colors.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: const Color.fromARGB(255, 66, 167, 66),
    primary: AppColors.primaryLight,
    secondary: AppColors.sondary,
  ),
);
  

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: AppColors.screensDark,
    primary: AppColors.componentDark,
    secondary: AppColors.sondary,
  ),
);