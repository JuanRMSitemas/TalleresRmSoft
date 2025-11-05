import 'package:talleres/features/vehiculos/domain/vehiculo.dart';

class VehiculoModel extends Vehiculo {
  VehiculoModel({
    required super.estado,
    required super.tipo,
    required super.placa,
    required super.marca,
    required super.modelo,
    required super.notasIngreso,
  });

  factory VehiculoModel.fromJson(Map<String, dynamic> json) {
    return VehiculoModel(
      estado: json['estado'] ?? false,
      tipo: json['tipo'],
      placa: json['placa'],
      marca: json['marca'],
      modelo: json['modelo'],
      notasIngreso: json['notas'],
      //fIngreso: DateTime.parse(json['fIngreso']),
      //estado: json['estado']
    );
  }

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

  String get estadoTexto => estado ? 'En Taller' : 'Finalizado';
}