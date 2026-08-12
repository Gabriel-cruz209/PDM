import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppCadastro(),
    ),
  );
}

// App "Cadastro de Alunos"
// O aluno deverá criar um pequeno aplicativo para cadastrar alunos.
//
// Interface:
// - Campo Nome
// - Campo Idade
// - Campo Curso
// - Botão Cadastrar
// - Lista dos Alunos cadastrados

class AppCadastro extends StatefulWidget {
  const AppCadastro({super.key});

  @override
  State<AppCadastro> createState() => _AppCadastroState();
}

class _AppCadastroState extends State<AppCadastro> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerCurso = TextEditingController();
  final TextEditingController controllerIdade = TextEditingController();

  List<Map<String, dynamic>> dados = [];

  // Criar banco de dados
  Future<Database> criarBanco() async {
    final caminho = await getDatabasesPath();
    final caminhoBanco = join(caminho, "banco.db");

    return openDatabase(
      caminhoBanco,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE dados (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            idade INTEGER,
            curso TEXT,
            data TEXT
          )
          ''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE dados ADD COLUMN data TEXT",
          );
        }
      },
      version: 2,
    );
  }

  // Inserir aluno
  Future<void> inserirDados(
    String nome,
    int idade,
    String curso,
  ) async {
    final db = await criarBanco();

    final agora = DateTime.now();

    final dataFormatada =
        "${agora.day.toString().padLeft(2, '0')}/"
        "${agora.month.toString().padLeft(2, '0')}/"
        "${agora.year} "
        "${agora.hour.toString().padLeft(2, '0')}:"
        "${agora.minute.toString().padLeft(2, '0')}";

    await db.insert("dados", {
      "nome": nome,
      "idade": idade,
      "curso": curso,
      "data": dataFormatada,
    });

    await carregarDados();
  }

  // Carregar alunos
  Future<void> carregarDados() async {
    final db = await criarBanco();

    final lista = await db.query(
      "dados",
      orderBy: "nome ASC",
    );

    if (!mounted) return;

    setState(() {
      dados = lista;
    });
  }

  // Deletar aluno
  Future<void> deletarDados(int id) async {
    final db = await criarBanco();

    await db.delete(
      "dados",
      where: "id = ?",
      whereArgs: [id],
    );

    await carregarDados();
  }

  // Atualizar aluno
  Future<void> atualizarDados(
    int id,
    String nome,
    int idade,
    String curso,
  ) async {
    final db = await criarBanco();

    await db.update(
      "dados",
      {
        "nome": nome,
        "idade": idade,
        "curso": curso,
      },
      where: "id = ?",
      whereArgs: [id],
    );

    await carregarDados();
  }

  // Abrir tela de edição
  void abrirEdicao(
    BuildContext ctx,
    Map<String, dynamic> item,
  ) {
    final editNome = TextEditingController(
      text: item["nome"]?.toString() ?? "",
    );

    final editIdade = TextEditingController(
      text: item["idade"]?.toString() ?? "",
    );

    final editCurso = TextEditingController(
      text: item["curso"]?.toString() ?? "",
    );

    showDialog(
      context: ctx,
      builder: (buildContext) {
        return AlertDialog(
          title: const Text("Editar Cadastro"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editNome,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: editIdade,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Idade",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: editCurso,
                decoration: const InputDecoration(
                  labelText: "Curso",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(buildContext);
              },
              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              onPressed: () {
                final idade = int.tryParse(editIdade.text);

                if (editNome.text.isEmpty ||
                    idade == null ||
                    editCurso.text.isEmpty) {
                  return;
                }

                atualizarDados(
                  item["id"],
                  editNome.text,
                  idade,
                  editCurso.text,
                );

                Navigator.pop(buildContext);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    carregarDados();
  }

  @override
  void dispose() {
    controller.dispose();
    controllerIdade.dispose();
    controllerCurso.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastros de Alunos"),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: TextField(
              controller: controllerIdade,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Idade",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controllerCurso,
              decoration: const InputDecoration(
                labelText: "Curso",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              final idade = int.tryParse(
                controllerIdade.text,
              );

              if (controller.text.isEmpty ||
                  idade == null ||
                  controllerCurso.text.isEmpty) {
                return;
              }

              inserirDados(
                controller.text,
                idade,
                controllerCurso.text,
              );

              controller.clear();
              controllerIdade.clear();
              controllerCurso.clear();
            },
            child: const Text("Salvar"),
          ),

          Expanded(
            child: dados.isEmpty
                ? const Center(
                    child: Text(
                      "Nenhum aluno cadastrado",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: dados.length,
                    itemBuilder: (context, index) {
                      final aluno = dados[index];

                      return ListTile(
                        title: Text(
                          aluno["nome"] ?? "",
                        ),

                        subtitle: Text(
                          "Idade: ${aluno["idade"] ?? ""}\n"
                          "Curso: ${aluno["curso"] ?? ""}\n"
                          "Criado em: ${aluno["data"] ?? ""}",
                        ),

                        isThreeLine: true,

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                abrirEdicao(
                                  context,
                                  aluno,
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                              ),
                            ),

                            IconButton(
                              onPressed: () {
                                deletarDados(
                                  aluno["id"],
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}