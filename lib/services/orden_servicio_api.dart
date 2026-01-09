import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:talleres/model/orden_servi.dart';

class OrdenServicioApi {
  final String baseUrl = "http://192.168.1.223:8080"; // emulador

  /// 📤 Agregar servicio a orden
  Future<void> agregarServicio(List<OrdenServicio> ordenServicio) async {
    final url = Uri.parse("$baseUrl/api/orden_servi");

    // final body= {
    //   "id": ordenServicio.id,
    //   "orden": ordenServicio.ordens,
    //   "servicios": ordenServicio.servicios,
    //   "cantidad": ordenServicio.cantidad,
    //   "precio": ordenServicio.precio,
    //   "subtotal": ordenServicio.subtotal,
    // };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ordenServicio.map((e) => e.toJson()).toList()),
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

    final url = Uri.parse("$baseUrl/api/orden_servi/${ordenServicio.id}");

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

}
