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
  final url = Uri.parse('$baseUrl/api/orden/actualizar/$ordenId');

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  if (response.statusCode != 200) {
    throw Exception('Error al actualizar el medio de pago');
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


}