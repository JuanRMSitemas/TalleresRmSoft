class Orden {
  //int idOrden;
  final DateTime fechaIngreso;
  final DateTime posibleEntrega;
  final DateTime? fechaEntrega;
  final String notas;
  final String metodoPago;
  final double costo;


  Orden({
    //required this.idOrden,
    required this.fechaIngreso,
    required this.posibleEntrega,
    this.fechaEntrega,
    this.notas = '',
    this.metodoPago = '',
    this.costo = 0,
  });
}
