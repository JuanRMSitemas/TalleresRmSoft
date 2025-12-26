import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:talleres/model/cliente.dart';
import 'package:talleres/model/orden.dart';
import 'package:talleres/model/vehiculo.dart';

import 'package:flutter/foundation.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8080"; // emulador
  // final String baseUrl = "http://192.168.0.X:8080"; // Si usas celular real

  ///Aqui se registra el cliente y el vehiculo el cual se relacioanara con la orden
  Future<bool> registrarClienteVehiculo(Vehiculo vehiculo, Cliente cliente) async {
    final url = Uri.parse("$baseUrl/api/registro");
    
    final body ={
      "nit": cliente.numeroId,
      "tipoDocumento": cliente.tipoId,
      "nombre": cliente.nombre,
      "email":cliente.email,
      "celular": cliente.celular,

      "placa": vehiculo.placa,
      "tipo": vehiculo.tipo,
      "modelo": vehiculo.modelo,
      "marca": vehiculo.marca,
    };

    final response = await http.post( //Post envia para registrar o guardar en la DB
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if(response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      debugPrint("Error: ${response.body}");
      return false;
    }
  }


  Future<bool> crearOrden(Orden orden) async {
    final url = Uri.parse("$baseUrl/api/orden");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orden.toJson()),
    );

    debugPrint('Cuerpo de la respuesta: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      debugPrint("Error: ${response.body}");
      return false;
    }
  }
}