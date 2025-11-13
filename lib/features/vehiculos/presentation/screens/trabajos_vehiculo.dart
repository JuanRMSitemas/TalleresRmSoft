import 'package:flutter/material.dart';
import 'package:talleres/core/widgets/custom_scaffold.dart';
import 'package:talleres/desing/text_style.dart';
import 'package:talleres/desing/date_extensions.dart'; //format para fecha
import 'package:intl/intl.dart';
import 'package:talleres/features/vehiculos/domain/procesos.dart';
import 'package:talleres/features/vehiculos/presentation/screens/abono_vehiculo.dart';


class TrabajoScreen extends StatefulWidget {
  final String nombre;
  final String vehiculo;
  final String placa;
  final DateTime? ingreso;
  final DateTime salidaEstimada;
  final List<Procesos> procesos;
  final List<String> metodoPago;
  final double costo;

  const TrabajoScreen({
    super.key,
    required this.nombre,
    required this.vehiculo,
    required this.placa,
    required this.ingreso,
    required this.salidaEstimada,
    required this.procesos,
    required this.metodoPago,
    required this.costo
  });

  @override
  State<TrabajoScreen> createState() => _TrabajoScreenState();
}

class _TrabajoScreenState extends State<TrabajoScreen> {
  final formatoMoneda = NumberFormat('#,###', 'es_CO'); // 🇨🇴 formato colombiano
  final TextEditingController _costoController = TextEditingController();
  final List<Procesos> _proceso=[];
  final TextEditingController textValor = TextEditingController();
  

  final List<Procesos> _opcionesProceso = [
    Procesos(nombre: "Cambio de cilindro", valor: 150000),
    Procesos(nombre: "Mantenimiento general", valor: 80000),
    Procesos(nombre: "Cambio de aceite", valor: 45000)

  ];

  void agregarProceso(Procesos nuevo) {
    setState(() {
      _proceso.add(nuevo);
    });
  }

  void mostrarSelectorProcesos() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return ListView(
          shrinkWrap: true,
          children: _opcionesProceso.map((proceso) {
            return ListTile(
              title: Text(proceso.nombre),
              trailing: Text('\$${proceso.valor.toStringAsFixed(0)}'),
              onTap: () {
                agregarProceso(proceso);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void eliminarProceso(int index) {
    setState(() {
      _proceso.removeAt(index);
    });
  }

  double get totalProcesos { //suma los valores de los procesos se pasa al widget para mostrar
  return _proceso.fold(0.0, (sum, item) => sum + item.valor);
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'TRABAJOS',
      selectedIndex: 0,
      onTabSelected: (i) {
        // Navegación desde el BottomNav
        if (i == 0) Navigator.pushReplacementNamed(context, '/');
        if (i == 1) Navigator.pushReplacementNamed(context, '/settings');
      },
      body: trabajosVehiculo(),
    );
  }

  Padding trabajosVehiculo(){
    double costoProc = 0;
    _costoController.text = costoProc.toString();

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
            style: TextStyles.h2,
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
                )]
              ),
            ]
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              Text(" Costo Total: ",
              style: TextStyles.h2Sub,
              ),
              SizedBox(
                width: 10,
              ),
              Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 47, 116, 73)),
                borderRadius: BorderRadius.circular(8),
                color: Colors.blueGrey[50]
              ),
              child: Column(
                children: [
                  Text(
                    '\$ ${formatoMoneda.format(totalProcesos)}',
                  style: TextStyles.h2Sub,
                  ),
                ],
              ),
            )]
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                // Encabezado de la tabla
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Proceso',
                      style: TextStyles.h2,
                    ),
                    Padding(
                      padding: EdgeInsets.only( left: 110, top: 0, right: 0, bottom : 0),
                      child: Text(
                        'Valor',
                        style: TextStyles.h2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    //Padding(padding: EdgeInsetsGeometry.infinity())
                  ],
                ),
              ]
            )
          ),
          
           // ✅ Aquí usamos Expanded para que el ListView tenga espacio limitado dentro del Column
          Expanded(
            child: ListView.builder(
              itemCount: _proceso.length,
              itemBuilder: (context, index) {
                final proceso = _proceso[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
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
                        // Valor y acciones
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('\$${proceso.valor.toStringAsFixed(0)}'),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _proceso.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ), 
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Botón para agregar procesos
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: mostrarSelectorProcesos,
              icon: const Icon(Icons.add),
              label: const Text('Agregar proceso'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async{
                final bool? confirmar = await showDialog<bool>(
                  context: context, 
                  builder: (context){
                    return AlertDialog(
                      title: const Text('Confirmación', style: TextStyles.alert,),
                      content: const Text('¿Ha finalizado todos los procesos asignados?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child:  const Text('No'),),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child:  const Text('Si'),),
                      ],
                    );
                  }
                );
                 // Verifica la respuesta del usuario
                if (confirmar == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AbonoScreen(
                        nombre: widget.nombre,
                        vehiculo: widget.vehiculo,
                        placa: widget.placa,
                        ingreso: widget.ingreso,
                        salidaEstimada: widget.salidaEstimada,
                        procesos: _proceso, // 👈 pasa la lista actual de procesos
                        metodoPago: const [], // o la lista real que uses
                      ),
                    ),
                  );
                }
              },            
              icon: const Icon(Icons.task),
              label: const Text('Finalizar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 104, 0, 0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
     ),
    );
  }
}