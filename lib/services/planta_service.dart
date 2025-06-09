import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/planta.dart';

class PlantaService {
  static const _baseUrl = 'http://10.0.2.2:8080/api/plantas';

  static Future<List<Planta>> fetchPlantas() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Planta.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar plantas: ${response.statusCode}');
    }
  }

  static Future<bool> cadastrarPlanta(Map<String, dynamic> planta) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(planta),
    );
    return response.statusCode == 201;
  }
}
