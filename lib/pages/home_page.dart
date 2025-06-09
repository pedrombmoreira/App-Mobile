import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/main.dart';
import 'package:myapp/models/planta.dart';
import 'package:myapp/pages/cadastro_planta_page.dart';
import 'package:myapp/widgets/planta_detail_sheet.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Planta>> futurasPlantas;

  @override
  void initState() {
    super.initState();
    futurasPlantas = fetchPlantas();
  }

  Future<List<Planta>> fetchPlantas() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/plantas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Planta.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar plantas: ${response.statusCode}');
    }
  }

  void atualizarLista() {
    setState(() {
      futurasPlantas = fetchPlantas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Planta>>(
        future: futurasPlantas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma planta cadastrada.'));
          } else {
            final plantas = snapshot.data!;
            return ListView.builder(
              itemCount: plantas.length,
              itemBuilder: (context, index) {
                final planta = plantas[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(Icons.eco),
                    title: Text(planta.nomePopular),
                    subtitle: Text('ID: ${planta.id}'),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => PlantaDetailSheet(planta: planta),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CadastroPlantaPage()),
          );
          if (result == true) {
            atualizarLista();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}