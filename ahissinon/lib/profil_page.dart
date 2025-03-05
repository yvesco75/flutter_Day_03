import 'package:flutter/material.dart';
import 'user_profile.dart'; // Importez le modèle utilisateur

class ProfilPage extends StatelessWidget {
  final UserProfile user;

  const ProfilPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('asset/default_profile.png'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Nom: ${user.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Email: ${user.email}'),
            const SizedBox(height: 10),
            Text('Téléphone: ${user.phoneNumber}'),
            const SizedBox(height: 10),
            Text('Adresse: ${user.address}'),
            const SizedBox(height: 10),
            Text('Préférences: ${user.preferences.join(', ')}'),
            const SizedBox(height: 20),
            const Text(
              'Historique des commandes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: user.orderHistory.length,
                itemBuilder: (context, index) {
                  final order = user.orderHistory[index];
                  return ListTile(
                    title: Text('Commande #${index + 1}'),
                    subtitle: Text('Date: ${order['date']}'),
                    trailing: Text('Total: ${order['total']} €'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}