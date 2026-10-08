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
      );

  static double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
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
      );
}
