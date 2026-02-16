import 'package:talleres/model/orden_servi.dart';

class Orden {
  final String? id;
  final DateTime? fechaIngreso;
  final DateTime? fechaIngresoVehi;
  final DateTime? fechaEstimada;
  final DateTime? fechaEntrega; //fecha salida
  final String? placa;
  final int estado;
  final String? notasIngreso;
  final String? notasSalida;
  final String? metodoPago;
  final double costo;
  final double? abono;
  final String? motivoIngreso;

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
    this.placa,
    this.estado = 1, // 1 para ingreso pero no se ha iniciado, 2 para inicio trabajos, 3 para finalizo trabajos, 4 para entregado, 5 para cancelado
    this.notasIngreso = '',
    this.notasSalida = '',
    this.motivoIngreso = '',
    this.metodoPago = '',
    this.costo = 0,
    this.abono = 0,
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
      fechaIngresoVehi: json['fechaIngresoVehi'] != null ? DateTime.parse(json['fechaIngresoVehi']) : null,
      fechaEstimada: json['fechaEstimada'] != null ? DateTime.parse(json['fechaEstimada']) : null,
      fechaEntrega: json['fechaEntrega'] != null ? DateTime.parse(json['fechaEntrega']) : null,
      placa: json['placa'] ?? 'sin placa',
      estado: json['estado'], // 1 para ingreso pero no se ha iniciado, 2 para inicio trabajos, 3 para finalizo trabajos, 4 para entregado, 5 para cancelado
      notasIngreso: json['notasIngreso'] ?? 'sin notas', // acepta valores nulos
      notasSalida: json['notasSalida'] ?? 'sin notas',
      metodoPago: json['medioPago'] ?? 'sin definir',
      costo: (json['total'] as num).toDouble(),
      abono: json['abono'] != null ? (json['abono'] as num).toDouble() : 0,
      motivoIngreso: json['motivoIngreso'] ?? 'obligatorio',
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
      "placa": placa,
      "estado": estado,
      "notasIngreso": notasIngreso,
      "notasSalida": notasSalida,
      "medioPago": metodoPago,
      "total": costo,
      "abono": abono,
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
      'abono': abono,
    };
  }

  // 🟢 JSON SOLO PARA ACTUALIZAR ESTADOS
  Map<String, dynamic> toJsonActualizarEstado() {
    return {
      'estado': estado,
    };
  }
}
