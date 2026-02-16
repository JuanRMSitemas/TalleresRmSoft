import 'package:flutter/material.dart';
import 'package:talleres/core/widgets/navigation/main_layout.dart';
import 'package:talleres/model/servicio.dart';
import 'package:talleres/features/vehiculos/presentation/screens/abono_vehiculo.dart';
import 'package:talleres/features/vehiculos/presentation/screens/entregar_vehiculo.dart';
import 'package:talleres/features/vehiculos/presentation/screens/trabajos_vehiculo.dart';
import 'package:talleres/services/cliente_service.dart';
import 'package:talleres/services/orden_api.dart';
import 'package:talleres/services/vehiculo_api.dart';
import '../../../../model/vehiculo.dart';
import 'ingreso_vehiculo.dart';
import 'package:talleres/desing/date_extensions.dart';
import 'package:talleres/model/orden.dart';
import 'package:talleres/model/cliente.dart';
import 'package:talleres/desing/text_style.dart';

class VehiculosScreen extends StatefulWidget {
  const VehiculosScreen({super.key});

  @override
  State<VehiculosScreen> createState() => VehiculosScreenState();
}

class VehiculosScreenState extends State<VehiculosScreen> {
  final List<Cliente> _cliente = [];
  final List<Vehiculo> _vehiculos = [];
  final List<Orden> _ordenes = []; 
  final List<Servicio> _servicio = [];
  int selectedIndex = 0;

  Color _colorPorEstado(int estado) {
    switch (estado) {
      case 1: // Ingreso
        return const Color.fromARGB(133, 255, 28, 28); // rojo
      case 2: // En proceso
        return const Color.fromARGB(140, 255, 193, 7); // amarillo
      case 3: // Finalizado
        return const Color.fromARGB(140, 76, 175, 80); // verde
      case 4: // Entregado
        return const Color.fromARGB(140, 33, 150, 243); // azul
      default:
        return Colors.grey;
    }
  }
  Color _colorEstado(int estado) {
    switch (estado) {
      case 1: // Ingreso
        return const Color.fromARGB(133, 109, 0, 0); // rojo
      case 2: // En proceso
        return const Color.fromARGB(139, 128, 96, 0); // amarillo
      case 3: // Finalizado
        return const Color.fromARGB(139, 0, 124, 4); // verde
      case 4: // Entregado
        return const Color.fromARGB(139, 0, 57, 104); // azul
      default:
        return const Color.fromARGB(255, 53, 53, 53);
    }
  }

  String _textoPorEstado(int estado) {
  switch (estado) {
    case 1:
      return 'Por iniciar';
    case 2:
      return 'En proceso';
    case 3:
      return 'Fin Procesos';
    case 4:
      return 'Entregado';
    default:
      return 'Error';
  }
}

  void _agregarVehiculo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IngresoVehiculoScreen(
          onVehiculoIngresado: (Cliente cliente, Vehiculo vehiculo, Orden orden, Servicio servicio) {
            setState(() {
              _cliente.add(cliente);
              _vehiculos.add(vehiculo);
              _ordenes.add(orden);
              _servicio.add(servicio);
            });
          },
        ),
      ),
    );
  }

  void _eliminarVehiculo(int index) {
    setState(() {
      OrdenService().eliminarOrden(_ordenes[index].id!); // Elimina la orden del backend
      _recargarVehiculos(); // Recarga los datos para reflejar los cambios
    });
  }

  Future<void> _recargarVehiculos() async {
    // Simula delay o llamada real
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _cargarDatos(); // Vuelve a cargar los datos desde el inicio
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      // LIMPIAMOS para evitar desfaces
      _ordenes.clear();
      _vehiculos.clear();
      _cliente.clear();

      final ordenes = await OrdenService().obtenerOrdenesTaller(); 
      // 👆 este endpoint debe traer SOLO estado 1 y 2

      for (final orden in ordenes) {
        // Agregar la orden
        _ordenes.add(orden);

        // Trae el vehículo relacionado
        final vehiculo = await VehiculoApi()
            .buscarVehiculo(orden.vehiculo);
        if (vehiculo != null) {
          _vehiculos.add(vehiculo);
        }

        // Trae el cliente relacionado
        final cliente = await ClienteService()
            .buscarCliente(orden.cliente);
        if (cliente != null) {
          _cliente.add(cliente);
        }
      }

      setState(() {});
    } catch (e) {
      debugPrint('Error cargando datos: $e');
    }
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
      body: RefreshIndicator(
        onRefresh: _recargarVehiculos,
        child: tablavehiculos(),
      ),
    );
  }

 Padding tablavehiculos() {
   return Padding(
      padding: const EdgeInsets.all(0),
      child: LayoutBuilder(
        builder: (context, constraints) {

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
                      final ordenVehi = _ordenes[index];
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
                            child: PopupMenuButton<String>(
                              onSelected: (value) {
                                final rutas = {
                                  'Abonar': AbonoScreen(
                                    ordenId: ordenVehi.id ?? '',
                                    nombre: clienteV.nombre,
                                    vehiculo: transporte.tipo,
                                    estado: ordenVehi.estado, // true = En Taller, false = Listo
                                    ingreso: ordenVehi.fechaIngreso,
                                    salidaEstimada: ordenVehi.fechaEstimada,
                                    placa: transporte.placa,
                                    servicios: [],
                                    abono: ordenVehi.abono ?? 0,
                                    metodoPago: ordenVehi.metodoPago ?? '',
                                  ),
                                  'reparacion': TrabajoScreen(
                                    ordenId: ordenVehi.id ?? '',
                                    nombre: clienteV.nombre,
                                    numId: clienteV.numeroId,
                                    vehiculo: transporte.tipo,
                                    estado: ordenVehi.estado, // true = En Taller, false = Listo
                                    ingreso: ordenVehi.fechaIngreso,
                                    salidaEstimada: ordenVehi.fechaEstimada,
                                    placa: transporte.placa,
                                    servicios: [],
                                    //metodoPago:[],
                                    costo: ordenVehi.costo,
                                  ),
                                  'entregas': EntregarVehiculo(
                                    ordenId: ordenVehi.id ?? '',
                                    nombre: clienteV.nombre,
                                    celular: clienteV.celular,
                                    correo: clienteV.email,
                                    estado: ordenVehi.estado, // 1 = En Taller
                                    vehiculo: transporte.tipo,
                                    ingreso: ordenVehi.fechaIngreso,
                                    salidaEstimada: ordenVehi.fechaEstimada!,
                                    placa: transporte.placa,
                                    servicios: [],
                                    metodoPago:[],
                                    notas: ordenVehi.notasIngreso ?? '',
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
                                  color: _colorPorEstado(ordenVehi.estado),
                                  borderRadius: BorderRadius.circular(6),
                                ),

                                child: Text(
                                  _textoPorEstado(ordenVehi.estado),
                                  style: TextStyle(
                                    color: _colorEstado(ordenVehi.estado),
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
                            onPressed:() async {
                              final bool confirmacion = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmar eliminación', style: TextStyles.alert),
                                  content: const Text('¿Estás seguro de que deseas eliminar este vehículo?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              ) ?? false;
                              if (confirmacion) {
                                _eliminarVehiculo(index);
                              }
                            }
                          ),
                        )),
                      ]);
                    }),
                  ),
                ),
              ),
            ),
          );
        },
      )
    );
 }
}