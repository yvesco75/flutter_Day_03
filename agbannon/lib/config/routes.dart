import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';

// Imports des écrans
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';

// Écrans de produits
import '../screens/products/product_list_screen.dart';
import '../screens/products/product_detail_screen.dart';
import '../screens/products/add_product_screen.dart';
import '../screens/products/edit_product_screen.dart';

// Écrans de commandes
import '../screens/orders/order_list_screen.dart';
import '../screens/orders/order_detail_screen.dart';

// Écrans d'offres
import '../screens/offers/offer_list_screen.dart';
import '../screens/offers/create_offer_screen.dart';

// Écrans de paiements
import '../screens/payments/payment_screen.dart';

// Écrans de statistiques
import '../screens/stats/stats_screen.dart';

// Écrans de profil
import '../screens/profile/profile_screen.dart';

// Providers pour la logique d'authentification
import '../providers/auth_provider.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  redirect: _redirectLogic,
  routes: [
    // Routes d'authentification
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return LoginScreen(
          toggleView: () {
            context.go('/register');
          },
        );
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(
        toggleView: () {
          context.go('/login');
        },
      ),
    ),

    // Route principale (home)
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),

    // Routes des produits
    GoRoute(
      path: '/products',
      builder: (context, state) {
        final categoryId = state.uri.queryParameters['categoryId'] ?? '';
        final categoryName =
            state.uri.queryParameters['categoryName'] ?? 'Produits';
        return ProductListScreen(
          categoryId: categoryId,
          categoryName: categoryName,
        );
      },
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddProductScreen(),
        ),
        GoRoute(
          path: 'edit/:productId',
          builder: (context, state) {
            final productId = state.pathParameters['productId'];
            // Vous devrez récupérer le produit complet, par exemple via un provider
            return EditProductScreen(
                product: Product(
              id: productId!,
              name: 'Nom du produit',
              description: 'Description',
              price: 0.0,
              categoryId: '',
              imageUrl: '',
            ));
          },
        ),
        GoRoute(
          path: ':productId',
          builder: (context, state) {
            final productId = state.pathParameters['productId'];
            return ProductDetailScreen(
                productId:
                    productId!); // Assurez-vous que productId n'est pas null
          },
        ),
      ],
    ),

    // Routes des commandes
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrderListScreen(),
      routes: [
        GoRoute(
          path: ':orderId',
          builder: (context, state) {
            final orderId = state.pathParameters['orderId'];
            return OrderDetailScreen(
                orderId: orderId!); // Assurez-vous que orderId n'est pas null
          },
        ),
      ],
    ),

    // Routes des offres
    GoRoute(
      path: '/offers',
      builder: (context, state) => const OfferListScreen(),
      routes: [
        GoRoute(
          path: 'create',
          builder: (context, state) => const CreateOfferScreen(),
        ),
      ],
    ),

    // Routes des paiements
    GoRoute(
      path: '/payments',
      builder: (context, state) => const PaymentScreen(),
    ),

    // Routes des statistiques
    GoRoute(
      path: '/stats',
      builder: (context, state) => const StatsScreen(),
    ),

    // Routes de profil
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page non trouvée : ${state.error}'),
    ),
  ),
);

// Logique de redirection basée sur l'authentification
String? _redirectLogic(BuildContext context, GoRouterState state) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final isLoggedIn = authProvider.isAuthenticated;

  final isLoggingIn = state.uri.path == '/login' ||
      state.uri.path == '/register'; // Utilisation de state.uri.path

  if (!isLoggedIn && !isLoggingIn) {
    return '/login';
  }

  if (isLoggedIn && isLoggingIn) {
    return '/home';
  }

  return null;
}

// Extension pour faciliter la navigation
extension NavigationExtension on BuildContext {
  void goToProductDetail(String productId) {
    go('/products/$productId');
  }

  void goToOrderDetail(String orderId) {
    go('/orders/$orderId');
  }

  void goToOfferDetail(String offerId) {
    go('/offers/$offerId');
  }
}
