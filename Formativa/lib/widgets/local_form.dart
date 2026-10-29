import 'package:flutter/material.dart';

import '../models/local.dart';

class LocalForm extends StatefulWidget {
  const LocalForm({super.key, this.local, required this.onSave});

  final Local? local;
  final Future<void> Function(Local local) onSave;

  @override
  State<LocalForm> createState() => _LocalFormState();
}

class _LocalFormState extends State<LocalForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nome;
  late final TextEditingController _categoria;
  late final TextEditingController _horario;
  late final TextEditingController _avaliacao;
  late final TextEditingController _distancia;
  late final TextEditingController _descricao;
  String? _cidade;
  bool _salvando = false;
  static const _cidades = ['São Paulo', 'Campinas', 'Jundiaí'];

  @override
  void initState() {
    super.initState();
    final local = widget.local;
    _nome = TextEditingController(text: local?.nome);
    _categoria = TextEditingController(text: local?.categoria);
    _horario = TextEditingController(text: local?.horario);
    _avaliacao = TextEditingController(text: local?.avaliacao.toString());
    _distancia = TextEditingController(text: local?.distancia.toString());
    _descricao = TextEditingController(text: local?.descricao);
    _cidade = _cidades.contains(local?.cidade) ? local!.cidade : null;
  }

  @override
  void dispose() {
    _nome.dispose();
    _categoria.dispose();
    _horario.dispose();
    _avaliacao.dispose();
    _distancia.dispose();
    _descricao.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    try {
      await widget.onSave(Local(
        id: widget.local?.id ?? '',
        nome: _nome.text.trim(),
        categoria: _categoria.text.trim(),
        cidade: _cidade!,
        horario: _horario.text.trim(),
        descricao: _descricao.text.trim(),
        avaliacao: double.parse(_avaliacao.text.replaceAll(',', '.')),
        distancia: double.parse(_distancia.text.replaceAll(',', '.')),
        favorito: widget.local?.favorito ?? false,
      ));
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Nao foi possivel realizar a operacao.')),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  String? _obrigatorio(String? value, String campo) =>
      value == null || value.trim().isEmpty ? '$campo e obrigatorio.' : null;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                      widget.local == null ? 'Cadastrar local' : 'Editar local',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  TextFormField(
                      controller: _nome,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (v) => _obrigatorio(v, 'Nome')),
                  TextFormField(
                      controller: _categoria,
                      decoration: const InputDecoration(labelText: 'Categoria'),
                      validator: (v) => _obrigatorio(v, 'Categoria')),
                  DropdownButtonFormField<String>(
                      initialValue: _cidade,
                      decoration: const InputDecoration(labelText: 'Cidade'),
                      items: _cidades
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => _cidade = v),
                      validator: (v) =>
                          v == null ? 'Cidade e obrigatoria.' : null),
                  TextFormField(
                      controller: _horario,
                      decoration: const InputDecoration(labelText: 'Horário'),
                      validator: (v) => _obrigatorio(v, 'Horário')),
                  TextFormField(
                      controller: _avaliacao,
                      decoration:
                          const InputDecoration(labelText: 'Avaliação (0 a 5)'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        final n =
                            double.tryParse((v ?? '').replaceAll(',', '.'));
                        return n == null || n < 0 || n > 5
                            ? 'Informe um número de 0 a 5.'
                            : null;
                      }),
                  TextFormField(
                      controller: _distancia,
                      decoration:
                          const InputDecoration(labelText: 'Distância (km)'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        final n =
                            double.tryParse((v ?? '').replaceAll(',', '.'));
                        return n == null || n < 0
                            ? 'Informe uma distância válida.'
                            : null;
                      }),
                  TextFormField(
                      controller: _descricao,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      maxLines: 3,
                      validator: (v) => _obrigatorio(v, 'Descrição')),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                      onPressed: _salvando ? null : _submit,
                      icon: _salvando
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.save),
                      label: Text(_salvando ? 'Salvando...' : 'Salvar')),
                ]),
          ),
        ),
      );
}
