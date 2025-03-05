// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:agbannon/providers/auth_provider.dart';
import 'package:agbannon/providers/product_provider.dart'; // Import ProductProvider
import 'package:agbannon/config/theme.dart'; // Importez le fichier theme.dart
import 'package:go_router/go_router.dart'; // Import go_router

import 'package:agbannon/screens/home/home_screen.dart';
import 'package:agbannon/screens/home/categories.dart';
import 'package:agbannon/screens/profile/profile_screen.dart';
import '../../screens/products/add_product_screen.dart';
import '../../screens/products/edit_product_screen.dart';
import '../../models/product.dart';
import 'package:agbannon/widgets/common/bottom_nav.dart'; // Import BottomNavBar

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
    initialLocation: '/home', // Route initiale
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => ProfilScreen(),
      ),
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
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(),
        ),
        // Ajoutez d'autres ChangeNotifierProvider ici si nécessaire
      ];
}

// Widget enveloppeur pour inclure la BottomNavBar
class BottomNavBarWrapper extends StatefulWidget {
  final Widget child;

  const BottomNavBarWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<BottomNavBarWrapper> createState() => _BottomNavBarWrapperState();
}

class _BottomNavBarWrapperState extends State<BottomNavBarWrapper> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Gérer la navigation en fonction de l'index sélectionné
    switch (index) {
      case 0:
        GoRouter.of(context).go('/home');
        break;
      case 1:
        GoRouter.of(context).go('/categories');
        break;
      case 2:
        GoRouter.of(context).go('/orders');
        break;
      case 3:
        GoRouter.of(context).go('/stats');
        break;
      case 4:
        GoRouter.of(context).go('/offers');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
