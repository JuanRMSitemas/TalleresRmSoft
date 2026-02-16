import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:talleres/model/orden.dart';

class OrdenService {
  final String baseUrl = "http://192.168.1.223:8080"; // Si usas emulador

  Future<bool> crearOrden(Orden orden) async {
    final url = Uri.parse("$baseUrl/api/orden");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orden.toJson()),
    );
    debugPrint(jsonEncode(orden.toJson()));
    debugPrint('Cuerpo de la respuesta: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      //final Map<String, dynamic> data = jsonDecode(response.body);
      return true;
    } else {
      debugPrint("Error: ${response.body}");
      throw Exception("Error al crear la orden: ${response.body}");
    }
  }

  Future<bool> actualizarOrden(String ordenId) async {
    final url = Uri.parse('$baseUrl/api/orden/$ordenId');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'estado': 2
      }),
    );

    return response.statusCode == 200;
  }

  Future<void> actualizarMedioPago(String ordenId,Map<String, dynamic> body,) async {
  final url = Uri.parse('$baseUrl/api/orden/actualizarpago/$ordenId');

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
    debugPrint('Medio de pago actualizado correctamente');
  } else {
    throw Exception('Error al actualizar el medio de pago: ${response.body}');
  }
}

  Future<Orden?> buscarUltimaOrden(String nit, int? id) async {
  final url = Uri.parse("$baseUrl/api/orden/ultima/$nit/$id");
  final response = await http.get(url);

    if (response.statusCode == 200|| response.statusCode == 201) {
      debugPrint('📦 response.body = ${response.body}');
      return Orden.fromIdJson(jsonDecode(response.body));
    }
    if (response.statusCode == 404) {
      return null;
    }
    throw Exception("Error al consultar la ultima Orden");
  }

  Future<List<Orden>> obtenerOrdenesTaller() async {
    final url = Uri.parse('$baseUrl/api/orden/taller');

    final response = await http.get(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List data = jsonDecode(response.body);
      debugPrint('📦 Ordenes recibidas: $data');
      return data.map((e) => Orden.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar órdenes - HOME_Flutter');
    }
  }

  Future<void> eliminarOrden(String ordenId) async {
    final url = Uri.parse('$baseUrl/api/orden/eliminar/$ordenId');

    final response = await http.delete(url);

    if (response.statusCode == 200 || response.statusCode == 204 || response.statusCode == 201) {
      debugPrint('Orden eliminada correctamente');
    } else {
      debugPrintStack(label: 'Error al eliminar la orden: ${response.body}');
      throw Exception('Error al eliminar la orden');
    }
  }

  Future<void> actualizarEstadosOdn(String ordenId, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/api/orden/estados/$ordenId');

    if (body.isEmpty) {
      throw Exception('-►Body vacío al actualizar estado');
    }

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
      debugPrint('✅ Estado de la orden actualizado correctamente');
    } else {
      throw Exception('Error al actualizar el estado de la orden ${response.body}');
    }
  }
}