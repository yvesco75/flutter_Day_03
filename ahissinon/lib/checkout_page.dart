import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  const CheckoutPage({super.key, required this.cartItems, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passer à la caisse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Récapitulatif de la commande',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('${item['quantity']} x ${item['price']} €'),
                  );
                },
              ),
            ),
            Text('Total: ${totalPrice.toStringAsFixed(2)} €',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            // ... (Ajouter ici les options de paiement, la gestion des adresses, etc.) ...
            ElevatedButton(
              onPressed: () {
                // Logique pour traiter le paiement et confirmer la commande
                _processPayment(context);
              },
              child: const Text('Confirmer la commande'),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(BuildContext context) {
    // Implémenter la logique de paiement ici
    // ...
    // Une fois le paiement réussi, afficher une confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Commande confirmée'),
        content: const Text('Votre commande a été confirmée avec succès.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}