import 'package:flutter/material.dart';
import 'package:talleres/core/theme/app_colors.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: AppColors.screensLight,  //color de fondo de las pantallas
    onPrimary: AppColors.appBarLight, //color de fondo en appbar
    primary: const Color.fromARGB(255, 0, 115, 168),  //color principal de la app
    secondary: AppColors.componentLight, //color secundario de la app
    error: AppColors.error, //color para errores
  ),
);
  

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: AppColors.screensDark,
    onPrimary: AppColors.appBarDark,
    primary: const Color.fromARGB(255, 95, 149, 211),
    secondary: AppColors.primaryDark,
    error: AppColors.error,
  ),
);