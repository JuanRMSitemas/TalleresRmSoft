import 'package:flutter/material.dart';

class BottomNavController extends ChangeNotifier {
  int selectedIndex = 0;

  void changeTab(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

final bottomNavController = BottomNavController();
//bottom_nav_controller.dart