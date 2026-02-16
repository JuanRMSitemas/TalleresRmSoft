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
  final String ordenId;
  final String nombre;
  final String numId;
  final String vehiculo;
  final int estado;
  final String placa;
  final DateTime? ingreso;
  final DateTime? salidaEstimada;
  final List<Servicio> servicios;
  //final List<String> metodoPago;
  final double costo;

  const TrabajoScreen({
    super.key,
    required this.ordenId,
    required this.nombre,
    required this.numId,
    required this.vehiculo,
    required this.estado,
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
  
  //Servicio Seleccionado
  final List<Servicio> _servicio=[]; //aqui se registran los servicios seleccionados para luego pasarlos a la ordenServicio y relacionarlos con la orden
  final TextEditingController textValor = TextEditingController();

  //final List <OrdenServicio> _serviciosSeleccionados = [];
  final ServicioService servicioService = ServicioService();
  //Listado de servicios
  List<OrdenServicio> _ordenServicios = []; // aquí se cargan los servicios asociados a la orden para mostrarlos en la pantalla de trabajos, se obtiene de la base de datos a través de la ordenServicioApi y se muestra en la pantalla de trabajos, para luego relacionarlos con la ordenServicio y pasarlos a la pantalla de abono
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
    _init();
    _cargarServicios();
    listarServicios();
  }
  // Busca el vehículo para obtener id y carga la orden 
  // asociada a ese vehículo con el cliente
  Future<void> _init() async {
    await buscarVehiculo();   // ⏳ espera a que termine
    await cargarOrden();      
  }
  
  //carga los servicios asociados a la orden para mostrarlos en la pantalla de trabajos
  Future<void> _cargarServicios() async { 
    final data = await OrdenServicioApi()
      .listarPorOrden(widget.ordenId);
  
    setState(() {
      _ordenServicios = data;
      debugPrint('✅ Servicios cargados: ${_ordenServicios.length}');
    });
  }

  
  // carga los servicios disponibles para mostrarlos en el selector de servicios
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

  Future<void> buscarVehiculo() async { //obtiene el id del vehiculo a partir de la placa
    vehiculo = await VehiculoApi().buscarVehiculo(widget.placa);
    setState(() {
      idVehiculo = idVehiculo = vehiculo?.id; // Asigna el ID del vehículo encontrado = vehiculo != null ? vehiculo!.id : null;
    });
  }
  ///Aun que el id de la orden existe, se vueve a buscar la orden para obtener el id de la ordenServicio y 
  ///relacionarlo con los servicios seleccionados, para luego pasarlos a la pantalla de abono
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
  
  //------------------------------------------------------------------------______________________________-------------------------------_________________________________________-------------
  void eliminarProceso(String id, String index) {
    setState(() {
      OrdenServicioApi().eliminarServicio(id, index); // Elimina el servicio de la orden en la base de datos
      //_ordenServicios.removeAt(index);
    });
  }

  /// Se cargaran los procesos o trabajos asignados a la orden para 
  /// Se cambia a estado 2 'En Proceso'
  Future<void> cargarTrabajos(String ordenId) async { 

    for (final s in _servicio) {
      final payload = OrdenServicio(
        nombreServ: s.nombre,
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
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Lista de Trabajos Asignados"),backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context); // Regresa a la pantalla anterior (Trabajos)
    
  }

  Future<void> actualizarEstadoOrden(String ordenId, int estado) async {
    if (estado == 1) {
      await OrdenService().actualizarEstadosOdn(ordenId, {'estado': 2});
    }
    else if (estado == 2) {
      await OrdenService().actualizarEstadosOdn(ordenId, {'estado': 3});
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
    actualizarEstadoOrden(idOrden!, widget.estado); // Actualiza el estado de la orden a "En Proceso" al mostrar el selector de servicios
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

  //Boton de edicion de proceso
  void mostrarEdicionProcesos(OrdenServicio servicio) {
    final valorController = TextEditingController(text: servicio.precio.toString()); // valor de el servicio Seleccionado
    //final notasController = TextEditingController(text: servicio.descripcion);    // notas del servicio Seleccionado

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              title: Text("Editar servicio: ${servicio.nombreServ}"),
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
                      //controller: notasController,
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
                            servicio.imagenUrl = nombreArchivo; // solo 1 imagen
                          });
                        }
                      },
                      icon: const Icon(Icons.image),
                      label: const Text("Seleccionar imagen"),
                    ),

                    // Mostrar nombre del archivo si existe
                    if (servicio.imagenUrl?.isNotEmpty == true) ...[
                      const SizedBox(height: 12),
                      Text(
                        "Imagen seleccionada:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        servicio.imagenUrl ?? '',
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

  Future<void> _recargarVehiculos() async {
    // Simula delay o llamada real
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // LIMPIAMOS para evitar desfaces
      _ordenServicios.clear();

      _cargarServicios(); // recarga los servicios asociados a la orden para mostrarlos en la pantalla de trabajos
    } catch (e) {
      debugPrint('Error cargando datos: $e');
    }
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
    double total = _ordenServicios.fold(0, (sum, p) => sum + (p.precio ?? 0));
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
                    totalProcesos == 0
              ? '\$$total'
              : '\$${formatoMoneda.format(totalProcesos)}',
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
                  ],
                ),
              ]
            )
          ),
          
          Expanded(
            child:(_servicio.isEmpty && _ordenServicios.isEmpty)
            ? Center(
                child: Text(
                  'No hay trabajos agregados. Pulsa "+ Agregar servicio".',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
              : _servicio.isNotEmpty
              ? _buildServicios() ///servicios asignados pero sin guardar en la orden.
              : _buildOrdenServicios(), ///muestra los servicios ya asociados y finalizados a la orden.
          ),
          // ✅ Aquí usamos Expanded para que el ListView tenga espacio limitado dentro del Column
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await cargarTrabajos(idOrden!); // Carga los trabajos a la orden
              },
              icon: const Icon(Icons.save),
              label: const Text('Cargar Trabajos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 2, 121, 61),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          // Botón para agregar servicios --++--
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: mostrarSelectorProcesos,
              icon: const Icon(Icons.add),
              label: const Text('Seleccionar Trabajo'),
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
                      title: const Text('Confirmación', style: TextStyles.alert),
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
                  await actualizarEstadoOrden(idOrden!, widget.estado); // Actualiza el estado de la orden a "En Proceso"
                  debugPrint('Navegando a Abonar con servicios: $_servicio');
                   
                  Navigator.pushNamed(
                    context,
                    '/Abonar',
                    arguments: {
                      'ordenId': idOrden!,
                      'nombre': widget.nombre,
                      'estado': widget.estado, // 1 = En Taller
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
  
  Widget _buildServicios() { ///servicios asignados pero sin guardar en la orden.
    return ListView.builder(
    itemCount: _servicio.length,
    itemBuilder: (context, index) {
      final Servicio servicio = _servicio[index];

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
                  eliminarProceso(widget.ordenId, servicio.id!); // Elimina el servicio de la orden en la base de datos
                },
              ),
            ],
          ),
        ),

      );
    },);
  }

  Widget _buildOrdenServicios() { //muestra los servicios ya asociados y finalizados a la orden.
  return ListView.builder(
    itemCount: _ordenServicios.length,
    itemBuilder: (context, index) {
      final OrdenServicio ordenServicio = _ordenServicios[index];

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          title: Text(ordenServicio.nombreServ ?? 'Servicio'),
          subtitle: Text("Valor: \$${ordenServicio.precio?.toStringAsFixed(0) ?? 0}"),
          // ÍCONOS
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Boton para editar servicio
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () {
                  debugPrint('Botón EDICION Servicios presionado');
                  mostrarEdicionProcesos(ordenServicio); // ← aquí se llama
                },
              ),
              /// Boton para eliminar servicio
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final bool? confirmar = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirmación', style: TextStyles.alert),
                        content: const Text('¿Esta seguro de eliminar este servicio?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Sí'),
                          ),
                        ],
                      );
                    },
                  );
                   // Verifica la respuesta del usuario
                  if (confirmar == true) {
                    debugPrint('Botón ELIMINAR Servicios presionado');
                    eliminarProceso(widget.ordenId, ordenServicio.servicios!); // elimina servicio dentro de la orden.
                    await _recargarVehiculos(); // recarga la lista de servicios para reflejar el cambio
                  }
                },
              ),
            ],
          ),
        ),
      );
    },);
  }
}