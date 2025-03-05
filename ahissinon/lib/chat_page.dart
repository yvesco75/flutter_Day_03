import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String productName;
  final String merchantName;

  const ChatPage({super.key, required this.productName, required this.merchantName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat avec $merchantName'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Produit: $productName', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Expanded(
              child: Center(
                child: Text('Zone de chat'),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Votre message...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Logique d'envoi du message
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}