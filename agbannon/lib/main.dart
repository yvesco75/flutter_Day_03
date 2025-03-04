import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:agbannon/providers/auth_provider.dart';
import 'package:agbannon/config/theme.dart'; // Importez le fichier theme.dart
import 'package:go_router/go_router.dart'; // Import go_router

import 'package:agbannon/screens/home/home_screen.dart';
import 'package:agbannon/screens/home/categories.dart';
import 'package:agbannon/screens/profile/profile_screen.dart';
import '../../screens/products/add_product_screen.dart';
import '../../screens/products/edit_product_screen.dart';
import '../../models/product.dart';

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
  MyApp({Key? key}) : super(key: key);

  final _router = GoRouter(
    initialLocation: '/', // Route initiale
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const HomeScreen(), // Remplacez par votre écran d'accueil
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) =>
            const CategoriesScreen(), // Remplacez par votre écran de catégories
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) =>
            ProfilScreen(), // Remplacez par votre écran de profil
      ),
      // Ajoutez ici les routes que vous aviez dans AppRouter
      GoRoute(
        path: '/add-product',
        builder: (context, state) => const AddProductScreen(),
      ),
      GoRoute(
        path: '/edit-product',
        builder: (context, state) {
          final product = state.extra as Product?;
          if (product == null) {
            return Scaffold(
              body: Center(
                child: Text('Produit non spécifié'),
              ),
            );
          }
          return EditProductScreen(product: product);
        },
      ),
      // Ajoutez les autres routes de votre AppRouter ici
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false, // Désactiver la bannière de débogage
      title: 'Agbannon - App Marchand', // Titre de l'application
      theme: AppTheme.marchandTheme, // Utilisation du thème marchand
      routerConfig: _router, // Utilisation de GoRouter
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
