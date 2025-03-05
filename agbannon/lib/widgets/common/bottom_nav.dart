// lib/widgets/common/bottom_nav_bar.dart
import 'package:flutter/material.dart';

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
              ),
              IconButton(
                icon: const Icon(Icons.list),
                onPressed: () => onItemTapped(1), // Commandes
              ),
              IconButton(
                icon: const Icon(Icons.pie_chart),
                onPressed: () => onItemTapped(2), // Statistiques
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
                  Navigator.pushNamed(
                      context, '/profile'); // Naviguer vers Profil
                  break;
                case 'settings':
                  Navigator.pushNamed(
                      context, '/settings'); // Naviguer vers Paramètres
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
