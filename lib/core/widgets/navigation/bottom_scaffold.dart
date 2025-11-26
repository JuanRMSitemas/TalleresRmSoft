import 'package:flutter/material.dart';
import 'package:talleres/core/widgets/navigation/buttom_controller.dart';

class AppBottomNavigator extends StatelessWidget {
  const AppBottomNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bottomNavController,
      builder: (_, _) {
        return BottomNavigationBar(
          currentIndex: bottomNavController.selectedIndex,
          onTap: bottomNavController.changeTab,
          selectedItemColor: const Color.fromARGB(255, 230, 168, 0),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Configuración',
            ),
          ],
        );
      },
    );
  }
}
