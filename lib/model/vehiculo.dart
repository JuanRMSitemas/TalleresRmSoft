class Vehiculo{
  bool estado;
  final String tipo;
  final String placa;
  final String marca;
  final String modelo;
  //final String notasIngreso;

  ///required obliga a enviar el dato - vehiculos tiene valor por defecto → evita null
  Vehiculo({
    this.estado = true,
    required this.tipo,
    required this.placa,
    required this.marca,
    required this.modelo,
  });

  factory Vehiculo.fromJson(Map<String, dynamic> json) {
    return Vehiculo(
      estado: json['estado'],
      tipo: json['tipo'],
      placa: json['placa'],
      marca: json['marca'],
      modelo: json['modelo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estado': estado,
      'tipo': tipo,
      'placa': placa,
      'marca': marca,
      'modelo': modelo,
    };
  }

  //String get estadoTexto => estado ? 'En Taller' : 'Finalizado';
}