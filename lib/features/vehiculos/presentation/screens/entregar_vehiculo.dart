import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:talleres/core/widgets/navigation/main_layout.dart';
import 'package:talleres/desing/buttons.dart';
import 'package:talleres/desing/text_style.dart';
import 'package:talleres/desing/date_extensions.dart'; //format para fecha
import 'package:intl/intl.dart';
import 'package:talleres/model/orden_servi.dart';
import 'package:talleres/model/servicio.dart';
import 'package:talleres/services/orden_servicio_api.dart';

class EntregarVehiculo extends StatefulWidget {
  final String ordenId;
  final String nombre;
  final String celular;
  final String correo;
  final String vehiculo;
  final String placa;
  final DateTime? ingreso;
  final DateTime salidaEstimada;
  final List<Servicio> servicios;
  final List<String> metodoPago;
  final String notas;
  final double valorTotal;

  const EntregarVehiculo({
    super.key,
    required this.ordenId,
    required this.nombre,
    required this.celular,
    required this.correo,
    required this.vehiculo,
    required this.placa,
    required this.ingreso,
    required this.salidaEstimada,
    required this.servicios,
    required this.metodoPago,
    required this.notas,
    required this.valorTotal,
  });

  // const EntregarVehiculo({super.key});

  @override
  EntregarVehiculoState createState() => EntregarVehiculoState();
}
class EntregarVehiculoState extends State<EntregarVehiculo> {
  // final List<Cliente> _cliente = [];
  // final List<Vehiculo> _vehiculos = [];
  // final List<Orden> _orden = []; 
  final List<Servicio> _servicio = [];
  
  final TextEditingController _notasfinal = TextEditingController();
  final SignatureController _firmaController = SignatureController(
  penStrokeWidth: 2,
  penColor: Colors.black,
  exportBackgroundColor: const Color.fromARGB(255, 255, 249, 211),
  );
  
  List<OrdenServicio> _servicios = [];

  @override
  void initState() {
    super.initState();
    _cargarServicios();
  }

  Future<void> _cargarServicios() async {
    final data = await OrdenServicioApi()
      .listarPorOrden(widget.ordenId);
  
    setState(() {
      _servicios = data;
    });
  }

  //get metodoPagoSelec => null;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'FINALIZAR',
      body: datosCliente(),
      showBottomNav: false,
      showDrawer: false,
    );
  }

  Widget datosCliente() {
  double total = _servicios.fold(0, (sum, p) => sum + (p.precio ?? 0));
  final formato = NumberFormat("#,##0.00", "es_CO");
  //String metodoPagos = '';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( 'Taller Automotriz', //nombre que se ingresa en el formulario
              style:  TextStyles.h1
            ),
            Text( 'CL 24 # 7-29', //nombre que se ingresa en el formulario
              style:  TextStyles.h2
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ Text(
                    widget.nombre,
                    style: TextStyles.h2,
                    ),
                    Text(
                      "Cel: ${widget.celular}",
                      style: TextStyles.h4,
                    ),
                    Text(
                      "Correo: ${widget.correo}",
                      style: TextStyles.h4,
                    )
                  ]
                )
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ //INGRESO Y SALIDA F/H
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text( 
                    "Ingreso",
                    style: TextStyles.h4
                    ),
                  Text(
                    DateFormat('dd/MM/yy HH:mm').format(widget.ingreso ?? DateTime.now()), //guarda la fecha de ingreso en .fechaIngreso
                  ),
                  ]
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [const Text( 
                    "Salida estimada",
                    style: TextStyles.h4
                  ),
                  Text(
                    formatFecha(widget.salidaEstimada), //guarda la fecha de ingreso en .fechaIngreso
                  ),
                  ]
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                    "Notas: ", //"${widget.vehiculo} - ${widget.placa}", //vehicuolo y placa
                    style: TextStyles.h4,
                  ),
              Text(widget.notas)
              ],
            ),
            Row(
              children: [
                // Columna izquierda (Detalle)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Detalle",
                        style: TextStyles.h4,
                      ),
                    ],
                  ),
                ),

                // Columna del ícono (solo ocupa el espacio necesario)
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt, color: Color.fromARGB(255, 25, 43, 94)),
                      tooltip: 'Foto de Detalle',
                      onPressed: () {},
                    ),
                  ],
                ),

                // Columna derecha (Valor)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Text(
                        "Valor",
                        style: TextStyles.h4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //Recuadro con Procesos realizados -------------
            ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: const Text(
              "-Procesos realizados",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(221, 7, 26, 138)),
            ),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _servicios.length,
                itemBuilder: (context, index) {
                  final servicio = _servicios[index];
                  return Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              servicio.nombreServ ?? 'Buscando...',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(  
                              '\$ ${servicio.precio?.toStringAsFixed(0)}',
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
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
            SizedBox(height: 10,),
            //Notas
            TextFormField(
              controller:
                _notasfinal, //----------------------------------------------XXXXXXXXXXXXXXXXXXX Agregar notas finales a orden
              decoration: const InputDecoration(
                labelText: 'Notas',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Firma quien recibe:'),
                  ]
                ),
                Column(                
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_rounded, color: Colors.red),
                      tooltip: 'Eliminar',
                      onPressed:(){
                        _firmaController.clear();
                      }
                    ),
                  ],
                ),
              ],
            ),
            SizedBox( //Firma quien recibe el vehiculo /dueño u otro
              height: 135,
              child: Signature(
                controller: _firmaController,
                width: double.infinity,
                backgroundColor: Colors.amber[50]!,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: Buttons(
                text: 'Guardar',
                onPressed: () async {
                  // Exporta la firma a bytes (Uint8List)
                  final Uint8List? firmaBytes = await _firmaController.toPngBytes();

                  if (firmaBytes != null) {
                    // Aquí puedes guardarla en base de datos, local storage o enviarla por API
                    print("Firma capturada: ${firmaBytes.length} bytes");
                  }
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}