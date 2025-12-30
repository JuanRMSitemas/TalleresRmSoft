///12/12/2025 J.Lozano 
//esta clase solo se usara para tomar los valores o servicios ya establecidos.
//Si se requiere crear un servicio nuevo se debe crear directamente en DB por ahora
// 
class Servicio {
  final String? id;
  final String nombre;
  String descripcion;
  double precio;
  String? imagen;

  Servicio({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    this.imagen
  });

  factory Servicio.fromJson(Map<String, dynamic>json){
    return Servicio(
      id:json['id'],
      nombre:json['nombre'],
      descripcion: json['descripcion']?? 'this is error for juanSe',
      precio: (json['precio'] as num).toDouble(),
      imagen: json['imagen']?? '',
    );
  }

  Map<String, dynamic>toJson(){
    return{
      'id':id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'imagen': imagen,
    };
  }
}