import 'package:ahissinon/page_accueil.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'login_page.dart';

class RedirectionPage extends StatefulWidget {
  const RedirectionPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RedirectionPageState();
  }
}

class _RedirectionPageState extends State<RedirectionPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return const HomePage(title: "Menu page");
        } else {
          return const LoginPage(title: "Login page");
        }
      },
    );
  }
}