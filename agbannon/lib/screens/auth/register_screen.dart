import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart'; // Assurez-vous que ce fichier contient CustomAuthProvider
import '../auth/login_screen.dart';
import '../home/home_screen.dart';

class RedirectionPage extends StatefulWidget {
  const RedirectionPage({Key? key}) : super(key: key);

  @override
  State<RedirectionPage> createState() => _RedirectionPageState();
}

class _RedirectionPageState extends State<RedirectionPage> {
  @override
  Widget build(BuildContext context) {
    // Accéder à CustomAuthProvider via le Provider
    final authProvider =
        Provider.of<CustomAuthProvider>(context, listen: false);

    return StreamBuilder(
      stream:
          authProvider.authStateChanges, // Accès correct à la propriété Stream
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher un indicateur de chargement pendant l'attente
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Vérification de l\'authentification...'),
                ],
              ),
            ),
          );
        } else if (snapshot.hasData) {
          // Si l'utilisateur est connecté, rediriger vers l'écran principal
          return const HomeScreen();
        } else {
          // Si l'utilisateur n'est pas connecté, rediriger vers l'écran de connexion
          return const LoginScreen(title: "Login Page");
        }
      },
    );
  }
}
