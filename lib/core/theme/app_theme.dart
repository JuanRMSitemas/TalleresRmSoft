import 'package:flutter/material.dart';
import 'package:talleres/core/theme/app_colors.dart';

class AppTheme{
  static ThemeData getTheme(bool isDarkMode){
    return ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme(
        brightness: isDarkMode ? Brightness.dark : Brightness.light, 
        primary: isDarkMode ? AppColors.screensDark : AppColors.screensLight,
        onPrimary: isDarkMode ? AppColors.buttonYellow : AppColors.screensLight, 
        secondary:isDarkMode? AppColors.sondary: AppColors.primaryLight, 
        onSecondary: isDarkMode? AppColors.screensDark: AppColors.screensLight, 
        error: isDarkMode ? Colors.red.shade400 : Colors.red.shade700, 
        onError: isDarkMode ? Colors.white : Colors.white, 
        surface: isDarkMode ? AppColors.screensDark : AppColors.screensLight, 
        onSurface: isDarkMode ? AppColors.screensLight : AppColors.screensDark,
      ),
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkMode ? const Color.fromARGB(255, 48, 48, 48) : const Color.fromARGB(255, 22, 22, 22),
        foregroundColor: isDarkMode ? Colors.white : Colors.white,
      ),
    );
  }
}