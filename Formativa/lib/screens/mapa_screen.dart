import 'package:flutter/material.dart';

import '../data/mock_locais.dart';
import '../models/local.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/map_surface.dart';
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
  String _cidade = 'São Paulo';
  late String _selectedId;

  static const _cidades = ['São Paulo', 'Campinas', 'Jundiaí'];

  @override
  void initState() {
    super.initState();
    _selectedId = widget.localDestacado?.id ?? mockLocais.first.id;
  }

  @override
  void dispose() {
    _pesquisa.dispose();
    super.dispose();
  }

  void _abrirResultados({bool favoritesOnly = false}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultadosScreen(
          cidade: _cidade,
          pesquisa: _pesquisa.text,
          somenteFavoritos: favoritesOnly,
        ),
      ),
    );
  }

  void _onNavigationSelected(int index) {
    if (index == 1) {
      _abrirResultados(favoritesOnly: true);
      return;
    }
    if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seu perfil estará disponível em breve.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locaisDaCidade = mockLocais
        .where((local) => local.cidade == _cidade)
        .toList(growable: false);
    final locaisVisiveis = locaisDaCidade.isEmpty ? mockLocais : locaisDaCidade;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: MapSurface(
                locais: locaisVisiveis,
                selectedId: _selectedId,
                onSelect: (local) {
                  setState(() => _selectedId = local.id);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => DetalhesScreen(local: local)),
                  );
                },
              ),
            ),
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: _SearchPanel(
                cidade: _cidade,
                cidades: _cidades,
                controller: _pesquisa,
                onCidadeChanged: (cidade) => setState(() => _cidade = cidade),
                onSubmitted: (_) => _abrirResultados(),
                onSearchTap: _abrirResultados,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 0,
        onSelected: _onNavigationSelected,
      ),
    );
  }
}

class _SearchPanel extends StatelessWidget {
  const _SearchPanel({
    required this.cidade,
    required this.cidades,
    required this.controller,
    required this.onCidadeChanged,
    required this.onSubmitted,
    required this.onSearchTap,
  });

  final String cidade;
  final List<String> cidades;
  final TextEditingController controller;
  final ValueChanged<String> onCidadeChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1a0e1f2f), blurRadius: 20, offset: Offset(0, 7)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: cidade,
              isDense: true,
              decoration: const InputDecoration(
                labelText: 'Cidade selecionada',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: cidades
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) {
                if (value != null) onCidadeChanged(value);
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                hintText: 'Buscar locais...',
                prefixIcon:
                    const Icon(Icons.search_rounded, color: AppColors.muted),
                suffixIcon: IconButton(
                  tooltip: 'Ver resultados',
                  onPressed: onSearchTap,
                  icon:
                      const Icon(Icons.tune_rounded, color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      );
}
