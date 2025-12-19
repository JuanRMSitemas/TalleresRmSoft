//import 'dart:typed_data';

class Procesos{
  final String nombre;
  double valor;
  String notas;
  List<String> imagenes;

    Procesos({
    required this.nombre,
    required this.valor,
    this.notas = '',
    this.imagenes= const[],
  });
}

// Opcional: para manejar JSON (si usas API)
// factory Proceso.fromJson(Map<String, dynamic> json) {
//   return Proceso(
//     nombre: json['nombre'],
//     valor: (json['valor'] as num).toDouble(),
//     notas: json['notas'] ?? '',
//     imagenes: List<String>.from(json['imagenes'] ?? []),
//   );
// }

// Map<String, dynamic> toJson() {
//   return {
//     'nombre': nombre,
//     'valor': valor,
//     'notas': notas,
//     'imagenes': imagenes,
//   };
// }

