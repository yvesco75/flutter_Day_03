import 'package:flutter/material.dart';
import 'user_profile.dart';
import 'profil_page.dart';

class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;
  final UserProfile user;

  const CheckoutPage(
      {super.key,
      required this.cartItems,
      required this.totalPrice,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          const Text('Articles à payer:'),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(
                      '${item['name']} - ${item['price']} € x ${item['quantity']}'),
                );
              },
            ),
          ),
          Text('Total: ${totalPrice.toStringAsFixed(2)} €'),
          ElevatedButton(
            onPressed: () {
              // Créer une copie de UserProfile avec la nouvelle commande ajoutée
              final updatedUser = user.copyWith(
                orderHistory: [
                  ...user.orderHistory,
                  {
                    'items': cartItems,
                    'total': totalPrice,
                  }
                ],
              );

              // Naviguer vers la page de profil
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilPage(user: updatedUser)),
              );
            },
            child: const Text('Confirmer le paiement'),
          ),
        ],
      ),
    );
  }
}