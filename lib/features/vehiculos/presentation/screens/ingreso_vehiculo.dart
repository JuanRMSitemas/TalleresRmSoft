import 'package:flutter/material.dart';
import 'package:talleres/core/widgets/custom_scaffold.dart'; //se importa los Appbarrs
import 'package:talleres/core/theme/app_colors.dart';
import 'package:talleres/core/widgets/navigation/main_layout.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
import 'package:talleres/desing/text_style.dart';
import 'package:talleres/features/vehiculos/domain/cliente.dart';
import 'package:talleres/features/vehiculos/domain/procesos.dart';
import 'package:talleres/features/vehiculos/domain/vehiculo.dart';
import 'package:talleres/features/vehiculos/domain/orden_vehi.dart';

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
  String _tipoSelecId = "CC";
  final TextEditingController _numeroIdController = TextEditingController();
  String _tipoSelecVehiculo = 'Carro';
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  String _procesoSelec = 'Seleccione proceso';
  DateTime _fechaSeleccionada  = DateTime.now();
  final TextEditingController _notasController = TextEditingController();
  final List<String> _tiposId = ['CC', 'NIT', 'Otro'];
  final List<String> _tiposVehiculos = ['Carro', 'Moto', 'Camión'];
  final List<String> _tipoProcesos = ['Seleccione proceso' , 'Mantenimiento', 'Cambio de aceite', 'Calibracion de valvulas'];
  final TextEditingController _fechaController = TextEditingController();

  void _guardar() {
    if (_formKey.currentState!.validate()) {

      final cliente = Cliente(
        tipoId: _tipoSelecId,
        numeroId: _numeroIdController.text,
        nombre: _nombreController.text,
        celular: _celularController.text,
        email: _correoController.text,
      );

      final vehiculo = Vehiculo(
        //fechaIngreso: DateTime.now(),
        tipo: _tipoSelecVehiculo,
        placa: _placaController.text,
        modelo: _modeloController.text,
        marca: _marcaController.text,
        notasIngreso: _notasController.text,
      );

      final orden = Orden(
        //idOrden: ,
        fechaIngreso: DateTime.now(),
        posibleEntrega: _fechaSeleccionada,
        notas: _notasController.text
      );

      final proceso = Procesos(
        nombre: _procesoSelec,
        valor: 0,
      );

      widget.onVehiculoIngresado(cliente, vehiculo, orden, proceso);
      Navigator.pop(context);
    }
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