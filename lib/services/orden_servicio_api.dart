import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:talleres/model/orden_servi.dart';

class OrdenServicioApi {
  final String baseUrl = "http://192.168.1.223:8080"; // emulador

  Future<List<OrdenServicio>> listarPorOrden(String ordenId) async {
    final url = Uri.parse('$baseUrl/api/ordenservicio/$ordenId/servicios');

    final response = await http.get(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List data = jsonDecode(response.body);
      debugPrint('Servicios de la orden: $data');
      return data.map((e) => OrdenServicio.fromJson(e)).toList();
    } else {
      throw Exception('Error cargando servicios de la orden');
    }
  }
  
  /// 📤 Agregar servicio a orden
  Future<void> agregarServicio(String ordenId, OrdenServicio ordenes) async {
    final url = Uri.parse("$baseUrl/api/ordenservicio/$ordenId/agregar");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ordenes.toJson()),
    );
    debugPrint('Cuerpo de la respuesta Orden de servicios: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('📦 response.body - Status CORRECTO = ${response.body}');
      return ;
    } else {
      throw Exception('Error al AGREGAR servicio');
    }
  }

  /// ✏️ Actualizar servicio de la orden
  Future<bool> actualizarServicio(OrdenServicio ordenServicio) async {
    if (ordenServicio.id == null) {
      throw Exception('El ID es obligatorio para actualizar');
    }

    final url = Uri.parse("$baseUrl/api/ordenservicio/${ordenServicio.id}/actualizar");

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ordenServicio.toJson()),
    );
    debugPrint('Cuerpo de la respuesta: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error al ACTUALIZAR servicio');
    }
  }

    /// 🗑️ Eliminar servicio de la orden
  Future<bool> eliminarServicio(String id, String codServ) async {
    final url = Uri.parse("$baseUrl/api/ordenservicio/eliminarservordn/$id/$codServ");

    final response = await http.delete(url);

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Error al ELIMINAR servicio');
    }
  }
}