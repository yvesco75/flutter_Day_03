import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key}); // Utilisation des super paramètres

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
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
                backgroundImage: AssetImage('asset/default_profile.png'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Nom: John Doe',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Email: john.doe@example.com'),
            SizedBox(height: 10),
            Text('Adresse: 123 Main St, Anytown'),
            SizedBox(height: 20),
            Text(
              'Historique des commandes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Commande #${index + 1}'),
                    subtitle: Text('Date: 2023-10-27'),
                    trailing: Text('Total: 50 €'),
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