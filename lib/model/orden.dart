import 'package:talleres/model/orden_servi.dart';

class Orden {
  final String? id;
  final DateTime? fechaIngreso;
  final DateTime? fechaIngresoVehi;
  final DateTime? fechaEstimada;
  final DateTime? fechaEntrega; //fecha salida
  final bool estado;
  final String notasIngreso;
  final String notasSalida;
  final String metodoPago;
  final double costo;
  final String motivoIngreso;

  final String cliente;
  final String vehiculo;
  
  final List<OrdenServicio> servicios;

  Orden({
    //required this.idOrden,
    this.id, 
    this.fechaIngreso,
    this.fechaIngresoVehi,
    this.fechaEstimada,
    this.fechaEntrega,
    this.estado = true,
    this.notasIngreso = '',
    this.notasSalida = '',
    this.motivoIngreso = '',
    this.metodoPago = '',
    this.costo = 0,

    this.cliente = '',
    this.vehiculo = '',
    
    this.servicios = const[], 
  });


  /// Factory SOLO para respuestas que traen el ID
  factory Orden.fromIdJson(Map<String, dynamic> json) {
    return Orden(
      id: json['id']?.toString(),
    );
  }

  factory Orden.fromJson(Map<String, dynamic> json){ //Mapeo de los datos que vienen en formato JSON para usarlos en Dart
    return Orden(
      id: json['id']?.toString(),

      fechaIngreso: DateTime.parse(json['fechaIngreso']),
      fechaIngresoVehi: DateTime.parse(json['fechaIngresoVehi']),
      fechaEstimada: DateTime.parse(json['fechaEstimada']),
      fechaEntrega: json['fechaEntrega'] != null
          ? DateTime.parse(json['fechaEntrega'])
          : null,

      estado: json['estado'] == 1 || json['estado'] == true,
      notasIngreso: json['notasIngreso'] ?? '',
      notasSalida: json['notasSalida'] ?? '',
      metodoPago: json['medioPago'] ?? '',
      costo: (json['total'] as num).toDouble(),
      motivoIngreso: json['motivoIngreso'] ?? '',
      cliente: json['cliente'].toString(),
      vehiculo: json['vehiculo'].toString(),

      servicios: json['servicios'] is List
          ? json['servicios']
              .map<OrdenServicio>((s) => OrdenServicio.fromJson(s))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson(){ //Convierte los datos de Dart a formato JSON para enviarlos al backend
    return{
      "id": id,
      "fechaIngreso":fechaIngreso?.toIso8601String(),
      "fechaIngresoVehi":fechaIngresoVehi?.toIso8601String(),
      "fechaEstimada": fechaEstimada?.toIso8601String(),
      "fechaEntrega": fechaEntrega?.toIso8601String(),
      "estado": estado? 1 : 0,
      "notasIngreso": notasIngreso,
      "notasSalida": notasSalida,
      "medioPago": metodoPago,
      "total": costo,
      "motivoIngreso": motivoIngreso,
      
      "cliente":cliente,
      "vehiculo":vehiculo,
      
      "servicio":servicios.map((s) => s.toJson()).toList(),

    };
  }

   // 🟢 JSON SOLO PARA ACTUALIZAR
  Map<String, dynamic> toJsonActualizar() {
    return {
      'medioPago': metodoPago,
    };
  }
}
