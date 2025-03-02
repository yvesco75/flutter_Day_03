import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart'; // Importez HomeWelcomeScreen
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/categories.dart'; // Importez CategoriesScreen

class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String categories =
      '/categories'; // Nouvelle route pour CategoriesScreen

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
            builder: (_) => HomeWelcomeScreen()); // Page d'accueil
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
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case categories:
        return MaterialPageRoute(
            builder: (_) => CategoriesScreen()); // Page des catégories
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Fonction helper pour la navigation
  static void navigateTo(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}
