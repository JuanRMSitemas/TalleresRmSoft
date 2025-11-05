 import 'package:flutter/material.dart';
import 'package:talleres/core/widgets/custom_scaffold.dart';
import 'package:talleres/desing/app_colors.dart';
import 'package:talleres/desing/text_style.dart';
import 'package:talleres/desing/buttons.dart';
import 'package:talleres/features/vehiculos/domain/vehiculo.dart';
import 'package:talleres/desing/date_extensions.dart';


class AbonoScreen extends StatelessWidget {
  final String nombre;
  final String vehiculo;
  final String placa;
  final DateTime? ingreso;
  final DateTime salidaEstimada;
  final List<String> procesos;
  final String metodoPago;

  const AbonoScreen({
    super.key, 
    required this.nombre, 
    required this.vehiculo, 
    required this.ingreso, 
    required this.salidaEstimada, 
    required this.placa, 
    required this.procesos, 
    required this.metodoPago});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'ABONO',
      selectedIndex: 0,
      onTabSelected: (i) {
        // Navegación desde el BottomNav
        if (i == 0) Navigator.pushReplacementNamed(context, '/');
        if (i == 1) Navigator.pushReplacementNamed(context, '/settings');
      },
      body: datosCliente(),
    );
  }

  Padding datosCliente() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text( nombre, //nombre que se ingresa en el formulario
            style:  TextStyles.h1
          ),
          Text("$vehiculo - $placa", //vehicuolo y placa
          style: TextStyles.bodyText ),
          Text(
            formatFecha(DateTime.now()), //guarda la fecha de ingreso en .fechaIngreso
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            'salidaEstimada'
          ),
          //Text(tra),
          Expanded( // cuerpo de recuadro
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(108, 150, 148, 142),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [ Text(nombre),

                      const SizedBox(height: 10),

                      // Listado plegable
                      ExpansionTile(
                        title: const Text(
                          'Procesos del Vehículo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children: const [
                          ListTile(
                            leading: Icon(Icons.build),
                            title: Text('Diagnóstico'),
                            subtitle: Text('Revisión inicial del vehículo'),
                          ),
                          ListTile(
                            leading: Icon(Icons.settings),
                            title: Text('Reparación'),
                            subtitle: Text('Procedimientos mecánicos y técnicos'),
                          ),
                          ListTile(
                            leading: Icon(Icons.check_circle),
                            title: Text('Entrega'),
                            subtitle: Text('Vehículo listo para recoger'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: Buttons(
              text: 'Guardar',
              onPressed: () {},
            ),
          ),
        ],
      )
    );
  }
}