import 'package:flutter/material.dart';

import '../data/mock_locais.dart';
import '../models/local.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/local_result_card.dart';
import 'detalhes_screen.dart';

class ResultadosScreen extends StatefulWidget {
  const ResultadosScreen({
    super.key,
    required this.cidade,
    required this.pesquisa,
    this.somenteFavoritos = false,
  });

  final String cidade;
  final String pesquisa;
  final bool somenteFavoritos;

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  late final TextEditingController _pesquisa;
  late List<Local> _locais;
  late bool _somenteFavoritos;
  String _filtro = 'Todos';

  static const _filtros = ['Todos', 'Academias', 'Restaurantes'];

  @override
  void initState() {
    super.initState();
    _pesquisa = TextEditingController(text: widget.pesquisa);
    _locais = List.of(mockLocais);
    _somenteFavoritos = widget.somenteFavoritos;
  }

  @override
  void dispose() {
    _pesquisa.dispose();
    super.dispose();
  }

  List<Local> get _resultados {
    final termo = _pesquisa.text.trim().toLowerCase();
    return _locais.where((local) {
      final correspondeCidade =
          widget.cidade == 'Todas' || local.cidade == widget.cidade;
      final correspondeFiltro = switch (_filtro) {
        'Academias' => local.categoria == 'Academia',
        'Restaurantes' => local.categoria == 'Restaurante',
        _ => true,
      };
      final correspondeBusca = termo.isEmpty ||
          local.nome.toLowerCase().contains(termo) ||
          local.categoria.toLowerCase().contains(termo);
      return correspondeCidade &&
          correspondeFiltro &&
          correspondeBusca &&
          (!_somenteFavoritos || local.favorito);
    }).toList(growable: false);
  }

  void _alternarFavorito(Local local) {
    setState(() {
      final index = _locais.indexWhere((item) => item.id == local.id);
      _locais[index] = local.copyWith(favorito: !local.favorito);
    });
  }

  void _onNavigationSelected(int index) {
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }
    if (index == 1) {
      setState(() => _somenteFavoritos = true);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Seu perfil estará disponível em breve.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultados = _resultados;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: TextField(
                controller: _pesquisa,
                autofocus: false,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Buscar locais...',
                  prefixIcon:
                      const Icon(Icons.search_rounded, color: AppColors.ink),
                  suffixIcon: IconButton(
                    tooltip: 'Limpar busca',
                    onPressed: _pesquisa.text.isEmpty
                        ? null
                        : () {
                            _pesquisa.clear();
                            setState(() {});
                          },
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filtros.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filtro = _filtros[index];
                  final ativo = filtro == _filtro;
                  return ChoiceChip(
                    label: Text(filtro),
                    avatar: filtro == 'Todos'
                        ? Icon(
                            Icons.grid_view_rounded,
                            color: ativo ? Colors.white : AppColors.muted,
                            size: 16,
                          )
                        : null,
                    selected: ativo,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: ativo ? Colors.white : AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                    onSelected: (_) => setState(() => _filtro = filtro),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: resultados.isEmpty
                  ? _EmptyResults(onShowAll: () {
                      setState(() {
                        _somenteFavoritos = false;
                        _filtro = 'Todos';
                        _pesquisa.clear();
                      });
                    })
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
                      itemCount: resultados.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final local = resultados[index];
                        return LocalResultCard(
                          local: local,
                          onFavorite: () => _alternarFavorito(local),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DetalhesScreen(
                                local: local,
                                onFavoriteChanged: _alternarFavorito,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _somenteFavoritos ? 1 : 0,
        onSelected: _onNavigationSelected,
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onShowAll});
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off_rounded,
                  size: 48, color: AppColors.muted),
              const SizedBox(height: 12),
              const Text(
                'Nenhum local encontrado',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tente outro termo ou remova os filtros aplicados.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 14),
              TextButton(onPressed: onShowAll, child: const Text('Ver todos')),
            ],
          ),
        ),
      );
}
