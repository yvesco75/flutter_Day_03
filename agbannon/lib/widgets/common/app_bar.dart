import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor:
          const Color.fromARGB(255, 97, 13, 233), // Couleur de l'AppBar
      elevation: 0,
      automaticallyImplyLeading:
          showBackButton, // Affiche le bouton de retour si nécessaire
      actions: actions, // Actions supplémentaires (icônes, etc.)
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Hauteur par défaut de l'AppBar
}
