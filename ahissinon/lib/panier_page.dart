import 'package:flutter/material.dart';
import 'checkout_page.dart';

class PanierPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const PanierPage({super.key, required this.cartItems});

  @override
  State<PanierPage> createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  double _getShippingCost() {
    return 5.0; // Exemple de frais de livraison
  }

  double _getTaxes() {
    return 2.0; // Exemple de taxes
  }

  double _calculateTotalPrice() {
    double total = 0;
    for (var item in widget.cartItems) {
      total += (item['price'] * (item['quantity'] ?? 1));
    }
    return total;
  }

  final TextEditingController _orderListController = TextEditingController();
  bool _showOrderListInput = false;

  @override
  Widget build(BuildContext context) {
    double totalPrice = _calculateTotalPrice();
    double shippingCost = _getShippingCost();
    double taxes = _getTaxes();
    double finalTotal = totalPrice + shippingCost + taxes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Liste de commande écrite ?'),
              Checkbox(
                value: _showOrderListInput,
                onChanged: (bool? value) {
                  setState(() {
                    _showOrderListInput = value ?? false;
                  });
                },
              ),
            ],
          ),
          if (_showOrderListInput)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _orderListController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Saisissez votre liste de commande',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
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
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.asset(item['image'], fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 10),
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
                                items: <String>[
                                  'Marchand 1',
                                  'Marchand 2',
                                  'Marchand 3'
                                ].map<DropdownMenuItem<String>>((String value) {
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
                                        widget.cartItems[index]['quantity'] =
                                            quantity;
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
                                      widget.cartItems[index]['quantity'] =
                                          quantity;
                                    });
                                  },
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  widget.cartItems.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sous-total: ${totalPrice.toStringAsFixed(2)} €'),
                Text(
                    'Frais de livraison: ${shippingCost.toStringAsFixed(2)} €'),
                Text('Taxes: ${taxes.toStringAsFixed(2)} €'),
                Text('Total: ${finalTotal.toStringAsFixed(2)} €',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(
                          cartItems: widget.cartItems,
                          totalPrice: finalTotal,
                        ),
                      ),
                    );
                  },
                  child: const Text('Passer à la caisse'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}