import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const AppCadastro());
}

class AppCadastro extends StatelessWidget {
  const AppCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Alunos',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _cursoController = TextEditingController();

  CollectionReference<Map<String, dynamic>> get _alunos =>
      FirebaseFirestore.instance.collection('alunos');

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _cursoController.dispose();
    super.dispose();
  }

  void _mostrarMensagem(String mensagem, {bool erro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: erro ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> cadastrarAluno() async {
    final nome = _nomeController.text.trim();
    final curso = _cursoController.text.trim();
    final idade = int.tryParse(_idadeController.text.trim());

    if (nome.isEmpty || curso.isEmpty || idade == null || idade <= 0) {
      _mostrarMensagem('Preencha nome, curso e uma idade válida.', erro: true);
      return;
    }

    try {
      await _alunos.add({
        'nome': nome,
        'idade': idade,
        'curso': curso,
        'criadoEm': FieldValue.serverTimestamp(),
      });
      _nomeController.clear();
      _idadeController.clear();
      _cursoController.clear();
      _mostrarMensagem('Aluno cadastrado com sucesso.');
    } on FirebaseException catch (erro) {
      _mostrarMensagem('Não foi possível cadastrar: ${erro.message}', erro: true);
    }
  }

  Future<void> _editarAluno(String id, Map<String, dynamic> aluno) async {
    final nomeController = TextEditingController(text: aluno['nome'] ?? '');
    final idadeController = TextEditingController(
      text: aluno['idade']?.toString() ?? '',
    );
    final cursoController = TextEditingController(text: aluno['curso'] ?? '');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Editar aluno'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _campoTexto(controller: nomeController, label: 'Nome'),
              const SizedBox(height: 12),
              _campoTexto(
                controller: idadeController,
                label: 'Idade',
                tipo: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _campoTexto(controller: cursoController, label: 'Curso'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final nome = nomeController.text.trim();
              final curso = cursoController.text.trim();
              final idade = int.tryParse(idadeController.text.trim());

              if (nome.isEmpty || curso.isEmpty || idade == null || idade <= 0) {
                _mostrarMensagem(
                  'Preencha todos os campos corretamente.',
                  erro: true,
                );
                return;
              }

              try {
                await _alunos.doc(id).update({
                  'nome': nome,
                  'idade': idade,
                  'curso': curso,
                });
                if (dialogContext.mounted) Navigator.pop(dialogContext);
                _mostrarMensagem('Cadastro atualizado.');
              } on FirebaseException catch (erro) {
                _mostrarMensagem(
                  'Não foi possível editar: ${erro.message}',
                  erro: true,
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    nomeController.dispose();
    idadeController.dispose();
    cursoController.dispose();
  }

  Future<void> _confirmarExclusao(String id, String nome) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir aluno?'),
        content: Text('Deseja realmente excluir $nome?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await _alunos.doc(id).delete();
      _mostrarMensagem('Aluno excluído.');
    } on FirebaseException catch (erro) {
      _mostrarMensagem('Não foi possível excluir: ${erro.message}', erro: true);
    }
  }

  Widget _campoTexto({
    required TextEditingController controller,
    required String label,
    TextInputType? tipo,
  }) {
    return TextField(
      controller: controller,
      keyboardType: tipo,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Alunos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _campoTexto(controller: _nomeController, label: 'Nome'),
            const SizedBox(height: 12),
            _campoTexto(
              controller: _idadeController,
              label: 'Idade',
              tipo: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _campoTexto(controller: _cursoController, label: 'Curso'),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: cadastrarAluno,
                icon: const Icon(Icons.person_add),
                label: const Text('Cadastrar aluno'),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Alunos cadastrados', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _alunos.orderBy('nome').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar os alunos.'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final alunos = snapshot.data!.docs;
                  if (alunos.isEmpty) {
                    return const Center(child: Text('Nenhum aluno cadastrado.'));
                  }

                  return ListView.builder(
                    itemCount: alunos.length,
                    itemBuilder: (context, index) {
                      final documento = alunos[index];
                      final aluno = documento.data();

                      return Card(
                        child: ListTile(
                          title: Text(aluno['nome'] ?? ''),
                          subtitle: Text(
                            '${aluno['idade'] ?? ''} anos\n${aluno['curso'] ?? ''}',
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                tooltip: 'Editar',
                                onPressed: () =>
                                    _editarAluno(documento.id, aluno),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Excluir',
                                onPressed: () => _confirmarExclusao(
                                  documento.id,
                                  aluno['nome'] ?? 'este aluno',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
