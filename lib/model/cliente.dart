import 'package:talleres/model/vehiculo.dart';

class Cliente {
  final String tipoId;
  final String numeroId;
  final String nombre;
  final String email;
  final String celular;
  final List<Vehiculo> vehiculos;

  ///required obliga a enviar el dato - vehiculos tiene valor por defecto → evita null
  Cliente({
    required this.tipoId,
    required this.numeroId,
    required this.nombre,
    required this.email,
    required this.celular,
    this.vehiculos = const[],
  });

   ///factory permite crear un objeto a partir de otro formato - En este caso: JSON → Cliente
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      tipoId: json['tipoDocumento'],
      numeroId: json['nit'],
      nombre: json['nombre'],
      email: json['email'],
      celular: json['celular'],
      vehiculos: json['vehiculos'] != null
      ? List<Vehiculo>.from(
          json['vehiculos'].map((v) => Vehiculo.fromJson(v)),
        )
        : [],
    );
  }

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
