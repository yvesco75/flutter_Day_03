import 'package:agbannon/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';
// Importez provider
import 'package:provider/provider.dart';
// Importez votre AuthProvider
import 'package:agbannon/providers/auth_provider.dart'; // Ajustez le chemin selon votre structure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enveloppez votre application avec MultiProvider
  runApp(
    MultiProvider(
      providers: [
        // Ajoutez votre AuthProvider ici
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        // Vous pouvez ajouter d'autres providers si nécessaire
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Application',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: Routes.login,
      onGenerateRoute: (settings) => Routes.generateRoute(settings),
    );
  }
}

// Le reste de votre code reste inchangé
