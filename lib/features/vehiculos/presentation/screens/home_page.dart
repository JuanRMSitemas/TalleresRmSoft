import 'package:flutter/material.dart';
import 'package:talleres/core/widgets/navigation/main_layout.dart';
import 'package:talleres/model/servicio.dart';
import 'package:talleres/features/vehiculos/presentation/screens/abono_vehiculo.dart';
import 'package:talleres/features/vehiculos/presentation/screens/entregar_vehiculo.dart';
import 'package:talleres/features/vehiculos/presentation/screens/trabajos_vehiculo.dart';
import '../../../../model/vehiculo.dart';
import 'ingreso_vehiculo.dart';
import 'package:talleres/desing/date_extensions.dart';
import 'package:talleres/model/orden.dart';
import 'package:talleres/model/cliente.dart';
import 'package:talleres/desing/text_style.dart';

class VehiculosScreen extends StatefulWidget {
  const VehiculosScreen({super.key});

  @override
  VehiculosScreenState createState() => VehiculosScreenState();
}

class VehiculosScreenState extends State<VehiculosScreen> {
  final List<Cliente> _cliente = [];
  final List<Vehiculo> _vehiculos = [];
  final List<Orden> _orden = []; 
  final List<Servicio> _servicio = [];
  int selectedIndex = 0;

