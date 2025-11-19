import 'package:flutter/material.dart';
import 'package:talleres/features/settings/presentation/settings_page.dart';
import 'package:talleres/features/vehiculos/presentation/screens/abono_vehiculo.dart';
import 'package:talleres/features/vehiculos/presentation/screens/home_page.dart';
import 'package:talleres/features/vehiculos/presentation/screens/ingreso_vehiculo.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:talleres/features/vehiculos/domain/cliente.dart'; // ignore: unused_import
import 'package:talleres/features/vehiculos/domain/vehiculo.dart';// ignore: unused_import
import 'package:talleres/features/vehiculos/domain/orden_vehi.dart';// ignore: unused_import
import 'package:talleres/features/vehiculos/presentation/screens/trabajos_vehiculo.dart';// ignore: unused_import

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller Mecanico',
      debugShowCheckedModeBanner: false,
      locale: const Locale('es', 'ES'), // idioma español
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        '/': (context) => const VehiculosScreen(), // ruta principal
        '/settings': (context) => const SettingsPage(),
        '/ingresoVehiculo': (context) => IngresoVehiculoScreen(
          onVehiculoIngresado: (cliente, vehiculo, orden, proceso ) {
          debugPrint('Vehículo ingresado');
          },
        ),        
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/Abonar':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => AbonoScreen(
                nombre: args['nombre'],
                vehiculo: args['vehiculo'],
                placa: args['placa'],
                ingreso: args['ingreso'],
                salidaEstimada: args['salidaEstimada'],
                procesos: args['procesos'],
                metodoPago: args['metodoPago'],
              ),
            );

          case '/reparacion':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => TrabajoScreen(
                nombre: args['nombre'],
                vehiculo: args['vehiculo'],
                placa: args['placa'],
                ingreso: args['ingreso'],
                salidaEstimada: args['salidaEstimada'],
                procesos: args['procesos'],
                metodoPago: args['metodoPago'],
                costo: args['costo'],
              ),
            );
        }
        return null;
      }
    );
  }
}
void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}