import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastroPlantaPage extends StatefulWidget {
  const CadastroPlantaPage({Key? key}) : super(key: key);

  @override
  _CadastroPlantaPageState createState() => _CadastroPlantaPageState();
}

class _CadastroPlantaPageState extends State<CadastroPlantaPage> {
  final _formKey = GlobalKey<FormState>();

  final nomePopularController = TextEditingController();
  final nomeCientificoController = TextEditingController();
  final descricaoManejoController = TextEditingController();
  final fotoUrlController = TextEditingController();
  final quantidadeMudasController = TextEditingController();

  String tipoSelecionado = 'Árvore';

  final List<String> tipos = ['Árvore', 'Arbusto', 'Erva', 'Trepadeira'];

  Future<void> cadastrarPlanta() async {
    if (_formKey.currentState!.validate()) {
      final planta = {
        "nome_popular": nomePopularController.text,
        "nome_cientifico": nomeCientificoController.text,
        "tipo": tipoSelecionado,
        "descricao_manejo": descricaoManejoController.text,
        "foto_url": fotoUrlController.text.isEmpty ? null : fotoUrlController.text,
        "quantidade_mudas": int.parse(quantidadeMudasController.text),
      };

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/plantas'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(planta),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Planta cadastrada com sucesso!')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao cadastrar planta')),
        );
      }
    }
  }

  @override
  void dispose() {
    nomePopularController.dispose();
    nomeCientificoController.dispose();
    descricaoManejoController.dispose();
    fotoUrlController.dispose();
    quantidadeMudasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Planta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomePopularController,
                decoration: const InputDecoration(labelText: 'Nome Popular'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: nomeCientificoController,
                decoration: const InputDecoration(labelText: 'Nome Científico'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              DropdownButtonFormField<String>(
                value: tipoSelecionado,
                items: tipos.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    tipoSelecionado = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              TextFormField(
                controller: descricaoManejoController,
                decoration: const InputDecoration(labelText: 'Descrição de Manejo'),
              ),
              TextFormField(
                controller: fotoUrlController,
                decoration: const InputDecoration(labelText: 'URL da Foto'),
              ),
              TextFormField(
                controller: quantidadeMudasController,
                decoration: const InputDecoration(labelText: 'Quantidade de Mudas'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: cadastrarPlanta,
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}