class OrdenServicio {
  final int? id;
  final String? ordens; //id de la orden
  final String? servicios; //id del servicio
  final int? cantidad;  //cantidad fija 1
  final double? precio;  //valor del servicio
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
      //id: json['id'], 
      ordens: json['orden'], 
      servicios: json['servicioCodigo'], 
      cantidad: json['cantidad'], 
      precio: json['precio'], 
      subtotal: json['subtotal'],
      //imagenUrl: json['imagenUrl']
    );
  }

  //Envia datos al backend
  Map<String, dynamic> toJson(){
    return{
      //'id':id,
      //'orden':ordens,
      'servicioCodigo': servicios,
      'cantidad': cantidad,
      'precio': precio,
      'subtotal': subtotal
    };
  }
}