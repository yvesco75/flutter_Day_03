import 'package:flutter/material.dart';
import 'package:background_app_bar/background_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.orange,
            flexibleSpace: BackgroundFlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: const Text(
                "Simplifier votre quotidien en effectuant vos achats\npartout et à tout moment.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'asset/market.webp', // Assurez-vous que le chemin est correct
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Image.asset(
                      'asset/logoahissinon.png', // Assurez-vous que le chemin est correct
                      width: 60,
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                debugPrint("Menu ouvert");
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.account_circle, color: Colors.white),
                onPressed: () {
                  debugPrint("Profil ouvert");
                },
              ),
            ],
          ),
          // ... autres parties à ajouter ici ...
        ],
      ),
    );
  }
}