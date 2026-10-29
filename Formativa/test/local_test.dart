import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_locais/models/local.dart';

void main() {
  test('converte dados ausentes em valores seguros', () {
    final local = Local.fromMap('abc', {'nome': 'Academia'});
    expect(local.id, 'abc');
    expect(local.nome, 'Academia');
    expect(local.avaliacao, 0);
    expect(local.favorito, isFalse);
  });

  test('toMap nao inclui o id do documento', () {
    const local = Local(id: 'abc', nome: 'Cafe', categoria: 'Cafe', cidade: 'Campinas', avaliacao: 4.5, distancia: 2, horario: '08:00', descricao: 'Descricao', favorito: true);
    expect(local.toMap()['nome'], 'Cafe');
    expect(local.toMap().containsKey('id'), isFalse);
  });

  test('converte valores numericos em texto e preserva o favorito ao copiar', () {
    final local = Local.fromMap('abc', {
      'avaliacao': '4.5',
      'distancia': '1,2',
      'favorito': true,
    });

    expect(local.avaliacao, 4.5);
    expect(local.distancia, 1.2);
    expect(local.copyWith().favorito, isTrue);
    expect(local.copyWith(favorito: false).favorito, isFalse);
  });
}
