import 'package:flutter/material.dart';
import '../../config/routes.dart'; // Assurez-vous d'importer votre fichier Routes

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
              Routes.navigateTo(context, Routes.home);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Voir les produits'),
            onTap: () {
              Navigator.pop(context); // Ferme le drawer
              Routes.navigatePush(context,
                  Routes.addProduct); // Utilise votre méthode navigatePush
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Catégories'),
            onTap: () {
              Navigator.pop(context);
              Routes.navigatePush(context, Routes.categories);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètres'),
            onTap: () {
              Navigator.pop(context);
              // Ajouter une route pour les paramètres si nécessaire
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
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              Navigator.pop(context);
              Routes.navigatePush(context, Routes.profile);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Déconnexion'),
            onTap: () {
              Navigator.pop(context);
              // Ajouter la logique de déconnexion
              // Puis naviguer vers l'écran de connexion
              // Routes.navigateTo(context, Routes.login);
            },
          ),
        ],
      ),
    );
  }
}
