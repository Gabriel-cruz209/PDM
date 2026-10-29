import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_locais/main.dart';

void main() {
  testWidgets('exibe a busca no mapa', (tester) async {
    await tester.pumpWidget(const MapaLocaisApp());

    expect(find.text('Cidade selecionada'), findsOneWidget);
    expect(find.text('Buscar locais...'), findsOneWidget);
  });
}
