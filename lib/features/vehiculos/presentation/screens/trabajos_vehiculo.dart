import 'package:flutter/material.dart';
//import 'package:talleres/core/widgets/custom_scaffold.dart';
import 'package:talleres/core/widgets/navigation/main_layout.dart';
import 'package:talleres/desing/text_style.dart';
import 'package:talleres/desing/date_extensions.dart'; //format para fecha
import 'package:intl/intl.dart';
import 'package:talleres/model/orden.dart';
import 'package:talleres/model/orden_servi.dart';
import 'package:talleres/model/servicio.dart';
import 'package:talleres/features/vehiculos/presentation/screens/abono_vehiculo.dart';// ignore: unused_import
import 'package:image_picker/image_picker.dart';
import 'package:talleres/model/vehiculo.dart';
import 'package:talleres/services/orden_api.dart';
import 'package:talleres/services/orden_servicio_api.dart';

import 'package:talleres/services/servicio_service.dart';
import 'package:talleres/services/vehiculo_api.dart';// ignore: unused_import

class TrabajoScreen extends StatefulWidget {
  final String? idOrden;
  final String nombre;
  final String numId;
  final String vehiculo;
  final String placa;
  final DateTime? ingreso;
  final DateTime? salidaEstimada;
  final List<Servicio> servicios;
  //final List<String> metodoPago;
  final double costo;

  const TrabajoScreen({
    super.key,
    this.idOrden,
    required this.nombre,
    required this.numId,
    required this.vehiculo,
    required this.placa,
    required this.ingreso,
    required this.salidaEstimada,
    required this.servicios,
    //required this.metodoPago,
    required this.costo
  });

  @override
  State<TrabajoScreen> createState() => _TrabajoScreenState();
}

class _TrabajoScreenState extends State<TrabajoScreen> {
  final formatoMoneda = NumberFormat('#,###', 'es_CO'); // 🇨🇴 formato colombiano 
  final TextEditingController _costoController = TextEditingController(); //Valor por defecto sin servicios
  
  //Serivicios
  //Servicio Seleccionado
  final List<Servicio> _servicio=[];
  final TextEditingController textValor = TextEditingController();
  //Seleccion de proceso/trabajo para asignar a la orden
  OrdenServicio? ordenServicio;

  //final ImagePicker _picker = ImagePicker();
  //final List <OrdenServicio> _serviciosSeleccionados = [];
  final ServicioService servicioService = ServicioService();
  //Listado de servicios
  List<Servicio> _serviciosDisponibles = [];
  bool _cargandoServicios = true;

  Vehiculo? vehiculo;
  int? idVehiculo;
  Orden? orden;
  String? idOrden;
  
  bool cargando = true;

  /// Inicialización del estado del widget lista los servicios registrados 
  @override
  void initState() {
    super.initState();
    debugPrint('🔥 initState ejecutado');
    _init();
    listarServicios();
  }

  // Inicialización asincrónica
  // Busca el vehículo para obtener id y carga la orden asociada a ese vehículo con el cliente
  Future<void> _init() async {
    await buscarVehiculo();   // ⏳ espera a que termine
    await cargarOrden();      
  }

  Future<void> buscarVehiculo() async {
    vehiculo = await VehiculoApi().buscarVehiculo(widget.placa);
    setState(() {
      idVehiculo =idVehiculo = vehiculo?.id; // Asigna el ID del vehículo encontrado = vehiculo != null ? vehiculo!.id : null;
    });
  }
  
  Future<void> cargarOrden() async {
  final result = await OrdenService()
    .buscarUltimaOrden(widget.numId, idVehiculo);

    setState(() {
      orden = result;
      idOrden = result?.id;

      if (idOrden != null) {
        debugPrint('✅ Orden cargada con ID: $idOrden');
      } else {
        debugPrint('⚠️ No se encontró ninguna orden');
      }

      cargando = false;
    });
  }

  Future<void> listarServicios() async {
    try {
      final servicios = await servicioService.listarServicios();

      setState(() {
        _serviciosDisponibles = servicios;
        _cargandoServicios = false;
      });
    } catch (e) {
      debugPrint('Error cargando servicios: $e');
      setState(() {
        _cargandoServicios = false;
      });
    }
  }
  //------------------------------------------------------------------------______________________________-------------------------------_________________________________________-------------
  void eliminarProceso(int index) {
    setState(() {
      _servicio.removeAt(index);
    });
  }

  /// Se cargaran los procesos o trabajos asignados a la orden para relacionarlos con la ordenServicio(orden_servi)
  Future<void> cargarTrabajos(String ordenId) async {
  for (final s in _servicio) {
    final payload = OrdenServicio(
      servicios: s.id,
      cantidad: 1,
      precio: s.precio,
      subtotal: s.precio,
    );

    await OrdenServicioApi().agregarServicio(
      ordenId,
      payload,
    );
  }
}

  void agregarProceso(Servicio p) {
    setState(() {
      _servicio.add(Servicio(id: p.id, nombre: p.nombre, precio: p.precio, descripcion: '', imagen: '',));
    });
  }
  
