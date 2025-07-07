import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/planta.dart';

class PlantaService {
  static const _baseUrl = 'http://192.168.0.86:8080/api/plantas';

  static Future<List<Planta>> fetchPlantas() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Planta.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar plantas: ${response.statusCode}');
    }
  }

  static Future<bool> cadastrarPlantaComImagem({
    required String nomePopular,
    required String nomeCientifico,
    required String tipo,
    String? descricao,
    required int quantidade,
    File? imagem,
  }) async {
    var uri = Uri.parse(_baseUrl);
    var request = http.MultipartRequest('POST', uri);

    request.fields['nome_popular'] = nomePopular;
    request.fields['nome_cientifico'] = nomeCientifico;
    request.fields['tipo'] = tipo;
    request.fields['descricao_manejo'] = descricao!;
    request.fields['quantidade'] = quantidade.toString();

    if (imagem != null) {
      request.files.add(
        await http.MultipartFile.fromPath('imagemFile', imagem.path),
      );
    }

    try {
      var streamedResponse = await request.send();
      // Convertemos o stream para uma resposta completa para ler o corpo
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        print('SUCESSO: Planta cadastrada!');
        return true;
      } else {
        // Se não for sucesso, imprimimos o status e a resposta do servidor
        print('FALHA NO CADASTRO. Status Code: ${response.statusCode}');
        print('RESPOSTA DO SERVIDOR: ${response.body}');
        return false;
      }
    } catch (e) {
      // Se houver um erro de conexão/rede, imprimimos aqui
      print('--- ERRO DE CONEXÃO/REQUISIÇÃO ---');
      print(e.toString());
      return false;
    }
  }
}
