class Orden {
  //int idOrden;
  final DateTime fechaIngreso;
  final DateTime posibleEntrega;
  final DateTime? fechaEntrega;
  final String notas;


  Orden({
    //required this.idOrden,
    required this.fechaIngreso,
    required this.posibleEntrega,
    this.fechaEntrega,
    required this.notas,
  });
}
