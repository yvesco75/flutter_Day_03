import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Importations de vos écrans
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/categories.dart';
import '../screens/products/product_list_screen.dart';
import '../screens/products/add_product_screen.dart';
import '../screens/products/edit_product_screen.dart';
import '../models/product.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    // Redirection globale basée sur l'authentification
    redirect: (BuildContext context, GoRouterState state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final bool isAuthenticated = authProvider.isAuthenticated;
      final bool isLoading = authProvider.isLoading;

      // Routes publiques
      final bool isPublicRoute = ['/login', '/register', '/forgot-password']
          .contains(state.uri.toString());

      // Si pas authentifié et pas sur une route publique, rediriger vers login
      if (isLoading) {
        return null; // Attendre le chargement
      }

      if (!isAuthenticated && !isPublicRoute) {
        return '/login';
      }

      // Si authentifié et sur une route publique, rediriger vers home
      if (isAuthenticated && isPublicRoute) {
        return '/';
      }

      return null;
    },

    // Configuration des routes
    routes: [
      // Route de connexion
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginScreen(
          toggleView: () => context.go('/register'),
        ),
      ),

      // Route d'inscription
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => RegisterScreen(
          toggleView: () => context.go('/login'),
        ),
      ),

      // Route de réinitialisation de mot de passe
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Route principale (home)
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          // Routes imbriquées sous home
          GoRoute(
            path: 'categories',
            name: 'categories',
            builder: (context, state) => const CategoriesScreen(),
          ),
          // Nouvelle route pour afficher les produits d'une catégorie
          GoRoute(
            path: 'products/:categoryId',
            name: 'products',
            builder: (context, state) =>
                ProductListScreen.fromGoRouterState(state),
          ),
          // Route pour ajouter un produit (déplacée dans les routes imbriquées)
          GoRoute(
            path: 'add-product',
            name: 'add-product',
            builder: (context, state) => const AddProductScreen(),
          ),
          // Route pour éditer un produit (déplacée dans les routes imbriquées)
          GoRoute(
            path: '/edit-product',
            name: 'edit-product',
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
        ],
      ),
    ],

    // Gestionnaire d'erreurs
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route non trouvée: ${state.error}'),
      ),
    ),
  );

  // Méthodes de navigation statiques
  static void navigateTo(BuildContext context, String route) {
    context.go(route);
  }

  static void navigateToWithArgs(
      BuildContext context, String route, Object? extra) {
    context.go(route, extra: extra);
  }

  static void pushTo(BuildContext context, String route) {
    context.push(route);
  }

  static void pushToWithArgs(
      BuildContext context, String route, Object? extra) {
    context.push(route, extra: extra);
  }
}
