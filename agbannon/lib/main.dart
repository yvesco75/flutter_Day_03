import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:agbannon/providers/auth_provider.dart';
import 'package:agbannon/providers/product_provider.dart';
import 'package:agbannon/providers/order_provider.dart';
import 'package:agbannon/providers/offer_provider.dart';
import 'package:agbannon/providers/stats_provider.dart';
import 'package:agbannon/config/theme.dart';
import 'package:go_router/go_router.dart';

import 'package:agbannon/screens/home/home_screen.dart';
import 'package:agbannon/screens/home/categories.dart';
import 'package:agbannon/screens/profile/profile_screen.dart';
import 'package:agbannon/screens/products/add_product_screen.dart';
import 'package:agbannon/screens/products/edit_product_screen.dart';
import 'package:agbannon/screens/products/product_list_screen.dart';
import 'package:agbannon/models/product.dart';
import 'package:agbannon/widgets/common/bottom_nav.dart';
import 'package:agbannon/screens/orders/order_list_screen.dart';
import 'package:agbannon/screens/offers/offer_list_screen.dart';
import 'package:agbannon/screens/offers/create_offer_screen.dart';
import 'package:agbannon/screens/stats/stats_screen.dart';

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

  // Création d'une clé de navigation pour le GoRouter
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _shellNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/home',
      routes: [
        // ShellRoute pour gérer la barre de navigation
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return AppShell(
              currentPath: state.uri.path,
              child: child,
            );
          },
          routes: [
            // Routes qui apparaissent avec la barre de navigation
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/categories',
              builder: (context, state) => const CategoriesScreen(),
            ),
            GoRoute(
              path: '/orders',
              builder: (context, state) => const OrderListScreen(),
            ),
            GoRoute(
              path: '/stats',
              builder: (context, state) => const StatsScreen(),
            ),
            GoRoute(
              path: '/offers',
              builder: (context, state) => const OfferListScreen(),
            ),
          ],
        ),

        // Routes qui n'utilisent pas la barre de navigation
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/profile',
          builder: (context, state) => ProfilScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/add-product',
          builder: (context, state) => const AddProductScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
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
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/product-list/:categoryId',
          builder: (context, state) {
            final categoryId = state.pathParameters['categoryId']!;
            return ProductListScreen(categoryId: categoryId);
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/offers/create',
          builder: (context, state) => const CreateOfferScreen(),
        ),

        // Redirection par défaut
        GoRoute(
          path: '/',
          redirect: (_, __) => '/home',
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Agbannon - App Marchand',
      theme: AppTheme.marchandTheme,
      routerConfig: router,
    );
  }
}

/// Configuration des providers
class AppProviders {
  static List<ChangeNotifierProvider> get providers => [
        ChangeNotifierProvider<CustomAuthProvider>(
          create: (_) => CustomAuthProvider(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (_) => OrderProvider(),
        ),
        ChangeNotifierProvider<OfferProvider>(
          create: (_) => OfferProvider(),
        ),
        ChangeNotifierProvider<StatsProvider>(
          create: (_) => StatsProvider(),
        ),
      ];
}

/// Widget Shell qui gère la barre de navigation
class AppShell extends StatefulWidget {
  final Widget child;
  final String currentPath;

  const AppShell({
    Key? key,
    required this.child,
    required this.currentPath,
  }) : super(key: key);

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _getSelectedIndex(String path) {
    if (path.startsWith('/home')) return -1; // Retourne -1 pour la page Home
    if (path.startsWith('/categories')) return 0;
    if (path.startsWith('/orders')) return 1;
    if (path.startsWith('/stats')) return 2;
    if (path.startsWith('/offers')) return 3;
    return 0;
  }

  void _onItemTapped(int index) {
    String newPath;
    switch (index) {
      case 0:
        newPath = '/categories';
        break;
      case 1:
        newPath = '/orders';
        break;
      case 2:
        newPath = '/stats';
        break;
      case 3:
        newPath = '/offers';
        break;
      default:
        newPath = '/categories';
    }

    // Évite de naviguer vers la page actuelle
    if (widget.currentPath != newPath) {
      context.go(newPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(widget.currentPath);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: selectedIndex !=
              -1 // Affiche la barre de navigation si selectedIndex n'est pas -1
          ? BottomNavBar(
              selectedIndex: selectedIndex,
              onItemTapped: _onItemTapped,
            )
          : null,
    );
  }
}
