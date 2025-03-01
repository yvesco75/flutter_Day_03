import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';

class Routes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register =
      '/register'; // Maintenu comme 'register' pour être cohérent avec les fichiers envoyés
  static const String forgotPassword =
      '/forgot-password'; // Modifié pour correspondre au nom de fichier

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(
            toggleView: () => navigateTo(_,
                register), // Ajout d'une fonction pour basculer entre les écrans
          ),
        );
      case register:
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(
            toggleView: () => navigateTo(_,
                login), // Ajout d'une fonction pour basculer entre les écrans
          ),
        );
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => forgotPasswordScreen());
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
