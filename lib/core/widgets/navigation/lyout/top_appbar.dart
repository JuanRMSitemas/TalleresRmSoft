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
    return AppBar(
        title: Text(
          title,
          style: TextStyles.scaffoldTitle,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        //foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: showDrawer
        ?IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(), 
          icon:  const Icon(Icons.menu))
        : null,
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
