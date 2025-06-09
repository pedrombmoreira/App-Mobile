import 'package:flutter/material.dart';
import '../models/planta.dart';

class PlantaDetailSheet extends StatelessWidget {
  final Planta planta;

  const PlantaDetailSheet({Key? key, required this.planta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(planta.nomePopular, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          planta.fotoUrl != null && planta.fotoUrl!.isNotEmpty
              ? Image.network(planta.fotoUrl!, height: 200, fit: BoxFit.cover)
              : Container(height: 200, color: Colors.grey, child: const Icon(Icons.image_not_supported, size: 50)),
          const SizedBox(height: 10),
          Text('Nome científico: ${planta.nomeCientifico}'),
          Text('Tipo: ${planta.tipo}'),
          Text('Descrição de manejo: ${planta.descricaoManejo ?? "Não informada"}'),
          Text('Quantidade de mudas: ${planta.quantidadeMudas}'),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
        ],
      ),
    );
  }
}
