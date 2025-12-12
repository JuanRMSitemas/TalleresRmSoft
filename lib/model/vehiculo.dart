// import 'dart:ffi';
// import 'package:talleres/model/vehiculo.dart';

class Vehiculo{
    bool estado;
    final String tipo;
    final String placa;
    final String marca;
    final String modelo;
    final String notasIngreso;

  Vehiculo({
    this.estado = true,
    required this.tipo,
    required this.placa,
    required this.marca,
    required this.modelo,
    required this.notasIngreso,
  });

  Map<String, dynamic> toJson() {
    return {
      'estado': estado,
      'tipo': tipo,
      'placa': placa,
      'marca': marca,
      'modelo': modelo,
      'notasIngreso': notasIngreso,
      //'fIngreso': fIngreso.toIso8601String(),
      //'estado' : estado,
    };
  }

  //String get estadoTexto => estado ? 'En Taller' : 'Finalizado';
}