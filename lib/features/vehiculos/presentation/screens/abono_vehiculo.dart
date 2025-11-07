 import 'package:flutter/material.dart';
import 'package:talleres/core/widgets/custom_scaffold.dart';
import 'package:talleres/desing/text_style.dart';
import 'package:talleres/desing/buttons.dart';
import 'package:talleres/desing/date_extensions.dart';
import 'package:talleres/features/vehiculos/presentation/screens/home_page.dart';
//import 'package:talleres/features/vehiculos/domain/vehiculo.dart';
//import 'package:talleres/desing/app_colors.dart';
import 'package:intl/intl.dart';


class AbonoScreen extends StatefulWidget {
  final String nombre;
  final String vehiculo;
  final String placa;
  final DateTime? ingreso;
  final DateTime salidaEstimada;
  final List<String> procesos;
  final List<String> metodoPago;

  const AbonoScreen({
    super.key,
    required this.nombre,
    required this.vehiculo,
    required this.placa,
    required this.ingreso,
    required this.salidaEstimada,
    required this.procesos,
    required this.metodoPago,
  });

  @override
  State<AbonoScreen> createState() => _AbonoScreenState();
}
class _AbonoScreenState extends State<AbonoScreen> {
  String metodoPagoSelec = 'Seleccione el método de pago';
  final List<String> metodoPago = ['Efectivo', 'Transferencia', 'Otro'];

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
    final double valorTotal = 200000; //Valoor de los procesos
    //String metodoPagos = '';
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text( widget.nombre, //nombre que se ingresa en el formulario
            style:  TextStyles.h1
          ),
          Text(
            "${widget.vehiculo} - ${widget.placa}", //vehicuolo y placa
            style: TextStyles.h3,
          ),
          //Fechas de ingreso y estimado de salida -----------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [const Text( 
                  "Ingreso",
                  style: TextStyles.h4
                ),
                Text(
                  DateFormat('dd/MM/yy HH:mm').format(widget.ingreso ?? DateTime.now()), //guarda la fecha de ingreso en .fechaIngreso
                ),
              ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [const Text( 
                  "Salida estimada",
                  style: TextStyles.h4
                ),
                Text(
                  formatFecha(widget.salidaEstimada), //guarda la fecha de ingreso en .fechaIngreso
                ),
              ]),
            ]
          ),
          
          //Recuadro con servicios -------------
          Expanded( // cuerpo de recuadro
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(57, 167, 164, 157),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      //fila principal servicios + valor
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           // Columna izquierda: Servicios expandibles
                          Expanded(
                            flex: 2,
                            child: ExpansionTile(
                              title: const Text(
                                'Servicios',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              children: const [
                                ListTile(
                                  title: Text('Diagnóstico'),
                                ),
                              ],
                            ),
                          ),

                          // Columna derecha: valor total
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Text(
                                '\$${valorTotal.toStringAsFixed(0)}',
                                textAlign: TextAlign.center,
                                style: TextStyles.h2,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded( // cuerpo de recuadro con metodos de pago
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(110, 176, 187, 194),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text('Método de pago:', style: TextStyles.h4),

                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                        child: DropdownButton<String>(
                          value: metodoPagoSelec == 'Seleccione el método de pago' ? null : metodoPagoSelec,
                          hint: const Text('Seleccione el método de pago'),
                          isExpanded: true,
                          items: metodoPago.map((String metodo) {
                            return DropdownMenuItem<String>(
                              value: metodo,
                              child: Text(metodo),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              metodoPagoSelec = value!;
                            });
                          },
                        ),
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
              onPressed: () {
                if(metodoPagoSelec=='Seleccione un metodo de pago'){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Selecciona el metodo de pago')),
                  );
                  return;
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VehiculosScreen()
                  ),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}