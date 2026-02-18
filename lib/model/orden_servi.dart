class OrdenServicio {
  final int? id;
  final String? ordens; //id de la orden
  final String? servicios; //id del servicio
  final String? nombreServ; //nombre del servicio
  final int? cantidad;  //cantidad fija 1
  double? precio;  //valor del servicio
  final double? subtotal;
  String? imagenUrl;

  OrdenServicio({
    this.id ,
    this.ordens,
    this.servicios,
    this.nombreServ,
    this.cantidad,
    this.precio,
    this.subtotal,
    this.imagenUrl,
  });

  //toma los datos por la api (backend)
  factory OrdenServicio.fromJson(Map<String, dynamic> json){
    return OrdenServicio(
      //id: json['id'], 
      ordens: json['orden']?.toString(), 
      servicios: json['servicioCodigo']?.toString(), 
      nombreServ: json['nombreServicio']?.toString(),
      cantidad: json['cantidad']?.toInt(), 
      precio: json['precio']?.toDouble(), 
      subtotal: json['subtotal']?.toDouble(),
      imagenUrl: json['imagenUrl']?? '',
    );
  }

  //Envia datos al backend
  Map<String, dynamic> toJson(){
    return{
      //'id':id,
      //'orden':ordens,
      'servicioCodigo': servicios,
      'nombreServicio': nombreServ,
      'cantidad': cantidad,
      'precio': precio,
      'subtotal': subtotal,
      'imagen': imagenUrl,
    };
  }
}