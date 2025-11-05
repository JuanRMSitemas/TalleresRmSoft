import 'package:flutter/material.dart';

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
          backgroundColor: color ?? Theme.of(context).primaryColor,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}