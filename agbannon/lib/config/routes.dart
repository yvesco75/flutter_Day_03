import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

// Écrans de paiement et profil
import '../screens/payments/payment_screen.dart';
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
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // Route principale (home)
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),

    // Routes des produits
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductListScreen(),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddProductScreen(),
        ),
        GoRoute(
          path: 'edit/:productId',
          builder: (context, state) {
            final productId = state.pathParameters['productId'];
            return EditProductScreen(productId: productId);
          },
        ),
        GoRoute(
          path: ':productId',
          builder: (context, state) {
            final productId = state.pathParameters['productId'];
            return ProductDetailScreen(productId: productId);
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
            return OrderDetailScreen(orderId: orderId);
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

    // Routes supplémentaires
    GoRoute(
      path: '/payments',
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page non trouvée: ${state.error}'),
    ),
  ),
);

// Logique de redirection basée sur l'authentification
String? _redirectLogic(BuildContext context, GoRouterState state) {
  // Vérifier l'état de connexion
  final authProvider = AuthProvider(); // Assurez-vous d'injecter correctement
  final isLoggedIn = authProvider.isAuthenticated;

  final isLoggingIn = state.subloc == '/login' || state.subloc == '/register';

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
}
