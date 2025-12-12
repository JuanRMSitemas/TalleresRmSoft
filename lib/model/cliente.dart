import 'package:talleres/model/vehiculo.dart';

class Cliente {
  final String tipoId;
  final String numeroId;
  final String nombre;
  final String email;
  final String celular;
  final List<Vehiculo> vehiculos;
  

  //meter como clave foranea el vehiculo

  /// 
  Cliente({
    required this.tipoId,
    required this.numeroId,
    required this.nombre,
    required this.email,
    required this.celular,
    this.vehiculos = const[],
  });

  Map<String, dynamic> toJson() {
    return {
      "tipoDocumento": tipoId,
      "nit": numeroId,
      "nombre": nombre,
      "email": email,
      "celular": celular,
      "vehiculos": vehiculos.map((v) => v.toJson()).toList()
    };
  }
}
