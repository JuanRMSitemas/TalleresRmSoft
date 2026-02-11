import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(child: Text("Menú")),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('En Taller'),
            onTap: () {
              // Reemplaza para evitar apilar pantallas
              Navigator.popUntil(context,ModalRoute.withName('/'));
            },
          ),
          ListTile(
            leading: const Icon(Icons.car_repair),
            title: const Text('Ingreso Vehiculos'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/ingresoVehiculo');
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Agenda'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/agendar');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Agendar Cita'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/agendar');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificaciones'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/notificaciones');
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment_outlined),
            title: const Text('Informes'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/informes');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
