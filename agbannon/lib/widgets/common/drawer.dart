import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import go_router
// Assurez-vous d'importer votre fichier Routes - plus nécessaire ici
//import '../../config/routes.dart';

class MyDrawer extends StatelessWidget {
  final String username;
  final String email;
  final String profileImageUrl;

  const MyDrawer({
    Key? key,
    this.username = "Utilisateur",
    this.email = "utilisateur@exemple.com",
    this.profileImageUrl = "https://via.placeholder.com/150",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Accueil'),
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).go('/'); // Navigate to home
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Voir les produits'),
            onTap: () {
              Navigator.pop(context); // Ferme le drawer
              GoRouter.of(context)
                  .push('/add-product'); // Navigate to add product
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Catégories'),
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context)
                  .push('/categories'); // Navigate to categories
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètres'),
            onTap: () {
              Navigator.pop(context);
              // Ajouter une route pour les paramètres si nécessaire
              // Example: GoRouter.of(context).push('/settings');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text(
                '5',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              // Ajouter une route pour les notifications si nécessaire
              // Example: GoRouter.of(context).push('/notifications');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              Navigator.pop(context);
              // Example: GoRouter.of(context).push('/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Déconnexion'),
            onTap: () {
              Navigator.pop(context);
              // Ajouter la logique de déconnexion
              // Puis naviguer vers l'écran de connexion
              GoRouter.of(context).go('/login');
            },
          ),
        ],
      ),
    );
  }
}
