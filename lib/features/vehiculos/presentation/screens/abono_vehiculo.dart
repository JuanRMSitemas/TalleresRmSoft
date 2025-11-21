import 'package:flutter/material.dart';
import 'package:talleres/core/widgets/custom_scaffold.dart';
import 'package:talleres/desing/text_style.dart';
import 'package:talleres/desing/buttons.dart'; 
import 'package:talleres/desing/date_extensions.dart'; //format para fecha
import 'package:talleres/features/vehiculos/domain/procesos.dart';
import 'package:talleres/features/vehiculos/presentation/screens/home_page.dart';
import 'package:intl/intl.dart';
import 'package:talleres/desing/spacing_responsive.dart';

class AbonoScreen extends StatefulWidget {
  final String nombre;
  final String vehiculo;
  final String placa;
  final DateTime? ingreso;
  final DateTime? salidaEstimada;
  final List<Procesos> procesos;
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
    double total = widget.procesos.fold(0, (sum, p) => sum + p.valor);
    final formato = NumberFormat("#,##0.00", "es_CO");
    //String metodoPagos = '';
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                  formatFecha(widget.salidaEstimada ?? DateTime.now()), //guarda la fecha de ingreso en .fechaIngreso
                ),
              ]),
            ]
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 160,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [const Text( 
                  "Proceso",
                  style: TextStyles.h4
                ),
              ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [const Text( 
                  "Valor",
                  style: TextStyles.h4
                ),
              ]),
            ]
          ),
          //Recuadro con Procesos realizados -------------
          Expanded( // cuerpo de recuadro Servicios o Procesos
            child: ListView.builder(
              itemCount: widget.procesos.length,
              itemBuilder: (context,index) {
                final proceso = widget.procesos[index];
                return Card(
                  //margin: const EdgeInsets.symmetric(vertical: 5),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nombre del proceso
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  proceso.nombre,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  ('\$ ${proceso.valor.toStringAsFixed(0)}'),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    )
                  )                  
                );
              }
            ),
          ),
          Row(
            children: [
              // Columna izquierda con padding
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Total",
                      style: TextStyles.h4Color,
                    ),
                  ],
                ),
              ),

              // Espaciador flexible que empuja la segunda columna
              const Spacer(flex: 2),
              
              // Columna derecha (más hacia el centro)
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$ ${formato.format(total)}',
                      style: TextStyles.h4Color,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded( // cuerpo de recuadro con metodos de pago
            child: Padding(
              padding: AppSpacing.screenPadding(context, ),
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
                      const SizedBox(height: 10),
                      const Text('Método de pago:', style: TextStyles.h4),
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
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/'),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}

