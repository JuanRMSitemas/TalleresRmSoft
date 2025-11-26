import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class Buttons extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const Buttons({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, 
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: AppColors.BackgrounLight,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}