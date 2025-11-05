String formatFecha(DateTime fecha) {
  final dia = fecha.day;
  final mes = fecha.month;
  final anio = fecha.year.toString().substring(2);
  final hora = fecha.hour.toString().padLeft(2, '0');
  final min = fecha.minute.toString().padLeft(2, '0');

  return '$dia/$mes/$anio $hora:$min';
}