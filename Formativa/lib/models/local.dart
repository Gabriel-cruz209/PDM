/// Representa um documento da colecao `locais` no Cloud Firestore.
class Local {
  const Local({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.cidade,
    required this.avaliacao,
    required this.distancia,
    required this.horario,
    required this.descricao,
    required this.favorito,
    this.imagemUrl = '',
    this.totalAvaliacoes = 124,
  });

  final String id;
  final String nome;
  final String categoria;
  final String cidade;
  final double avaliacao;
  final double distancia;
  final String horario;
  final String descricao;
  final bool favorito;
  final String imagemUrl;
  final int totalAvaliacoes;

  factory Local.fromMap(String id, Map<String, dynamic> data) => Local(
        id: id,
        nome: data['nome']?.toString() ?? '',
        categoria: data['categoria']?.toString() ?? '',
        cidade: data['cidade']?.toString() ?? '',
        avaliacao: _asDouble(data['avaliacao']),
        distancia: _asDouble(data['distancia']),
        horario: data['horario']?.toString() ?? '',
        descricao: data['descricao']?.toString() ?? '',
        favorito: data['favorito'] == true,
        imagemUrl: data['imagemUrl']?.toString() ?? '',
        totalAvaliacoes: _asInt(data['totalAvaliacoes'], 124),
      );

  static double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString().replaceAll(',', '.') ?? '') ?? 0;
  }

  static int _asInt(dynamic value, int fallback) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  Map<String, dynamic> toMap() => {
        'nome': nome,
        'categoria': categoria,
        'cidade': cidade,
        'avaliacao': avaliacao,
        'distancia': distancia,
        'horario': horario,
        'descricao': descricao,
        'favorito': favorito,
        'imagemUrl': imagemUrl,
        'totalAvaliacoes': totalAvaliacoes,
      };

  Local copyWith({bool? favorito}) => Local(
        id: id,
        nome: nome,
        categoria: categoria,
        cidade: cidade,
        avaliacao: avaliacao,
        distancia: distancia,
        horario: horario,
        descricao: descricao,
        favorito: favorito ?? this.favorito,
        imagemUrl: imagemUrl,
        totalAvaliacoes: totalAvaliacoes,
      );
}
