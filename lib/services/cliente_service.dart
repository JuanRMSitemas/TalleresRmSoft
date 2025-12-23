import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:talleres/model/cliente.dart';


//Aqui se busca los clientes ya registrados o existentes en la DB
class ClienteService {
  final String baseUrl = "http://10.0.2.2:8080"; // Si usas emulador

  Future<Cliente?> buscarCliente(String nit) async {
  final url = Uri.parse("$baseUrl/api/cliente/$nit");
  final response = await http.get(url);

    if (response.statusCode == 200|| response.statusCode == 201) {
      return Cliente.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode == 404) {
      return null;
    }
    throw Exception("Error al consultar cliente");
  }
}