  void _agregarVehiculo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IngresoVehiculoScreen(
          onVehiculoIngresado: (Cliente cliente, Vehiculo vehiculo, Orden orden, Servicio servicio) {
            setState(() {
              _cliente.add(cliente);
              _vehiculos.add(vehiculo);
              _orden.add(orden);
              _servicio.add(servicio);
            });
          },
        ),
      ),
    );
  }

  void _eliminarVehiculo(int index) {
    setState(() {
      _vehiculos.removeAt(index);
    });
  }

 @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'En Taller',
      floatingActionButton: FloatingActionButton( // + INGRESAR VEHICULO
        onPressed: _agregarVehiculo,
        tooltip: 'Agregar vehículo',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
      //showDrawer: false,
      // showBottomNav: true,
      body: tablavehiculos(),
    );
  }

 Padding tablavehiculos() {
   return Padding(
      padding: const EdgeInsets.all(0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          //Calculamos ancho total disponible para repartir entre columnas
          //double totalWidth = constraints.maxWidth; //411.428
          //double colWidth = totalWidth / 5; // 4 columnas
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal, //permite desplazamiento lateral
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth, //asegura que la tabla tenga mínimo el ancho de la pantalla
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, //permite scroll vertical si hay muchas filas
                child: DataTable(
                  columnSpacing: 0, // Espacio entre columnas (puedes ajustar)
                  columns: const [
                    DataColumn(label: Text('Placa',style: TextStyles.h4,)),
                    DataColumn(label: Text('Vehículo',style: TextStyles.h4,)),
                    DataColumn(label: Text('Ingreso',style: TextStyles.h4,)),
                    DataColumn(label: Text('Estado',style: TextStyles.h4,)),
                    DataColumn(label: Text('')),
                  ],
                  rows: _vehiculos.isEmpty
                  ? [
                    const DataRow(
                      cells: [
                      DataCell(Text('____')),
                      DataCell(Text('____')),
                      DataCell(Text('____')),
                      DataCell(Text('____')),
                      DataCell(Text('____')),
                    ]),
                  ]
                  : List.generate(_vehiculos.length, (index) {
                    final transporte = _vehiculos[index];
                     final ordenVehi = _orden[index];
                     final clienteV = _cliente[index];

                    return DataRow(
                      cells: [
                      //Placa
                      DataCell(
                        SizedBox(
                        child: Text(
                          transporte.placa,
                          overflow: TextOverflow.ellipsis, //evita que el texto se salga
                          maxLines: 1,
                        ),
                      )),
                      //tipo de vehiculo
                      DataCell(
                        SizedBox(
                        // width: colWidth,
                        child: Text(
                          transporte.tipo,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )),
                      //columna de Fecha ingresp
                      DataCell(
                        SizedBox(
                        // width: colWidth,
                        child: Text(
                          formatFecha(ordenVehi.fechaIngreso!), //guarda la fecha de ingreso en .fechaIngreso
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )),
                      // Aquí va la columna de estado
                      DataCell(
                        SizedBox(
                          child: PopupMenuButton<String>(//-------------------------Valores ficticios
                            onSelected: (value) {
                              final rutas = {
                                'Abonar': AbonoScreen(
                                  nombre: clienteV.nombre,
                                  vehiculo: transporte.tipo,
                                  ingreso: ordenVehi.fechaIngreso,
                                  salidaEstimada: ordenVehi.fechaEstimada,
                                  placa: transporte.placa,
                                  servicios: [],
                                  metodoPago: ordenVehi.metodoPago,
                                ),
                                'reparacion': TrabajoScreen(
                                  nombre: clienteV.nombre,
                                  numId: clienteV.numeroId,
                                  vehiculo: transporte.tipo,
                                  ingreso: ordenVehi.fechaIngreso,
                                  salidaEstimada: ordenVehi.fechaEstimada,
                                  placa: transporte.placa,
                                  servicios: [],
                                  //metodoPago:[],
                                  costo: ordenVehi.costo,
                                ),
                                'entregas': EntregarVehiculo(
                                  nombre: clienteV.nombre,
                                  celular: clienteV.celular,
                                  correo: clienteV.email,
                                  vehiculo: transporte.tipo,
                                  ingreso: ordenVehi.fechaIngreso,
                                  salidaEstimada: ordenVehi.fechaEstimada!,
                                  placa: transporte.placa,
                                  servicios: [],
                                  metodoPago:[],
                                  notas: ordenVehi.notasIngreso,
                                  valorTotal: 0,
                                )
                              };
                              final destino = rutas[value];
                              if(destino != null){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => destino),
                                );
                              }
                            },
                            itemBuilder: (context) => [ //Opciones en Estado
                              PopupMenuItem(
                                value: 'Abonar',
                                child: Row(
                                  children: const [
                                    Icon(Icons.monetization_on, color: Color.fromARGB(255, 84, 150, 23),),
                                    SizedBox(width: 4),
                                    Text('Abonos')
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'reparacion',
                                child: Row(
                                  children: const [
                                    Icon(Icons.build , color: Color.fromARGB(166, 42, 91, 114)),
                                    SizedBox(width: 4),
                                    Text('Trabajos'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'entregas',
                                child: Row(
                                  children: const [
                                    Icon(Icons.check_circle, color: Color.fromARGB(255, 62, 92, 224)),
                                    SizedBox(width: 4),
                                    Text('Finalizado')
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Notificacion',
                                child: Row(
                                  children: const [
                                    Icon(Icons.notifications,  color: Color.fromARGB(255, 214, 148, 5)),
                                    SizedBox(width: 4),
                                    Text('Notificar')
                                  ],
                                ),
                              ),
                            ],
                            child: Container( //Resaltar de color segun el estado
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              decoration: BoxDecoration(
                                color: ordenVehi.estado
                                    ? const Color.fromARGB(134, 255, 153, 0)
                                    : const Color.fromARGB(125, 76, 175, 79),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text( 
                                ordenVehi.estado ? 'En Taller' : 'Listo', // Lógica del booleano: true = 'En Taller', false = 'Listo'
                                style: TextStyle(
                                  color: ordenVehi.estado  // true = En Taller (naranja), false = Listo (verde)
                                      ? Colors.orange[900]
                                      : Colors.green[900],
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,  // Texto muy largo
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // icono  para eliminar
                      DataCell(
                        SizedBox(
                        // width: colWidth*0.1, //limita el ancho de cada columna
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Eliminar',
                          onPressed:(){
                            _eliminarVehiculo(index);
                          }
                        ),
                      )),
                    ]);
                  }),
                ),
              ),
            ),
          );
        },
      )
    );
 }
}