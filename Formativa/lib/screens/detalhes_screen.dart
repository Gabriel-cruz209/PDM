import 'package:flutter/material.dart';

import '../models/local.dart';
import '../services/local_service.dart';
import 'mapa_screen.dart';

class DetalhesScreen extends StatefulWidget {
  const DetalhesScreen({super.key, required this.local});
  final Local local;

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  final _service = LocalService();
  late Local _local;
  bool _atualizandoFavorito = false;

  @override
  void initState() { super.initState(); _local = widget.local; }

  Future<void> _alternarFavorito() async {
    setState(() => _atualizandoFavorito = true);
    try {
      await _service.alterarFavorito(_local.id, !_local.favorito);
      if (mounted) {
        setState(() => _local = _local.copyWith(favorito: !_local.favorito));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Favorito atualizado.')));
      }
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nao foi possivel realizar a operacao.')));
    } finally { if (mounted) setState(() => _atualizandoFavorito = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detalhes')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Container(height: 180, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(24)), child: Icon(Icons.location_city, size: 80, color: Theme.of(context).colorScheme.onPrimaryContainer)),
      const SizedBox(height: 20),
      Row(children: [Expanded(child: Text(_local.nome, style: Theme.of(context).textTheme.headlineSmall)), IconButton(onPressed: _atualizandoFavorito ? null : _alternarFavorito, icon: Icon(_local.favorito ? Icons.favorite : Icons.favorite_border, color: Colors.red), tooltip: 'Favoritar')]),
      Chip(label: Text(_local.categoria)),
      const SizedBox(height: 12),
      _Info(icon: Icons.star, label: 'Avaliacao', value: '${_local.avaliacao.toStringAsFixed(1)} / 5'),
      _Info(icon: Icons.directions_walk, label: 'Distancia', value: '${_local.distancia.toStringAsFixed(1)} km'),
      _Info(icon: Icons.schedule, label: 'Horario', value: _local.horario),
      _Info(icon: Icons.location_on, label: 'Cidade', value: _local.cidade),
      const Divider(height: 32), Text('Sobre', style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 8), Text(_local.descricao),
      const SizedBox(height: 28),
      OutlinedButton.icon(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MapaScreen(localDestacado: _local)), (route) => route.isFirst), icon: const Icon(Icons.map), label: const Text('Ver no mapa')),
    ]),
  );
}

class _Info extends StatelessWidget {
  const _Info({required this.icon, required this.label, required this.value});
  final IconData icon; final String label; final String value;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 7), child: Row(children: [Icon(icon, size: 20), const SizedBox(width: 12), Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)), Expanded(child: Text(value))]));
}
