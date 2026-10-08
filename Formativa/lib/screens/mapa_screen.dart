import 'package:flutter/material.dart';

import '../models/local.dart';
import 'detalhes_screen.dart';
import 'resultados_screen.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key, this.localDestacado});
  final Local? localDestacado;
  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final _pesquisa = TextEditingController();
  String _cidade = 'Todas';
  static const _cidades = ['Todas', 'São Paulo', 'Campinas', 'Jundiaí'];
  final _marcadores = const [
    _Marcador('Café Central', 'São Paulo', Offset(.22, .28)),
    _Marcador('Academia Fitness', 'Campinas', Offset(.68, .24)),
    _Marcador('Parque da Cidade', 'Jundiaí', Offset(.48, .45)),
    _Marcador('Restaurante Sabor', 'São Paulo', Offset(.28, .68)),
    _Marcador('Livraria Horizonte', 'Campinas', Offset(.75, .66)),
    _Marcador('Cinema Plaza', 'Jundiaí', Offset(.54, .78)),
  ];

  @override void dispose() { _pesquisa.dispose(); super.dispose(); }

  void _resultados() => Navigator.push(context, MaterialPageRoute(builder: (_) => ResultadosScreen(cidade: _cidade, pesquisa: _pesquisa.text)));

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Mapa de locais')),
    body: SafeArea(child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        DropdownButtonFormField<String>(value: _cidade, decoration: const InputDecoration(labelText: 'Cidade', prefixIcon: Icon(Icons.location_city), border: OutlineInputBorder()), items: _cidades.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => setState(() => _cidade = v!)),
        const SizedBox(height: 12),
        TextField(controller: _pesquisa, onSubmitted: (_) => _resultados(), decoration: const InputDecoration(labelText: 'O que você procura?', prefixIcon: Icon(Icons.search), border: OutlineInputBorder())),
        const SizedBox(height: 16),
        Expanded(child: LayoutBuilder(builder: (context, constraints) => Semantics(label: 'Representacao visual do mapa com marcadores de locais', child: Container(
          decoration: BoxDecoration(color: const Color(0xffdcefe2), borderRadius: BorderRadius.circular(24), border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
          child: Stack(children: [
            const Positioned(left: -30, top: 90, right: -30, child: Divider(thickness: 28, color: Color(0xffbfd2c5))),
            const Positioned(left: 40, top: 0, bottom: 0, child: VerticalDivider(thickness: 22, color: Color(0xffc7d9ce))),
            const Positioned(right: 60, top: 0, bottom: 0, child: VerticalDivider(thickness: 16, color: Color(0xffc7d9ce))),
            for (final marcador in _marcadores.where((m) => _cidade == 'Todas' || m.cidade == _cidade)) Positioned(left: marcador.posicao.dx * constraints.maxWidth - 22, top: marcador.posicao.dy * constraints.maxHeight - 22, child: Tooltip(message: marcador.nome, child: Material(color: Colors.transparent, child: InkResponse(onTap: () => _mostrarMarcador(marcador), child: const CircleAvatar(backgroundColor: Colors.red, foregroundColor: Colors.white, child: Icon(Icons.location_on))))),
            if (widget.localDestacado != null) Positioned(bottom: 12, left: 12, right: 12, child: Card(color: Theme.of(context).colorScheme.primaryContainer, child: Padding(padding: const EdgeInsets.all(12), child: Text('Local destacado: ${widget.localDestacado!.nome}')))),
          ]),
        )))),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: _resultados, icon: const Icon(Icons.format_list_bulleted), label: const Text('Ver resultados')),
      ]),
    )),
  );

  void _mostrarMarcador(_Marcador marcador) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ResultadosScreen(
        cidade: marcador.cidade,
        pesquisa: marcador.nome,
      ),
    ),
  );
}

class _Marcador { const _Marcador(this.nome, this.cidade, this.posicao); final String nome; final String cidade; final Offset posicao; }
