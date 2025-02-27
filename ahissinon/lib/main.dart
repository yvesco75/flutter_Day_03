import 'package:flutter/material.dart';
import 'page_accueil.dart'; // Importation de la page d'accueil

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Supprime le bandeau debug
      title: 'Mon Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PageAccueil(), // Affichage de la page d'accueil
    );
  }
}
