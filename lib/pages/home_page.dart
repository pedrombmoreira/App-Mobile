import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/models/planta.dart';
import 'package:myapp/pages/cadastro_planta_page.dart';

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
    final response = await http.get(
      Uri.parse('http://192.168.0.86:8080/api/plantas'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
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
            return Center(
              child: Text('Erro ao conectar com o servidor: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma planta cadastrada.'));
          } else {
            final plantas = snapshot.data!;
            return ListView.builder(
              itemCount: plantas.length,
              itemBuilder: (context, index) {
                final planta = plantas[index];
                const String baseUrl = 'http://192.168.0.86:8080';
                String? finalImageUrl;

                // Lógica para lidar com URLs antigas e uploads novos
                if (planta.fotoUrl != null && planta.fotoUrl!.isNotEmpty) {
                  if (planta.fotoUrl!.startsWith('http')) {
                    // Se o campo já é uma URL completa, usa diretamente
                    finalImageUrl = planta.fotoUrl;
                  } else {
                    // Senão, constrói a URL para acessar o arquivo no servidor
                    finalImageUrl = '$baseUrl/uploads/${planta.fotoUrl}';
                  }
                }

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundImage: finalImageUrl != null
                          ? NetworkImage(finalImageUrl)
                          : null,
                      child: finalImageUrl == null
                          ? const Icon(Icons.eco)
                          : null,
                    ),
                    title: Text(
                      planta.nomePopular,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      planta.nomeCientifico,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (finalImageUrl != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 16.0,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    finalImageUrl,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, progress) =>
                                            progress == null
                                            ? child
                                            : const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                    errorBuilder: (context, error, stack) =>
                                        const Center(
                                          child: Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                        ),
                                  ),
                                ),
                              ),

                            Text(
                              'Tipo: ${planta.tipo}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              'Quantidade em Estoque: ${planta.quantidadeMudas}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),

                            const Text(
                              'Descrição e Manejo:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),

                            Text(
                              planta.descricaoManejo ??
                                  'Nenhuma descrição informada.',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
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
