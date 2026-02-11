import 'package:flutter/material.dart';
import 'package:talleres/core/widgets/navigation/lyout/bottom_appbar.dart';
import 'package:talleres/core/widgets/navigation/lyout/box.dart';
import 'package:talleres/core/widgets/navigation/lyout/menu_side.dart';
//import 'package:talleres/core/widgets/lyout/menu_side.dart';
import 'package:talleres/core/widgets/navigation/lyout/top_appbar.dart';


class MainLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final bool showDrawer;
  final bool showBottomNav;

  const MainLayout({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.showDrawer = true,
    this.showBottomNav = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        title: title,
        showDrawer: showDrawer,
      ), //titulo de la vista
      drawer: showDrawer? const SideMenu(): null, //menu lateral
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showBottomNav? const BottomAppBarCustom(): null,
      //backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Box(
        color: Theme.of(context).colorScheme.surface,
        child: body,
      ),
    );
  }
}
