import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:talleres/model/cliente.dart';
import 'package:talleres/model/vehiculo.dart';

class ApiService {
  final String baseUrl = "http://192.168.1.223:8080"; // para usar el celular real
  // final String baseUrl = "http://10.0.2.2:8080"; // Usar en emulador

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
    } 
    else {
      final error = jsonDecode(response.body);
      final mensaje = error['message'] ?? 'Error inesperado';

      throw Exception(mensaje);
    }
  }

}