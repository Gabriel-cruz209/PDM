import 'package:flutter/material.dart';

import '../dialogs/confirm_delete.dart';
import '../models/local.dart';
import '../services/local_service.dart';
import '../widgets/local_card.dart';
import '../widgets/local_form.dart';
import 'detalhes_screen.dart';

class ResultadosScreen extends StatefulWidget {
  const ResultadosScreen({super.key, required this.cidade, required this.pesquisa});
  final String cidade;
  final String pesquisa;
  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  final _service = LocalService();
  late final TextEditingController _pesquisa;
  late String _cidade;
  String _categoria = 'Todos';
  bool _somenteFavoritos = false;
  static const _cidades = ['Todas', 'São Paulo', 'Campinas', 'Jundiaí'];

  @override void initState() { super.initState(); _pesquisa = TextEditingController(text: widget.pesquisa); _cidade = widget.cidade; }
  @override void dispose() { _pesquisa.dispose(); super.dispose(); }

  void _abrirFormulario([Local? local]) => showModalBottomSheet<bool>(context: context, isScrollControlled: true, builder: (_) => LocalForm(local: local, onSave: (item) async { if (local == null) { await _service.adicionar(item); } else { await _service.atualizar(item); } })).then((saved) { if (saved == true && mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(local == null ? 'Local cadastrado com sucesso.' : 'Local atualizado com sucesso.'))); });

  Future<void> _excluir(Local local) async {
    if (!await confirmarExclusao(context)) return;
    try { await _service.excluir(local.id); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Local excluido com sucesso.'))); }
    catch (_) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nao foi possivel excluir o local.'))); }
  }

  List<Local> _filtrar(List<Local> locais) {
    final termo = _pesquisa.text.trim().toLowerCase();
    return locais.where((l) => (_cidade == 'Todas' || l.cidade == _cidade) && (_categoria == 'Todos' || l.categoria == _categoria) && (!_somenteFavoritos || l.favorito) && (termo.isEmpty || l.nome.toLowerCase().contains(termo) || l.categoria.toLowerCase().contains(termo))).toList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Resultados')),
    floatingActionButton: FloatingActionButton.extended(onPressed: () => _abrirFormulario(), icon: const Icon(Icons.add), label: const Text('Cadastrar')),
    body: StreamBuilder<List<Local>>(
      stream: _service.listarLocais(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('Erro ao carregar os locais.', textAlign: TextAlign.center)));
        final locais = snapshot.data ?? [];
        final categorias = locais
          .map((local) => local.categoria)
          .where((categoria) => categoria.isNotEmpty)
          .toSet()
          .toList()
          ..sort();
        categorias.insert(0, 'Todos');
        if (!categorias.contains(_categoria)) _categoria = 'Todos';
        final resultados = _filtrar(locais);
        return Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 4), child: TextField(controller: _pesquisa, onChanged: (_) => setState(() {}), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Pesquisar nome ou categoria', border: OutlineInputBorder()))),
          SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), child: Row(children: [
            DropdownButton<String>(value: _cidade, items: _cidades.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => setState(() => _cidade = v!)), const SizedBox(width: 16),
            DropdownButton<String>(value: _categoria, items: categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => setState(() => _categoria = v!)),
            FilterChip(label: const Text('Favoritos'), selected: _somenteFavoritos, onSelected: (v) => setState(() => _somenteFavoritos = v)),
          ])),
          Expanded(child: resultados.isEmpty ? const Center(child: Text('Nenhum local encontrado.')) : ListView.builder(padding: const EdgeInsets.fromLTRB(12, 4, 12, 90), itemCount: resultados.length, itemBuilder: (_, i) { final local = resultados[i]; return LocalCard(local: local, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetalhesScreen(local: local))), onEdit: () => _abrirFormulario(local), onDelete: () => _excluir(local)); })),
        ]);
      },
    ),
  );
}
