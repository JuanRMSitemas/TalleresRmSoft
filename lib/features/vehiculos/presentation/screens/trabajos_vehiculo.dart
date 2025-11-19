import 'package:flutter/material.dart';
import 'package:talleres/core/widgets/custom_scaffold.dart';
import 'package:talleres/desing/text_style.dart';
import 'package:talleres/desing/date_extensions.dart'; //format para fecha
import 'package:intl/intl.dart';
import 'package:talleres/features/vehiculos/domain/procesos.dart';
import 'package:talleres/features/vehiculos/presentation/screens/abono_vehiculo.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class TrabajoScreen extends StatefulWidget {
  final String nombre;
  final String vehiculo;
  final String placa;
  final DateTime ingreso;
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
  //final ImagePicker _picker = ImagePicker();
  //Listado de procesos
  final List<Procesos> _categoriasDisponibles = [
    Procesos(nombre: 'Mantenimiento preventivo', valor: 0),
    Procesos(nombre: 'Mantenimiento correctivo', valor: 0),
    Procesos(nombre: 'Diagnóstico general', valor: 0),
    Procesos(nombre: 'Revisión de frenos', valor: 0),
    Procesos(nombre: 'Cambio de aceite', valor: 0),
    Procesos(nombre: 'Alineación y balanceo', valor: 0),
  ];

  void eliminarProceso(int index) {
    setState(() {
      _proceso.removeAt(index);
    });
  }

  void agregarProceso(Procesos p) {
    setState(() {
      _proceso.add(Procesos(nombre: p.nombre, valor: p.valor, notas: ''));
    });
  }
  
  void editarProceso(int index) {
  final proceso = _proceso[index];

  // Controladores
  final TextEditingController valorController =
      TextEditingController(text: proceso.valor.toString());

  final TextEditingController notasController =
      TextEditingController(text: proceso.notas);

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
                'Editar proceso',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Campo VALOR
            TextField(
              controller: valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor del proceso',
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
                    _proceso[index] = Procesos(
                      nombre: proceso.nombre,
                      valor: double.tryParse(valorController.text) ?? 0.0,
                      notas: notasController.text.trim(),
                      imagenes: proceso.imagenes,
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
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final categoria = _categoriasDisponibles[index];
              return ListTile(
                title: Text(categoria.nombre),
                onTap: () {
                  agregarProceso(categoria);
                  Navigator.pop(context); // cierra el bottom sheet
                },
              );
            },
            //separatorBuilder: (_, __) => const Divider(height: 1),
            itemCount: _categoriasDisponibles.length,
          ),
        );
      },
    );
  }

  double get totalProcesos { //suma los valores de los procesos se pasa al widget para mostrar
  return _proceso.fold(0.0, (sum, item) => sum + item.valor);
  }

 void mostrarEdicionProceso(Procesos proceso) {
  final valorController = TextEditingController(text: proceso.valor.toString());
  final notasController = TextEditingController(text: proceso.notas);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateModal) {
          return AlertDialog(
            title: Text("Editar proceso: ${proceso.nombre}"),
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
                          proceso.imagenes = [nombreArchivo]; // solo 1 imagen
                        });
                      }
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("Seleccionar imagen"),
                  ),

                  // Mostrar nombre del archivo si existe
                  if (proceso.imagenes.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      "Imagen seleccionada:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      proceso.imagenes.first,
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
                  // Guardar cambios en el proceso
                  setState(() {
                    proceso.valor = double.tryParse(valorController.text) ?? 0;
                    proceso.notas = notasController.text;
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
          
          Expanded(
              child: _proceso.isEmpty
                  ? Center(
                      child: Text(
                        'No hay trabajos agregados. Pulsa "Agregar trabajo".',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _proceso.length,
                      itemBuilder: (context, index){
                        final proceso = _proceso[index]; //se obtiene el objeto

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(proceso.nombre),
                            subtitle: Text("Valor: \$${proceso.valor.toStringAsFixed(0)}"),

                            // ÍCONOS
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.orange),
                                  onPressed: () {
                                    mostrarEdicionProceso(proceso); // ← aquí se llama
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