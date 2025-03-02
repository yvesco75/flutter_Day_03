import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:agbannon/config/routes.dart';
import 'package:agbannon/providers/auth_provider.dart';
import 'package:agbannon/services/auth_service.dart';
import 'package:agbannon/config/theme.dart'; // Importez le fichier theme.dart

void main() async {
  // Initialisation de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase avec gestion des erreurs
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Erreur lors de l\'initialisation de Firebase: $e');
    // Vous pouvez afficher un écran d'erreur ou un message à l'utilisateur ici
  }

  // Enveloppez votre application avec MultiProvider
  runApp(
    MultiProvider(
      providers: AppProviders.providers, // Configuration des providers
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Désactiver la bannière de débogage
      title: 'Agbannon - App Marchand', // Titre de l'application
      theme: AppTheme.marchandTheme, // Utilisation du thème marchand
      // Note: Vous pouvez toujours garder le darkTheme si vous souhaitez
      // permettre à l'utilisateur de basculer vers un mode sombre
      // darkTheme: AppTheme.darkTheme,
      initialRoute: Routes
          .home, // Route initiale modifiée pour démarrer sur la HomeScreen
      onGenerateRoute: (settings) =>
          Routes.generateRoute(settings), // Gestion des routes
    );
  }
}

/// Configuration des providers
class AppProviders {
  static List<ChangeNotifierProvider> get providers => [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        // Ajoutez d'autres ChangeNotifierProvider ici si nécessaire
      ];
}
