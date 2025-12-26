import 'package:talleres/model/cliente.dart';
import 'package:talleres/model/vehiculo.dart';
import 'package:talleres/model/orden_servi.dart';

class Orden {
  final String? id;
  final DateTime fechaIngreso;
  final DateTime fechaIngresoVehi;
  final DateTime fechaEstimada;
  final DateTime? fechaEntrega; //fecha salida
  final int estado;
  final String notasIngreso;
  final String notasSalida;
  final String metodoPago;
  final double costo;

  final String cliente;
  final String vehiculo;
  
  final List<OrdenServicio> servicios;

  Orden({
    //required this.idOrden,
    this.id, 
    required this.fechaIngreso,
    required this.fechaIngresoVehi,
    required this.fechaEstimada,
    this.fechaEntrega,
    required this.estado,
    this.notasIngreso = '',
    this.notasSalida = '',
    this.metodoPago = '',
    this.costo = 0,

    required this.cliente,
    required this.vehiculo,
    
    this.servicios = const[], 
  });

  factory Orden.fromJson(Map<String, dynamic> json){
    return Orden(
      id: json['id'],
      fechaIngreso: json['fechaIngreso'],
      fechaIngresoVehi: json['fechaIngresoVehi'],
      fechaEstimada: json['fechaEstimada'],
      fechaEntrega: json['fechaEntrega'],
      estado: json['estado'],
      notasIngreso: json['notasIngreso'],
      notasSalida: json['notasSalida'],
      metodoPago: json['metodoPago'], //aun no hay asignada una columna para este campo en Spring Boot
      costo: json['total'],

      cliente: json['cliente'],
      vehiculo: json['vehiculo'],
      
      servicios: json['servicios'] != null
      ? List<OrdenServicio>.from(
        json['servicios'].map((s) => OrdenServicio.fromJson(s)),
    )
    : [],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "id": id,
      "fechaIngreso":fechaIngreso.toIso8601String(),
      "fechaIngresoVehi":fechaIngresoVehi.toIso8601String(),
      "fechaEstimada": fechaEstimada.toIso8601String(),
      "fechaEntrega": fechaEntrega?.toIso8601String(),
      "estado": estado,
      "notasIngreso": notasIngreso,
      "notasSalida": notasSalida,
      "metodoPago": metodoPago,
      "total": costo,
      
      "cliente":cliente,
      "vehiculo":vehiculo,
      
      "servicio":servicios.map((s) => s.toJson()).toList(),

    };
  }
}
