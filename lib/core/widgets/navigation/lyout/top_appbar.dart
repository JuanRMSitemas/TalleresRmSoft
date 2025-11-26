import 'package:flutter/material.dart';
import 'package:talleres/core/widgets/navigation/lyout/menu_side.dart';
import 'package:talleres/desing/text_style.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showDrawer;

  const TopAppBar({super.key, 
  required this.title,
  this.showDrawer = true
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyles.scaffoldTitle,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: showDrawer? 
          Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            )
          : null,
      ),
      drawer: showDrawer? const SideMenu(): null, //menu lateral
    );
    
    
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