  void editarProceso(int index) {
    final servicio = _servicio[index];

    // Controladores
    final TextEditingController valorController =
      TextEditingController(text: servicio.precio.toString());

    final TextEditingController notasController =
      TextEditingController(text: servicio.descripcion);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // permite que suba con el teclado
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Título
              const Center(
                child: Text(
                  'Editar servicio',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // Campo VALOR
              TextField(
                controller: valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor del servicio',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Campo NOTAS
              TextField(
                controller: notasController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),

              // Botón guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _servicio[index] = Servicio(
                        nombre: servicio.nombre,
                        precio: double.tryParse(valorController.text) ?? 0.0,
                        descripcion: notasController.text.trim(),
                        imagen: servicio.imagen,
                      );
                    });

                    Navigator.pop(context); // cierra el modal
                  },
                  child: const Text('Guardar cambios'),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
}

  /// Muestra el selector de categorías (BottomSheet)
  void mostrarSelectorProcesos() {
    debugPrint('Servicios disponibles: ${_serviciosDisponibles.length}'); //imprime en consola la cantidad de servicios disponibles
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        if (_cargandoServicios) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (_serviciosDisponibles.isEmpty) { //lista vacia
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text('No hay servicios disponibles'),
          );
        }
        return SafeArea(
          child: ListView.builder(
            //shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _serviciosDisponibles.length,
            itemBuilder: (context, index) {
              final servicio = _serviciosDisponibles[index];
              return ListTile(
                title: Text(servicio.nombre),
                onTap: () {
                  agregarProceso(servicio);
                  Navigator.pop(context); // cierra el bottom sheet
                },
              );
            },
            //separatorBuilder: (_, __) => const Divider(height: 1),
          ),
        );
      },
    );
  }

  double get totalProcesos { //suma los valores de los servicios se pasa al widget para mostrar
  return _servicio.fold(0.0, (sum, item) => sum + item.precio);
  }

  ///Boton de edicion de proceso
  void mostrarEdicionProceso(Servicio servicio) {
    final valorController = TextEditingController(text: servicio.precio.toString()); // valor de el servicio Seleccionado
    final notasController = TextEditingController(text: servicio.descripcion);    // notas del servicio Seleccionado

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              title: Text("Editar servicio: ${servicio.nombre}"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Campo valor
                    TextField(
                      controller: valorController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Valor"),
                    ),

                    const SizedBox(height: 12),

                    // Campo notas
                    TextField(
                      controller: notasController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: "Notas"),
                    ),

                    const SizedBox(height: 20),

                    // Botón seleccionar imagen
                    ElevatedButton.icon(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? archivo = await picker.pickImage(
                          source: ImageSource.gallery,
                        );

                        if (archivo != null) {
                          final nombreArchivo = archivo.name; // ← solo el nombre

                          setStateModal(() {
                            servicio.imagen = nombreArchivo; // solo 1 imagen
                          });
                        }
                      },
                      icon: const Icon(Icons.image),
                      label: const Text("Seleccionar imagen"),
                    ),

                    // Mostrar nombre del archivo si existe
                    if (servicio.imagen?.isNotEmpty == true) ...[
                      const SizedBox(height: 12),
                      Text(
                        "Imagen seleccionada:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        servicio.imagen ?? '',
                        style: const TextStyle(color: Colors.grey),
                      )
                    ],
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),

                ElevatedButton(
                  onPressed: () {
                    // Guardar cambios en el servicio
                    setState(() {
                      servicio.precio = double.tryParse(valorController.text) ?? 0;
                      servicio.descripcion = notasController.text;
                    });

                    Navigator.pop(context);
                  },
                  child: const Text("Guardar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'TRABAJOS',
      body: trabajosVehiculo(),
      showDrawer: false,
      showBottomNav: false,
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
                  DateFormat('dd/MM/yy HH:mm').format(widget.ingreso!), //guarda la fecha de ingreso en .fechaIngreso
                ),
              ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [const Text( 
                  "Salida estimada",
                  style: TextStyles.h4
                ),
                Text(
                  formatFecha(widget.salidaEstimada!), //guarda la fecha de ingreso en .fechaIngreso
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
                border: Border.all(color: Theme.of(context).colorScheme.primary,),
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.secondary,
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
          
          Expanded(
            child: _servicio.isEmpty
            ? Center(
                child: Text(
                  'No hay trabajos agregados. Pulsa "+ Agregar servicio".',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
            : ListView.builder(
                itemCount: _servicio.length,
                itemBuilder: (context, index){
                  final servicio = _servicio[index]; //se obtiene el objeto

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(servicio.nombre),
                      subtitle: Text("Valor: \$${servicio.precio.toStringAsFixed(0)}"),

                      // ÍCONOS
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Boton para editar servicio
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              debugPrint('Botón EDICION Servicios presionado');
                              mostrarEdicionProceso(servicio); // ← aquí se llama
                            },
                          ),
                          /// Boton para eliminar servicio
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              debugPrint('Botón ELIMINAR Servicios presionado');
                              eliminarProceso(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ),
          // ✅ Aquí usamos Expanded para que el ListView tenga espacio limitado dentro del Column
          
          // Botón para agregar servicios --++--
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: mostrarSelectorProcesos,
              icon: const Icon(Icons.add),
              label: const Text('Agregar servicio'),
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
                      content: const Text('¿Ha finalizado todos los servicios asignados?'),
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
                  await cargarTrabajos(idOrden!); // Carga los trabajos a la orden
                  debugPrint('Navegando a Abonar con servicios: $_servicio');

                  Navigator.pushNamed(
                    context,
                    '/Abonar',
                    arguments: {
                      'ordenId': idOrden!,
                      'nombre': widget.nombre,
                      'vehiculo': widget.vehiculo,
                      'placa': widget.placa,
                      'ingreso': widget.ingreso,
                      'salidaEstimada': widget.salidaEstimada,
                      'servicios': _servicio, // 👈 pasa la lista actual de servicios
                      'metodoPago': '', // o la lista real que uses
                    }
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