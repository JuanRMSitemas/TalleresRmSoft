import 'package:talleres/model/Servicio.dart';
import 'package:talleres/model/orden_vehi.dart';

class OrdenServicio {
  final int? id;
  final Orden? ordens;
  final Servicio? servicios;
  final int? cantidad;
  final double? precio;
  final double? subtotal;

  OrdenServicio({
    this.id ,
    this.ordens,
    this.servicios,
    this.cantidad,
    this.precio,
    this.subtotal,
  });

  //toma los datos por la api (backend)
  factory OrdenServicio.fromJson(Map<String, dynamic> json){
    return OrdenServicio(
      id: json['id'], 
      ordens: json['orden'], 
      servicios: json['servicio'], 
      cantidad: json['cantidad'], 
      precio: json['precio'], 
      subtotal: json['subtotal']
    );
  }

  //Envia datos al backend
  Map<String, dynamic> toJson(){
    return{
      'id':id,
      'orden':ordens,
      'servicio': servicios,
      'canidad': cantidad,
      'precio': precio,
      'subtotal':subtotal
    };
  }
}