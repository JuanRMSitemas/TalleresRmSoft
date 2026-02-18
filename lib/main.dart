import 'package:flutter/material.dart';
import 'package:talleres/core/theme/theme.dart';
import 'package:talleres/features/settings/presentation/settings_page.dart';
import 'package:talleres/features/vehiculos/presentation/screens/abono_vehiculo.dart';
import 'package:talleres/features/vehiculos/presentation/screens/home_page.dart';
import 'package:talleres/features/vehiculos/presentation/screens/ingreso_vehiculo.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget 
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightMode,
      darkTheme: darkMode,
      title: 'Taller Mecanico',
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const VehiculosScreen(), // ruta principal
        '/settings': (context) => const SettingsPage(),
        '/ingresoVehiculo': (context) => IngresoVehiculoScreen(
          onVehiculoIngresado: (cliente, vehiculo, orden, servicio ) {
          debugPrint('Vehículo ingresado');
          },
        ),        
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/Abonar') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => AbonoScreen(
              ordenId: args['ordenId'],
              nombre: args['nombre'],
              estado: args['estado'], // 1 = En Taller
              vehiculo: args['vehiculo'],
              placa: args['placa'],
              ingreso: args['ingreso'],
              salidaEstimada: args['salidaEstimada'],
              servicios: args['servicios'],
              abono: args['abono'] ?? 0,
              metodoPago:  args['metodoPago'],
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Página no encontrada")),
          ),
        );
      }
    );
  }
}
