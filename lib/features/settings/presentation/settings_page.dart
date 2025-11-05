import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:talleres/core/widgets/custom_scaffold.dart';
import 'package:talleres/desing/text_style.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'CONFIGURACÍON',
      selectedIndex: 1,
       onTabSelected: (i) {
        // Navegación desde el BottomNav
        if (i == 0) Navigator.pushReplacementNamed(context, '/');
        if (i == 1) Navigator.pushReplacementNamed(context, '/settings');
      },
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Editanding",
              style: TextStyles.bodyText,
            ),
          ],
        )
      ),
    );
  }
}