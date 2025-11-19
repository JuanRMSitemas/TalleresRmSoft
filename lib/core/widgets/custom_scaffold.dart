import 'package:flutter/material.dart';
//Aqui se crean los app bar y el menu de acciones 

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int>? onTabSelected;
  final bool showDrawer;
  final Widget? floatingActionButton; // 👈  parámetro

  const CustomScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.selectedIndex,
    this.onTabSelected,
    this.showDrawer = true,
    this.floatingActionButton, // 👈 también lo agregamos aquí
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
          fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: Colors.white,
        leading: showDrawer
        ? Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          )
        : null,
      ),
      drawer: showDrawer
        ?Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color.fromARGB(255, 0, 0, 0)),
                child: Text(
                  'Menú',
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('En Taller'),
                onTap: () {
                  // Reemplaza para evitar apilar pantallas
                  Navigator.pushReplacementNamed(context, '/');
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
        )
      : null,
      body: body,
      floatingActionButton: 
        floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (onTabSelected != null) onTabSelected!(index);
          // Si quieres navegar por rutas desde el bottom nav, podrías:
          // if (index == 0) Navigator.pushReplacementNamed(context, '/');
        },
        selectedItemColor: const Color.fromARGB(255, 103, 173, 82),
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
      ),
    );
  }
}
