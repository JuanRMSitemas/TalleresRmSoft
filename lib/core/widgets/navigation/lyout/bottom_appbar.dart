import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:talleres/features/settings/presentation/settings_page.dart';
//import 'package:talleres/features/vehiculos/presentation/screens/home_page.dart';

class BottomAppBarCustom extends StatelessWidget {
  const BottomAppBarCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // 👈 BLUR REAL
          child: Container(
            height: 65,
            decoration: BoxDecoration(
              color: const Color.fromARGB(33, 255, 255, 255), // 👈 ESTILO iOS
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: const Color.fromARGB(75, 255, 255, 255), // 👈 BORDE GLASSSMORPHISM
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(28, 0, 0, 0),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  color:Theme.of(context).colorScheme.primary,
                  icon: const Icon(Icons.home_filled),
                  onPressed: () {
                    // 🔥 Cambia por context.go si usas GoRouter
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                ),
                IconButton(
                  color:Theme.of(context).colorScheme.primary,
                  icon: const Icon(Icons.settings_rounded),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SettingsPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
