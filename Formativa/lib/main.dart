import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/mapa_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Depois de executar `flutterfire configure`, a configuracao nativa do
    // Firebase permite esta inicializacao no Android.
    await Firebase.initializeApp();
    runApp(const MapaLocaisApp());
  } catch (error) {
    runApp(_FirebaseSetupErrorApp(error: error));
  }
}

class MapaLocaisApp extends StatelessWidget {
  const MapaLocaisApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Mapa de Locais',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff146c5a)), useMaterial3: true),
    home: const MapaScreen(),
  );
}

class _FirebaseSetupErrorApp extends StatelessWidget {
  const _FirebaseSetupErrorApp({required this.error});
  final Object error;
  @override
  Widget build(BuildContext context) => MaterialApp(home: Scaffold(body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.cloud_off, size: 56), const SizedBox(height: 16), const Text('O Firebase ainda nao foi configurado para este aplicativo.', textAlign: TextAlign.center), const SizedBox(height: 8), const Text('Execute flutterfire configure e adicione a configuracao Android do seu projeto Firebase.', textAlign: TextAlign.center), const SizedBox(height: 12), Text('$error', maxLines: 3, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall)])))));
}
