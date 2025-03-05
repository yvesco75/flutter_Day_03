// lib/widgets/common/bottom_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex; // L'index de l'élément sélectionné
  final Function(int) onItemTapped; // Fonction pour gérer le tap

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Barres de navigation pour les sections principales
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => onItemTapped(0), // Accueil
                color: selectedIndex == 0 ? Colors.blue : null,
              ),
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => onItemTapped(1), // Produits
                color: selectedIndex == 1 ? Colors.blue : null,
              ),
              IconButton(
                icon: const Icon(Icons.list),
                onPressed: () => onItemTapped(2), // Commandes
                color: selectedIndex == 2 ? Colors.blue : null,
              ),
              IconButton(
                icon: const Icon(Icons.pie_chart),
                onPressed: () => onItemTapped(3), // Statistiques
                color: selectedIndex == 3 ? Colors.blue : null,
              ),
              IconButton(
                icon: const Icon(Icons.local_offer),
                onPressed: () => onItemTapped(4), // Offres
                color: selectedIndex == 4 ? Colors.blue : null,
              ),
            ],
          ),
          // Bouton de menu à trois points
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert), // Icone des trois points
            onSelected: (value) {
              // Navigation en fonction de l'option sélectionnée
              switch (value) {
                case 'profile':
                  GoRouter.of(context).go('/profile'); // Naviguer vers Profil
                  break;
                case 'settings':
                  // Ajoutez la route pour les paramètres si nécessaire
                  // GoRouter.of(context).go('/settings');
                  break;
                // Ajoutez d'autres options ici si nécessaire
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('Mon Profil'),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Paramètres'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
