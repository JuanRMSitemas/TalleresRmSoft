import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:talleres/model/cliente.dart';
import 'package:talleres/model/vehiculo.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8080"; // Si usas emulador
  // final String baseUrl = "http://192.168.0.X:8080"; // Si usas celular real

  Future<bool> registrarCliente(Cliente cliente) async {
    final url = Uri.parse("$baseUrl/api/cliente");
    
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cliente.toJson()),
    );

    if(response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      debugPrint("Error: ${response.body}");
      return false;
    }
  }

  Future<bool> registrarVehiculo(Vehiculo vehiculo) async {
    final url = Uri.parse("$baseUrl/api/vehiculo");
    
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(vehiculo.toJson()),
    );

    if(response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      debugPrint("Error: ${response.body}");
      return false;
    }
  }
}