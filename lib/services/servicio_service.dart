import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:talleres/model/servicio.dart';

class ServicioService {
  final String baseUrl = "http://10.0.2.2:8080"; // Si usas emulador

  Future<List<Servicio>> listarServicios() async{
    final url = Uri.parse("$baseUrl/api/servicio");
    final response =  await http.get(url, headers: {'Content-Type': 'application/json'});

    debugPrint('Status: ${response.statusCode}');
    debugPrint('Body: ${response.body}');

    if (response.statusCode == 200|| response.statusCode == 201) {
      final List data = jsonDecode(response.body);
      return data.map((e)=> Servicio.fromJson(e)).toList();
    }else{
      throw Exception("Error al consultar Servicios");
    }
  }
  
}