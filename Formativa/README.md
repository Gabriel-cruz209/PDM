# Mapa de Locais

Aplicativo Flutter de localizacao de estabelecimentos, conectado a colecao `locais` do Cloud Firestore. Possui mapa ilustrado, pesquisa, filtros, detalhes, favoritos e CRUD em Bottom Sheet.

## Configuracao obrigatoria do Firebase

Nao ha credenciais Firebase no repositorio. Para conectar seu projeto Android:

1. Instale o Flutter e confirme com `flutter --version`.
2. A estrutura Android ja esta incluida manualmente neste projeto; nao e necessario executar `flutter create .`.
3. Crie/selecione um projeto no [Firebase Console](https://console.firebase.google.com/) e habilite **Cloud Firestore**.
4. Instale a Firebase CLI, faca `firebase login` e execute `dart pub global activate flutterfire_cli`.
5. Nesta pasta, execute `flutterfire configure`, selecione o projeto e Android. O comando cria `lib/firebase_options.dart` e inclui a configuracao Android.
6. Execute `flutter pub get`, `flutter analyze`, `flutter test` e `flutter run`.

O app inicializa Firebase pelo Android configurado. Se desejar usar explicitamente o arquivo gerado pelo FlutterFire, substitua a chamada de inicializacao por `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` e importe `firebase_options.dart` — nao edite os valores gerados.

## Colecao e regras

Crie a colecao `locais` com os campos `nome`, `categoria`, `cidade`, `avaliacao`, `distancia`, `horario`, `descricao` e `favorito`. Cadastre pelo menos dez documentos para a demonstracao. O arquivo [docs/locais_exemplo.json](docs/locais_exemplo.json) fornece dez registros para inserir manualmente no Console (um documento por objeto); ele nao e lido pelo aplicativo e nao substitui o Firestore.

Durante desenvolvimento, use as regras temporarias sugeridas pelo Firebase Console. Antes da entrega, configure autenticacao e regras restritivas. Uma base sem autenticacao **nao deve** permanecer aberta em producao.
