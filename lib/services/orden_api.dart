import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:talleres/model/orden.dart';

class OrdenService {
  final String baseUrl = "http://10.0.2.2:8080"; // Si usas emulador

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