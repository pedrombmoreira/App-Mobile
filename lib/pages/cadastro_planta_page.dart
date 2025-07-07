import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/services/planta_service.dart';

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
  final quantidadeMudasController = TextEditingController();

  String tipoSelecionado = 'Árvore';
  final List<String> tipos = ['Árvore', 'Arbusto', 'Erva', 'Trepadeira'];
  File? _imagemSelecionada;
  final _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _tirarFoto() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() => _imagemSelecionada = File(pickedFile.path));
    }
  }

  Future<void> _escolherDaGaleria() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() => _imagemSelecionada = File(pickedFile.path));
    }
  }

  Future<void> cadastrarPlanta() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      bool sucesso = await PlantaService.cadastrarPlantaComImagem(
        nomePopular: nomePopularController.text,
        nomeCientifico: nomeCientificoController.text,
        tipo: tipoSelecionado,
        descricao: descricaoManejoController.text,
        quantidade: int.tryParse(quantidadeMudasController.text) ?? 0,
        imagem: _imagemSelecionada,
      );

      setState(() => _isLoading = false);

      if (mounted) {
        if (sucesso) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Planta cadastrada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao cadastrar planta'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    nomePopularController.dispose();
    nomeCientificoController.dispose();
    descricaoManejoController.dispose();
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
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: nomeCientificoController,
                decoration: const InputDecoration(labelText: 'Nome Científico'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: tipoSelecionado,
                items: tipos.map((tipo) {
                  return DropdownMenuItem(value: tipo, child: Text(tipo));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      tipoSelecionado = value;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: descricaoManejoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição de Manejo',
                ),
                maxLines: 3, // Permite mais linhas para a descrição
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: quantidadeMudasController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade em Estoque',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 200,
                width: double.infinity,
                child: _imagemSelecionada != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.file(
                          _imagemSelecionada!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Center(child: Text('Nenhuma imagem selecionada')),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _tirarFoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Câmera'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _escolherDaGaleria,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galeria'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: cadastrarPlanta,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cadastrar Planta'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
