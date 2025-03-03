import 'package:flutter/material.dart';

class PortefeuillePage extends StatelessWidget {
  const PortefeuillePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portefeuille'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Solde Actuel
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Solde actuel',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '150 €', // Remplacez par le solde réel de l'utilisateur
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Options de Recharge
              const Text(
                'Recharger le compte',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      // Implémentez la logique de recharge (50 €)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('50 €'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implémentez la logique de recharge (100 €)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('100 €'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implémentez la logique de recharge (200 €)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('200 €'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Historique des Transactions
              const Text(
                'Historique des transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5, // Remplacez par le nombre réel de transactions
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.arrow_upward, color: Colors.green), // Icône pour les dépôts
                    title: const Text('Recharge'),
                    subtitle: const Text('2023-10-27'), // Remplacez par la date réelle
                    trailing: const Text('+ 50 €', style: TextStyle(color: Colors.green)), // Remplacez par le montant réel
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}