

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:talleres/model/vehiculo.dart';

class VehiculoApi {
  final String baseUrl = "http://192.168.1.223:8080"; // Si usas emulador

  Future<Vehiculo?> buscarVehiculo(String placa) async{ // busca la id del vehiculo por la placa
    final url = Uri.parse("$baseUrl/api/vehiculo/$placa");
    final response = await http.get(url);

    if(response.statusCode == 200 || response.statusCode ==201){
      return Vehiculo.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode == 404) {
      return null;
    }
    throw Exception("Error al consultar cliente");
  }

}