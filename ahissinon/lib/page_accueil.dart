import 'package:flutter/material.dart';

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image de fond avec opacité
        Positioned(
          top: 42,
          left: 0,
          child: Opacity(
            opacity: 0.9,
            child: Image.asset(
              '17Sep24_Free_Upload__1_-removebg-preview', // Image de fond
              width: 393,
              height: 251,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Rectangle blanc contenant le logo et l’icône de profil
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: 393,
            height: 52,
            color: Colors.white,
            child: Stack(
              children: [
                // Logo (une partie en dehors du rectangle)
                Positioned(
                  left: -22,
                  top: -47,
                  child: Image.asset(
                    'market.webp', // Logo
                    width: 179,
                    height: 179,
                  ),
                ),
                // Icône de profil
                Positioned(
                  right: 16,
                  top: 10,
                  child: GestureDetector(
                    onTap: () {
                      // Naviguer vers une nouvelle page (à implémenter)
                    },
                    child: Icon(
                      Icons.account_circle,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Texte au centre de l'image
        Positioned(
          top: 138,
          left: 22,
          child: SizedBox(
            width: 341,
            height: 112,
            child: Text(
              "Simplifier votre quotidien en\n"
              "effectuant vos achats partout et à\n"
              "tout moment.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}