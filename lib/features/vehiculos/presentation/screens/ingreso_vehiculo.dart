import 'package:flutter/material.dart';
import 'package:talleres/core/theme/app_colors.dart';
import 'package:talleres/core/widgets/navigation/main_layout.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
import 'package:talleres/desing/text_style.dart';
import 'package:talleres/model/cliente.dart';
import 'package:talleres/model/orden_servi.dart';
import 'package:talleres/model/procesos.dart';
import 'package:talleres/model/servicio.dart';
import 'package:talleres/model/vehiculo.dart';
import 'package:talleres/model/orden_vehi.dart';
import 'package:talleres/services/api_service.dart';
import 'package:talleres/services/cliente_service.dart';

class IngresoVehiculoScreen extends StatefulWidget {

  final void Function(
    Cliente cliente,
    Vehiculo vehiculo,
    Orden orden,
    Procesos proceso,
  )
  onVehiculoIngresado;

  const IngresoVehiculoScreen({super.key, required this.onVehiculoIngresado});

  @override
  State<IngresoVehiculoScreen> createState() => _IngresoVehiculoScreenState();
}

//Formulario de ingreso
//Aqui se genera el formulario de ingreso del vehiculo
class _IngresoVehiculoScreenState extends State<IngresoVehiculoScreen> {
  
  final _formKey = GlobalKey<FormState>();
  //Cliente controladores
  final List<String> _tiposId = ['CC', 'NIT', 'Otro'];
  String _tipoSelecId = "CC";
  final TextEditingController _numeroIdController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();

  //Vehiculo controladores
  String _tipoSelecVehiculo = 'Carro';
  final List<String> _tiposVehiculos = ['Carro', 'Moto', 'Camión'];
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();

  //Orden controladores
  DateTime _fechaSeleccionada  = DateTime.now();
  final TextEditingController _notasController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  //Servicio controladores
  final TextEditingController _idController =TextEditingController();
  final TextEditingController _nombreServicioController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  //OrdenServicio controladores
  final TextEditingController _precioServicioController = TextEditingController();
  final TextEditingController _subtotalController = TextEditingController();

  //Procesos controladores
  String _procesoSelec = 'Seleccione proceso';
  final List<String> _tipoProcesos = ['Seleccione proceso' , 'Mantenimiento', 'Cambio de aceite', 'Calibracion de valvulas'];

  final ClienteService clienteService = ClienteService();
  bool clienteExiste = false;

  Future<void> buscarCliente(String nit) async {
    final cliente = await clienteService.buscarCliente(nit);
    String tipoDoc = "null";

    if (cliente != null) {
      if(_tipoSelecId == 'C'){
        tipoDoc = 'CC';
      } 
      tipoDoc =cliente.tipoId;
      _nombreController.text = cliente.nombre;
      _correoController.text = cliente.email;
      _celularController.text = cliente.celular;

      setState(() {
        clienteExiste = true;
      });
    } else {
      _nombreController.clear();
      _correoController.clear();
      _celularController.clear();

      setState(() {
        clienteExiste = false;
      });
    }
  }

