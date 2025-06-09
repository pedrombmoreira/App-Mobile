class Planta {
  final int id;
  final String nomePopular;
  final String nomeCientifico;
  final String tipo;
  final String? descricaoManejo;
  final String? fotoUrl;
  final int quantidadeMudas;

  Planta({
    required this.id,
    required this.nomePopular,
    required this.nomeCientifico,
    required this.tipo,
    this.descricaoManejo,
    this.fotoUrl,
    required this.quantidadeMudas,
  });

  factory Planta.fromJson(Map<String, dynamic> json) {
    return Planta(
      id: json['id'],
      nomePopular: json['nome_popular'],
      nomeCientifico: json['nome_cientifico'],
      tipo: json['tipo'],
      descricaoManejo: json['descricao_manejo'],
      fotoUrl: json['foto_url'],
      quantidadeMudas: json['quantidade_mudas'],
    );
  }
}