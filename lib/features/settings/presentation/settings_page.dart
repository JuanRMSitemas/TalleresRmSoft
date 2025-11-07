import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:talleres/core/widgets/custom_scaffold.dart';
import 'package:talleres/desing/text_style.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false; // Estado para el modo oscuro
  String _language= "es";
  double _fontSize = 16.0; // Estado para el tamaño de letra (inicial en 16)

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
        child: ListView( // Cambié Column a ListView para mejor scroll si hay mucho contenido
          children: [
            // Opción principal: Visibilidad
            ExpansionTile(
              title: const Text(
                'Visibilidad',
                style: TextStyles.h3,
              ),
              children: [
                // Sub-opción: Modo oscuro
                ListTile(
                  title: const Text('Cambiar a modo oscuro'),
                  trailing: Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                        // Aquí podrías integrar con un ThemeProvider para cambiar el tema global
                        // Ejemplo: ThemeProvider.of(context).toggleTheme();
                      });
                    },
                  ),
                ),
                // Sub-opción: Tamaño de letra
                ListTile(
                  title: const Text('Cambiar tamaño de la letra'),
                  subtitle: Slider(
                    value: _fontSize,
                    min: 10.0,
                    max: 30.0,
                    divisions: 20,
                    label: _fontSize.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                        // Aquí podrías aplicar el tamaño a TextStyles globales o al contexto
                      });
                    },
                  ),
                ),
              ],
            ),
            // Opción principal: Usuarios Activos
            ExpansionTile(
              title: const Text(
                'Usuarios Activos',
                style: TextStyles.h3,
              ),
              children: [
                // Sub-opción: Modo oscuro (igual que arriba)
                ListTile(
                  title: const Text('Cambiar a modo oscuro'),
                  trailing: Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                        // Integrar con ThemeProvider si es necesario
                      });
                    },
                  ),
                ),
                // Sub-opción: Tamaño de letra (igual que arriba)
                ListTile(
                  title: const Text('Cambiar tamaño de la letra'),
                  subtitle: Slider(
                    value: _fontSize,
                    min: 10.0,
                    max: 30.0,
                    divisions: 20,
                    label: _fontSize.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                        // Aplicar cambios globales si es necesario
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}