  Future<void>  _guardar() async {
    if (_formKey.currentState!.validate()) {

      final clientes = Cliente(
        tipoId: _tipoSelecId.substring(0,1),
        numeroId: _numeroIdController.text,
        nombre: _nombreController.text,
        celular: _celularController.text,
        email: _correoController.text,
      );

      final vehiculos = Vehiculo(
        //fechaIngreso: DateTime.now(),
        tipo: _tipoSelecVehiculo,
        placa: _placaController.text,
        modelo: _modeloController.text,
        marca: _marcaController.text,
        //notasIngreso: _notasController.text,
      );

      final proceso = Procesos(
        nombre: _procesoSelec,
        valor: 0,
      );

      final servicio = Servicio(
        id: _idController.text,
        nombre: _nombreServicioController.text,
        descripcion: _descripcionController.text,
        precio: double.parse(_precioController.text), 
      );

      final orden = Orden(
        id: '', 
        fechaIngreso: DateTime.now(),
        fechaIngresoVehi: DateTime.now(), 
        fechaEstimada: _fechaSeleccionada,
        notasIngreso: _notasController.text, 
        cliente: clientes, 
        vehiculo: vehiculos,
      );

      final ordenServicio = OrdenServicio(
        ordens: orden,
        servicios: null, 
        precio: double.parse(_precioServicioController.text), 
        subtotal: double.parse(_subtotalController.text)
      );

      final api = ApiService();

      final okRegistro = await api.registrarClienteVehiculo(vehiculos, clientes);

      if(!okRegistro){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("error al registrar, verifique los datos"), backgroundColor: Colors.red)
        );
      }
      widget.onVehiculoIngresado(clientes, vehiculos, orden, proceso);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ingresado a taller"), backgroundColor: Colors.blue),
        );

      Navigator.pop(context);
    }
  }

  Future<void> crearOrden() async{
    

  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Ingresar Vehículo',
      body: bodyResult(),
      showBottomNav: false,
      showDrawer: false,
    );
  }

  Padding bodyResult() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child:SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                //tipo id - Nro id
                children: [
                  //tipo de id
                  Expanded(
                    flex: 2, // Se ajusta el ancho relativo
                    child: DropdownButtonFormField<String>(
                      initialValue: _tipoSelecId,
                      hint: const Text('Seleccione el Id'),
                      items: _tiposId.map(
                        (tipo) =>
                        DropdownMenuItem(value: tipo, child: Text(tipo)),
                      ).toList(),
                      onChanged: (value) {
                        setState(() => _tipoSelecId = value!);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Tipo de ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _numeroIdController,
                      decoration: const InputDecoration(
                        labelText: 'Número de ID',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value){
                        if (value.length >=6){
                          buscarCliente(value);
                        }
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? 'Ingrese su número de ID'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  //Grupo "tipo de veiculo"
                  Expanded(
                    flex: 2, // ajustar el ancho relativo
                    child: DropdownButtonFormField<String>(
                      initialValue: _tipoSelecVehiculo,
                      hint: const Text('Vehículo'),
                      items: _tiposVehiculos
                          .map(
                            (tipo) =>
                                DropdownMenuItem(value: tipo, child: Text(tipo)),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => _tipoSelecVehiculo = value!);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Vehiculo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    flex: 2, // Más ancho que el primero
                    child: TextFormField(
                      controller: _placaController,
                      decoration: const InputDecoration(
                        labelText: 'N° Placa',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Ingrese placa de vehiculo'
                          : null,
                        inputFormatters: [
                            UpperCaseTextFormatter(),
                          ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Nombre de cliente
              TextFormField(
                controller:
                    _nombreController, //-------------------------------------------XXXXXXXXXXX
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese nombre de propietario'
                    : null,
              ),
              const SizedBox(height: 10),

              // Campo numero de cel
              TextFormField(
                controller: _celularController, //------------------------------------------XXXXXXXXXXXXXXXXXXX
                decoration: const InputDecoration(
                  labelText: 'Celular',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese número de celular';
                  } 
                  else if (value.length != 10) {
                    return 'Debe tener 10 dígitos';
                  }
                  return null;
                }
              ),
              const SizedBox(height: 10),

              // Campo Correo E
              TextFormField(
                controller:
                    _correoController, //----------------------------------------------XXXXXXXXXXXXXXXXXXX
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              //Modelo-Marca
              Row(
                children: [
                  //Grupo "Modelo vehiculo"
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _modeloController,
                      decoration: const InputDecoration(
                        labelText: 'Modelo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),
                  //
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _marcaController,
                      decoration: const InputDecoration(
                        labelText: 'Marca',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              //Procesos a  vehiculo
              DropdownButtonFormField<String>(
                initialValue: _procesoSelec,
                hint: const Text(''),
                items: _tipoProcesos
                    .map(
                      (tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => _procesoSelec = value!);
                },
                decoration: const InputDecoration(
                  labelText: 'Seleccione un proceso',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == 'Seleccione proceso'
                    ? 'Seleccione un proceso'
                    : null,
              ),
              const SizedBox(height: 10),

              //Fecha de entrega estimada
              TextFormField(
                controller: _fechaController,
                readOnly: true, // No editable manualmente
                decoration: const InputDecoration(
                  labelText: 'Fecha posible entrega',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),

                validator: (value) => value == null || value.isEmpty 
                ? 'Seleccione una fecha' 
                : null,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode()); // Cierra teclado
                  DateTime? fecha = await showDatePicker(
                    context: context,
                    initialDate: _fechaSeleccionada,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    locale: const Locale('es', 'ES'), // español
                  );

                  if (fecha == null) return; // usuario canceló

                  TimeOfDay? hora = await showTimePicker(
                    context: context, 
                    initialTime: TimeOfDay.now(),
                  );

                  if (hora == null) return;

                  final DateTime fechaCompleta = DateTime(
                    fecha.year,
                    fecha.month,
                    fecha.day,
                    hora.hour,
                    hora.minute,
                  );

                  setState(() {
                    _fechaSeleccionada = fechaCompleta;
                    _fechaController.text =
                     '${fechaCompleta.day.toString().padLeft(2, '0')}/${fechaCompleta.month.toString().padLeft(2, '0')}/${fechaCompleta.year % 100}  ${hora.format(context)}';
                  });
                },
              ),
              const SizedBox(height: 16),

              //Notas
              TextFormField(
                controller:
                  _notasController, //----------------------------------------------XXXXXXXXXXXXXXXXXXX
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              //Boton de guardar ingresos
              Center(
                child: ElevatedButton.icon(
                  onPressed: _guardar,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar vehículo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonGreen,
                    foregroundColor: AppColors.backgrounLight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}