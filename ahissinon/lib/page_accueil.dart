import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _products = [
    {"name": "Tomate", "image": "asset/tomate.jpg", "price": 2.5, "unit": "kg"},
    {"name": "Pomme", "image": "asset/pomme.jpg", "price": 1.8, "unit": "kg"},
    {"name": "Carotte", "image": "asset/carotte.jpg", "price": 1.2, "unit": "kg"},
    {"name": "Banane", "image": "asset/banane.jpg", "price": 2.0, "unit": "kg"},
    {"name": "Poisson", "image": "asset/poisson.jpg", "price": 8.0, "unit": "kg"},
    {"name": "Lait", "image": "asset/lait.jpg", "price": 1.5, "unit": "L"},
    {"name": "Riz", "image": "asset/riz.jpg", "price": 3.0, "unit": "kg"},
    {"name": "Poulet", "image": "asset/poulet.jpg", "price": 6.5, "unit": "kg"},
    {"name": "Oeuf", "image": "asset/oeuf.jpg", "price": 2.2, "unit": "12"},
    {"name": "Huile", "image": "asset/huile.jpg", "price": 4.0, "unit": "L"},
    {"name": "Sucre", "image": "asset/sucre.jpg", "price": 1.0, "unit": "kg"},
    {"name": "Sel", "image": "asset/sel.jpg", "price": 0.5, "unit": "kg"},
    {"name": "Poivre", "image": "asset/poivre.jpg", "price": 1.8, "unit": "kg"},
    {"name": "Café", "image": "asset/cafe.jpg", "price": 5.0, "unit": "kg"},
    {"name": "Thé", "image": "asset/the.jpg", "price": 3.5, "unit": "kg"},
    {"name": "Jus", "image": "asset/jus.jpg", "price": 2.8, "unit": "L"},
    {"name": "Eau", "image": "asset/eau.jpg", "price": 0.8, "unit": "L"},
    {"name": "Pain", "image": "asset/pain.jpg", "price": 1.2, "unit": "pièce"},
    {"name": "Farine", "image": "asset/farine.jpg", "price": 2.0, "unit": "kg"},
    {"name": "Pâtes", "image": "asset/pates.jpg", "price": 1.5, "unit": "kg"},
  ];

  final List<String> _categories = [
    "Tous",
    "Fruits",
    "Légumes",
    "Viande",
    "Produits laitiers",
    "Boissons"
  ];

  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 120, // Hauteur ajustée
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('asset/market.webp'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.orange.withAlpha((255 * 0.4).round()),
                        BlendMode.srcATop,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 16,
                  right: 16, // Pour centrer les éléments horizontalement
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'asset/logoahissinon.png',
                        width: 80,
                      ),
                      IconButton(
                        icon: const Icon(Icons.account_circle, size: 32, color: Colors.black),
                        onPressed: () {
                          debugPrint("Profil ouvert");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Rechercher un produit...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      label: Text(_categories[index]),
                      selected: _selectedCategory == index,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = index;
                        });
                      },
                      selectedColor: Colors.orange.shade700,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: _selectedCategory == index ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            child: Image.asset(
                              product["image"]!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product["name"]!,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${product["price"]} €/${product["unit"]}",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade700,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                              ),
                              onPressed: () {
                                debugPrint('Acheter ${product["name"]}');
                              },
                              child: const Text('Acheter'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Portefeuille'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Panier'),
        ],
      ),
    );
  }
}