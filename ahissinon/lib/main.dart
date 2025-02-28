import 'package:flutter/material.dart';
import 'page_accueil.dart'; // Vérifie que ce fichier existe

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mon Application',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomePage(), // Assure-toi que cette classe existe bien
    );
  }
}
