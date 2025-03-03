import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/categories.dart';
import '../screens/products/add_product_screen.dart'; // Importez AddProductScreen
import '../screens/products/edit_product_screen.dart'; // Importez EditProductScreen
import '../models/product.dart'; // Importez Product

class Routes {
  // Définition de toutes les constantes de routes
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String categories = '/categories';
  static const String productList = '/product-list';
  static const String productDetail = '/product-detail';
  static const String addProduct = '/add-product';
  static const String editProduct = '/edit-product';
  static const String orderList = '/order-list';
  static const String orderDetail = '/order-detail';
  static const String offerList = '/offer-list';
  static const String createOffer = '/create-offer';
  static const String profile = '/profile';

  // Map de routes statiques pour MaterialApp
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      login: (context) => LoginScreen(
            toggleView: () => navigateTo(context, register),
          ),
      register: (context) => RegisterScreen(
            toggleView: () => navigateTo(context, login),
          ),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      categories: (context) => const CategoriesScreen(),
      addProduct: (context) =>
          const AddProductScreen(), // Route pour ajouter un produit
      // editProduct n'est pas inclus ici car il nécessite un argument (Product)
    };
  }

  // Générateur de routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(
            toggleView: () => navigateTo(_, register),
          ),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(
            toggleView: () => navigateTo(_, login),
          ),
        );

      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case categories:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());

      case addProduct:
        return MaterialPageRoute(
            builder: (_) =>
                const AddProductScreen()); // Route pour ajouter un produit

      case editProduct:
        if (args is Product) {
          return MaterialPageRoute(
            builder: (_) => EditProductScreen(
                product: args), // Passez le produit à modifier
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('Argument invalide pour la route edit-product'),
              ),
            ),
          );
        }

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Aucune route définie pour ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Fonctions helper pour la navigation
  static void navigateTo(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static void navigateToWithArgs(
      BuildContext context, String routeName, Object arguments) {
    Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static void navigatePush(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void navigatePushWithArgs(
      BuildContext context, String routeName, Object arguments) {
    Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }
}
