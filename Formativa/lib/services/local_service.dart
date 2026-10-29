import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/local.dart';

/// Ponto unico de acesso aos documentos da colecao `locais`.
class LocalService {
  LocalService({FirebaseFirestore? firestore})
      : _locais =
            (firestore ?? FirebaseFirestore.instance).collection('locais');

  final CollectionReference<Map<String, dynamic>> _locais;

  Stream<List<Local>> listarLocais() => _locais.snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Local.fromMap(doc.id, doc.data()))
            .toList(growable: false),
      );

  Future<void> adicionar(Local local) => _locais.add(local.toMap());

  Future<void> atualizar(Local local) =>
      _locais.doc(local.id).update(local.toMap());

  Future<void> excluir(String id) => _locais.doc(id).delete();

  Future<void> alterarFavorito(String id, bool favorito) =>
      _locais.doc(id).update({'favorito': favorito});
}
