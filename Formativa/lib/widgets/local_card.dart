import 'package:flutter/material.dart';

import '../models/local.dart';

class LocalCard extends StatelessWidget {
  const LocalCard({super.key, required this.local, required this.onTap, required this.onEdit, required this.onDelete});
  final Local local;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      onTap: onTap,
      leading: CircleAvatar(child: Icon(local.favorito ? Icons.favorite : Icons.place, color: local.favorito ? Colors.red : null)),
      title: Text(local.nome, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('${local.categoria} • ${local.distancia.toStringAsFixed(1)} km'),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.star, color: Colors.amber, size: 18), Text(local.avaliacao.toStringAsFixed(1))]),
        PopupMenuButton<String>(onSelected: (value) => value == 'edit' ? onEdit() : onDelete(), itemBuilder: (_) => const [PopupMenuItem(value: 'edit', child: Text('Editar')), PopupMenuItem(value: 'delete', child: Text('Excluir'))]),
      ]),
    ),
  );
}
