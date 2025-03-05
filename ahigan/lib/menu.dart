import 'package:ahigan/pages/liste_commandes.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required String title});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // États pour suivre si la souris survole chaque conteneur
  bool _isHovered1 = false;
  bool _isHovered2 = false;
  bool _isHovered3 = false;
  bool _isHovered4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Fond gris clair
      appBar: AppBar(
        title: Text(
          'Market Manager',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF4CAF50), // Vert pour l'appBar
        elevation: 10, // Ombre de l'appBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ligne du haut
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Conteneur 1 : Consulter
                _buildMarketContainer(
  context,
  icon: Icons.store,
  text: "Consulter",
  isHovered: _isHovered1,
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ListeCommandes()),
  ),
  onEnter: () => setState(() => _isHovered1 = true),
  onExit: () => setState(() => _isHovered1 = false),
),
                // Conteneur 2 : Commandes
                _buildMarketContainer(
                  context,
                  icon: Icons.shopping_cart,
                  text: "Commandes",
                  isHovered: _isHovered2,
                  onTap: () => Navigator.pushNamed(context, '/commandes'),
                  onEnter: () => setState(() => _isHovered2 = true),
                  onExit: () => setState(() => _isHovered2 = false),
                ),
              ],
            ),
            SizedBox(height: 20), // Espace entre les lignes
            // Ligne du bas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Conteneur 3 : Suivi de commandes
                _buildMarketContainer(
                  context,
                  icon: Icons.track_changes,
                  text: "Suivie de commandes",
                  isHovered: _isHovered3,
                  onTap: () => Navigator.pushNamed(context, '/suivie'),
                  onEnter: () => setState(() => _isHovered3 = true),
                  onExit: () => setState(() => _isHovered3 = false),
                ),
                // Conteneur 4 : Paiement et transaction
                _buildMarketContainer(
                  context,
                  icon: Icons.payment,
                  text: "Paiement et transaction",
                  isHovered: _isHovered4,
                  onTap: () => Navigator.pushNamed(context, '/payement'),
                  onEnter: () => setState(() => _isHovered4 = true),
                  onExit: () => setState(() => _isHovered4 = false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour construire un conteneur de marché
  Widget _buildMarketContainer(
    BuildContext context, {
    required IconData icon,
    required String text,
    required bool isHovered,
    required VoidCallback onTap,
    required VoidCallback onEnter,
    required VoidCallback onExit,
  }) {
    return MouseRegion(
      onEnter: (_) => onEnter(),
      onExit: (_) => onExit(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: 300,
          height: 150, // Hauteur augmentée pour mieux afficher l'icône et le texte
          decoration: BoxDecoration(
            color: isHovered ? Color(0xFFFFA726) : Color(0xFF4CAF50), // Orange au survol, vert sinon
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(0, 5), // Ombre plus prononcée
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isHovered ? Color(0xFFFFA726) : Color(0xFF66BB6A), // Dégradé de vert
                isHovered ? Color(0xFFFF7043) : Color(0xFF4CAF50), // Dégradé de vert
              ],
            ),
          ),
          transform: Matrix4.translationValues(
            0,
            isHovered ? -10 : 0, // Déplacer légèrement vers le haut au survol
            0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.white, // Icône en blanc
              ),
              SizedBox(height: 10), // Espace entre l'icône et le texte
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}