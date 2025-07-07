import 'package:flutter/material.dart';
import '../models/planta.dart';

class PlantaDetailSheet extends StatelessWidget {
  final Planta planta;
  final String baseUrl = 'http://192.168.0.86:8080';

  const PlantaDetailSheet({Key? key, required this.planta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? urlImagemCompleta =
        planta.fotoUrl != null && planta.fotoUrl!.isNotEmpty
        ? '$baseUrl/uploads/${planta.fotoUrl}'
        : null;

    return SingleChildScrollView(
      // Adiciona padding na parte inferior pro botão de fechar não ficar colado
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              planta.nomePopular,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: urlImagemCompleta != null
                  ? Image.network(
                      urlImagemCompleta,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            planta.nomeCientifico,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 8),

          Text('Tipo: ${planta.tipo}', style: const TextStyle(fontSize: 16)),

          const SizedBox(height: 8),

          Text(
            'Quantidade em Estoque: ${planta.quantidadeMudas}',
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 16),

          const Text(
            'Descrição e Manejo:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          Text(
            planta.descricaoManejo ?? "Nenhuma descrição informada.",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
