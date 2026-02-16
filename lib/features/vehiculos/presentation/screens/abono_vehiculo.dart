import 'package:flutter/material.dart';
import 'package:talleres/core/widgets/navigation/main_layout.dart';
import 'package:talleres/desing/text_style.dart';
import 'package:talleres/desing/buttons.dart'; 
import 'package:talleres/desing/date_extensions.dart'; //format para fecha
import 'package:talleres/model/orden.dart';
import 'package:talleres/model/orden_servi.dart';
import 'package:talleres/model/servicio.dart';
//import 'package:talleres/features/vehiculos/presentation/screens/home_page.dart';
import 'package:intl/intl.dart';
import 'package:talleres/desing/spacing_responsive.dart';
import 'package:talleres/services/orden_api.dart';
import 'package:talleres/services/orden_servicio_api.dart';

class AbonoScreen extends StatefulWidget {
  final String ordenId; // ID de la orden a actualizar
  final String nombre;
  final int estado; // 1 = En Taller
  final String vehiculo;
  final String placa;
  final DateTime? ingreso;
  final DateTime? salidaEstimada;
  final String metodoPago;
  final double abono;
  final List<Servicio> servicios;

  const AbonoScreen({
    super.key,
    required this.ordenId,
    required this.nombre,
    required this.estado,
    required this.vehiculo,
    required this.placa,
    required this.ingreso,
    required this.salidaEstimada,
    required this.metodoPago,
    required this.abono,
    required this.servicios,
  });

  @override
  State<AbonoScreen> createState() => _AbonoScreenState();
}
class _AbonoScreenState extends State<AbonoScreen> {
  String metodoPagoSelec = 'Seleccione el método de pago';
  final List<String> metodoPago = ['Efectivo', 'Transferencia', 'Otro'];

  final List<Servicio> _servicio=[]; //aqui trae los servicios asignados
  List<OrdenServicio> _ordenServicios = []; // aquí se cargan los servicios asociados a la orden para mostrarlos en la pantalla de trabajos, se obtiene de la base de datos a través de la ordenServicioApi y se muestra en la pantalla de trabajos, para luego relacionarlos con la ordenServicio y pasarlos a la pantalla de abono
  
  //carga los servicios asociados a la orden para mostrarlos en la pantalla de trabajos
  Future<void> _cargarServicios() async { 
    final data = await OrdenServicioApi()
      .listarPorOrden(widget.ordenId);
  
    setState(() {
      _ordenServicios = data;
      debugPrint('✅ Servicios cargados: ${_ordenServicios.length}');
    });
  }

  /// Inicialización del estado del widget lista los servicios registrados 
  @override
  void initState() {
    super.initState();
    _cargarServicios();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'ABONO',      
      body: datosCliente(),
      showDrawer: false,
      showBottomNav: false,
    );
  }

  Padding datosCliente() {
    double total = _ordenServicios.fold(0, (sum, p) => sum + p.precio!);
    double pagar = widget.abono;
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
              itemCount: _ordenServicios.length,
              itemBuilder: (context,index) {
                final servicio = _ordenServicios[index];
                return Card(
                  //margin: const EdgeInsets.symmetric(vertical: 5),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Nombre del servicio
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    servicio.nombreServ!,
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
                                  ('\$ ${servicio.precio?.toStringAsFixed(0)}'),
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
          Row(
            children: [
              // Columna izquierda con padding
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Abonado",
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
                      '\$ ${formato.format(pagar)}',
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
                _confirmarPago(context);
              },
            ),
          ),
        ],
      )
    );
  }
  
  Future<void> _confirmarPago(BuildContext context) async {
    final deudaTotal = _ordenServicios.fold(0.0, (sum, p) => sum + p.precio!);
    final opcion = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar pago'),
        content: const Text('¿El cliente canceló el valor total?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'abonar'),
            child: const Text('Abonar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'total'),
            child: const Text('Pago total'),
          ),
        ],
      ),
    );

    if (opcion == 'total') {
      _guardarOrden(abono: deudaTotal); // pago completo
    }

    if (opcion == 'abonar') {
      _mostrarDialogoAbono(context);
    }
  }

  /// Se ingresar el valor del abono y luego guarda la orden con el nuevo abono
  Future<void> _mostrarDialogoAbono(BuildContext context) async {
    final controller = TextEditingController();

    final resultado = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar abono'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Valor a abonar',
            prefixText: '\$ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final valor = double.tryParse(controller.text);
              if (valor == null || valor <= 0) return;
              Navigator.pop(context, valor);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (resultado != null) {
      _guardarOrden(abono: resultado);
    }
  }

  /// Guarda la orden con valor total y método de pago seleccionado
  Future<void> _guardarOrden({required double abono}) async {
    const placeholderPago = 'Seleccione el método de pago';

    if (metodoPagoSelec == placeholderPago) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona el método de pago')),
      );
      return;
    }

    final orden = Orden(
      id: widget.ordenId,
      metodoPago: metodoPagoSelec,
      abono: abono,
    );

    await OrdenService().actualizarMedioPago(
      widget.ordenId,
      orden.toJsonActualizar(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Orden actualizada correctamente')),
    );

    Navigator.popUntil(context, ModalRoute.withName('/'));
  }



}

