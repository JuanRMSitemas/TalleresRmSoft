import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:talleres/model/orden_servi.dart';

class OrdenServicioApi {
  final String baseUrl = "http://192.168.1.223:8080"; // emulador

  /// 📤 Agregar servicio a orden
  Future<void> agregarServicio(OrdenServicio ordenServicio) async {
    final url = Uri.parse("$baseUrl/api/orden_servi");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ordenServicio.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al registrar servicio en la orden');
    }
  }

  /// ✏️ Actualizar servicio de la orden
  Future<void> actualizarServicio(OrdenServicio ordenServicio) async {
    if (ordenServicio.id == null) {
      throw Exception('El ID es obligatorio para actualizar');
    }

    final url =
        Uri.parse("$baseUrl/api/orden_servi/${ordenServicio.id}");

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ordenServicio.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar servicio');
    }
  }

}
