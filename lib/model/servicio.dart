///12/12/2025 J.Lozano 
//esta clase solo se usara para tomar los valores o servicios ya establecidos.
//Si se requiere crear un servicio nuevo se debe crear directamente en DB por ahora
// 
class Servicio {
  final String? id;
  final String nombre;
  String descripcion;
  double precio;
  //double? tarifa;
  //bool? activo;
  String? imagen;

  Servicio({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    //required this.tarifa,
    //this.activo,
    this.imagen
  });

  factory Servicio.fromJson(Map<String, dynamic>json){
    return Servicio(
      id:json['id'],
      nombre:json['nombre'],
      descripcion: json['descripcion']?? 'this is error for juanSe isEmpty',
      precio: (json['precio'] as num).toDouble(),
      //tarifa: json['tarifa'] != null ? (json['tarifa'] as num).toDouble() : null,
      //activo: json['activo'],
      imagen: json['fotoUrl']?? '',
    );
  }

  Map<String, dynamic>toJson(){
    return{
      'id':id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      //'tarifa': tarifa,
      //'activo': activo,
      'fotoUrl': imagen,
    };
  }
}