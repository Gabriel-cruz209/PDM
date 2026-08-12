import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: AppCadastro()),
  );
}

// App "Cadastro de Alunos" O aluno deverá criar um pequeno aplicativo para cadastrar alunos.
// Interface
// O aplicativo deverá possuir:
// Campo Nome
// Campo Idade
// Campo Curso
// Botão Cadastrar
// Lista dos Alunos cadastrados

class AppCadastro extends StatefulWidget {
  @override
  _AppCadastroState createState() => _AppCadastroState();
}

class _AppCadastroState extends State<AppCadastro> {
  TextEditingController controller = TextEditingController();
  TextEditingController controllerCurso = TextEditingController();
  TextEditingController controllerIdade = TextEditingController();
  List<Map<String, dynamic>> dados = [];

  Future<Database> criarBanco() async {
    final caminho = await getDatabasesPath();
    final path = join(caminho, "banco.db");

    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE dados (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, idade INT, curso TEXT, data TEXT)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute("ALTER TABLE dados ADD COLUMN data TEXT");
        }
      },
      version: 2,
    );
  }

  Future<void> inserirDados(String nome, int idade, String curso) async {
    final db = await criarBanco();
    final agora = DateTime.now();
    final dataFormatada =
        "${agora.day.toString().padLeft(2, '0')}/${agora.month.toString().padLeft(2, '0')}/${agora.year} "
        "${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}";

    await db.insert("dados", {
      "nome": nome,
      "idade": idade,
      "curso": curso,
      "data": dataFormatada,
    });

    carregarDados();
  }

  Future<void> carregarDados() async {
    final db = await criarBanco();

    final lista = await db.query("dados", orderBy: "nome ASC");

    setState(() {
      dados = lista;
    });
  }

  Future<void> deletarDados(int id) async {
    final db = await criarBanco();
    await db.delete("dados", where: "id = ?", whereArgs: [id]);
    carregarDados();
  }

  Future<void> atualizarDados(
    int id,
    String nome,
    int idade,
    String curso,
  ) async {
    final db = await criarBanco();
    await db.update(
      "dados",
      {"nome": nome, "idade": idade, "curso": curso},
      where: "id = ?",
      whereArgs: [id],
    );
    carregarDados();
  }

  void abrirEdicao(BuildContext ctx, Map<String, dynamic> item) {
    final editNome = TextEditingController(text: item["nome"]);
    final editIdade = TextEditingController(text: item["idade"]);
    final editCurso = TextEditingController(text: item["curso"]);

    showDialog(
      context: ctx,
      builder: (buildContext) {
        return AlertDialog(
          title: Text("Editar Cadastro"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editNome,
                decoration: InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: editIdade,
                decoration: InputDecoration(
                  labelText: "Idade",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: editCurso,
                decoration: InputDecoration(
                  labelText: "Curso",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(buildContext),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (editNome.text.isNotEmpty) {
                  atualizarDados(
                    item["id"],
                    editNome.text,
                    int.tryParse(editIdade.text) ?? 0,
                    editCurso.text,
                  );
                  Navigator.pop(buildContext);
                }
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastros de Alunos")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: TextField(
              controller: controllerIdade,
              decoration: InputDecoration(
                labelText: "Idade",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: controllerCurso,
              decoration: InputDecoration(
                labelText: "Curso",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                inserirDados(
                  controller.text,
                  int.parse(controllerIdade.text),
                  controllerCurso.text,
                );
                controller.clear();
                controllerIdade.clear();
                controllerCurso.clear();
              }
            },
            child: Text("Salvar"),
          ),
          Expanded(
            child: dados.isEmpty
                ? Center(
                    child: Text(
                      "Nenhum item cadastrado",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: dados.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(dados[index]["nome"] ?? ""),
                        subtitle: Text(
                          "${dados[index]["curso"] ?? ""}\nCriado em: ${dados[index]["data"] ?? ""}",
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                abrirEdicao(context, dados[index]);
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                deletarDados(dados[index]["id"]);
                              },
                              icon: Icon(Icons.delete),
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
