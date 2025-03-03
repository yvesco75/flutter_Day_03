import 'package:flutter/material.dart';

class PanierPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const PanierPage({super.key, required this.cartItems});

  @override
  State<PanierPage> createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          final item = widget.cartItems[index];
          int quantity = item['quantity'] ?? 1;

          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image du produit
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset(item['image'], fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 10),

                  // Informations sur le produit
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text('${item['price']} €/${item['unit']}'),
                        Text(
                            'Prix total: ${(item['price'] * quantity).toStringAsFixed(2)} €'),
                        DropdownButton<String>(
                          value: item['merchant'],
                          onChanged: (String? newMerchant) {
                            setState(() {
                              item['merchant'] = newMerchant;
                            });
                          },
                          items: <String>['Marchand 1', 'Marchand 2', 'Marchand 3']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: const Text('MarchandS'),
                        ),
                      ],
                    ),
                  ),

                  // Boutons d'action
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) {
                                  quantity--;
                                  widget.cartItems[index]['quantity'] = quantity;
                                }
                              });
                            },
                          ),
                          Text('$quantity'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                quantity++;
                                widget.cartItems[index]['quantity'] = quantity;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                widget.cartItems.removeAt(index);
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.chat, color: Colors.blue),
                            onPressed: () {
                              // Fenêtre de chat
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Chat avec le vendeur"),
                                  content: Text("Discuter du produit : ${item['name']}"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Fermer'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            // Logique pour passer à la caisse
          },
          child: const Text('Passer à la caisse'),
        ),
      ),
    );
  }
}
