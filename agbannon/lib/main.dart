import 'package:agbannon/config/routes.dart'; // Ajustez le chemin selon votre structure
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Assurez-vous que ce fichier est correctement configuré
import 'package:provider/provider.dart';
import 'package:agbannon/providers/auth_provider.dart'; // Ajustez le chemin selon votre structure
import 'package:agbannon/services/auth_service.dart'; // Ajustez le chemin selon votre structure

void main() async {
  // Initialisation de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enveloppez votre application avec MultiProvider
  runApp(
    MultiProvider(
      providers: [
        // Fournir AuthService
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        // Fournir AuthProvider (si vous en avez besoin)
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
      debugShowCheckedModeBanner: false, // Désactiver la bannière de débogage
      title: 'Mon Application', // Titre de l'application
      theme: ThemeData(
        primarySwatch: Colors.blue, // Thème principal
      ),
      initialRoute: Routes.login, // Route initiale
      onGenerateRoute: (settings) =>
          Routes.generateRoute(settings), // Gestion des routes
    );
  }
}
