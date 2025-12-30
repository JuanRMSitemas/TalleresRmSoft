class OrdenServicio {
  final int? id;
  final String? ordens;
  final String? servicios;
  final int? cantidad;
  final double? precio;
  final double? subtotal;
  //final String? imagenUrl;

  OrdenServicio({
    this.id ,
    this.ordens,
    this.servicios,
    this.cantidad,
    this.precio,
    this.subtotal,
    //this.imagenUrl,
  });

  //toma los datos por la api (backend)
  factory OrdenServicio.fromJson(Map<String, dynamic> json){
    return OrdenServicio(
      id: json['id'], 
      ordens: json['orden'], 
      servicios: json['servicio'], 
      cantidad: json['cantidad'], 
      precio: json['precio'], 
      subtotal: json['subtotal'],
      //imagenUrl: json['imagenUrl']
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