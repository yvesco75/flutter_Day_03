import 'package:flutter/material.dart';
import 'profil_page.dart';
import 'porte_feuille_page.dart';
import 'panier_page.dart';
import 'user_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _products = [
    {"name": "Tomate", "image": "asset/tomate.jpg", "price": 2.5, "unit": "kg", "category": "Légumes"},
    {"name": "Pomme", "image": "asset/pomme.jpg", "price": 1.8, "unit": "kg", "category": "Fruits"},
    {"name": "Carotte", "image": "asset/carotte.jpg", "price": 1.2, "unit": "kg", "category": "Légumes"},
    {"name": "Banane", "image": "asset/banane.webp", "price": 2.0, "unit": "kg", "category": "Fruits"},
    {"name": "Poisson", "image": "asset/poisson.jpg", "price": 8.0, "unit": "kg", "category": "Viande"},
    {"name": "Lait", "image": "asset/lait.webp", "price": 1.5, "unit": "L", "category": "Produits laitiers"},
    {"name": "Riz", "image": "asset/riz.webp", "price": 3.0, "unit": "kg", "category": "Céréales"},
    {"name": "Poulet", "image": "asset/poulet.jpg", "price": 6.5, "unit": "kg", "category": "Viande"},
    {"name": "Oeuf", "image": "asset/oeuf.jpg", "price": 2.2, "unit": "12", "category": "Produits laitiers"},
    {"name": "Huile", "image": "asset/huile.webp", "price": 4.0, "unit": "L", "category": "Huiles"},
    {"name": "Sucre", "image": "asset/sucre.jpg", "price": 1.0, "unit": "kg", "category": "Sucreries"},
    {"name": "Sel", "image": "asset/sel.jpg", "price": 0.5, "unit": "kg", "category": "Épices"},
    {"name": "Poivre", "image": "asset/poivre.jpg", "price": 1.8, "unit": "kg", "category": "Épices"},
    {"name": "Café", "image": "asset/cafe.jpg", "price": 5.0, "unit": "kg", "category": "Boissons"},
    {"name": "Thé", "image": "asset/the.png", "price": 3.5, "unit": "kg", "category": "Boissons"},
    {"name": "Jus", "image": "asset/jus.png", "price": 2.8, "unit": "L", "category": "Boissons"},
    {"name": "Eau", "image": "asset/eau.jpg", "price": 0.8, "unit": "L", "category": "Boissons"},
    {"name": "Pain", "image": "asset/pain.jfif", "price": 1.2, "unit": "pièce", "category": "Boulangerie"},
    {"name": "Farine", "image": "asset/farine.jfif", "price": 2.0, "unit": "kg", "category": "Céréales"},
    {"name": "Pâtes", "image": "asset/pates.jpg", "price": 1.5, "unit": "kg", "category": "Céréales"},
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
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _cartItems = [];
  final UserProfile _currentUser = UserProfile(
    name: 'Franck Morel',
    email: 'franckmorelassogba@gmail.com',
    phoneNumber: '66064997',
    address: 'Abomey calavi, kpota ',
    preferences: ['Vegetarien', 'Sans gluten'],
  );

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
                  height: 120,
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
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'asset/logoahissinon.png',
                        width: 80,
                      ),
                      IconButton(
                        icon: const Icon(Icons.account_circle,
                            size: 32, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilPage(user: _currentUser),
                            ),
                          );
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
                        color: _selectedCategory == index
                            ? Colors.white
                            : Colors.black,
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
                itemCount: _selectedCategory == 0
                    ? _products.length
                    : _products
                        .where((product) =>
                            product['category'] ==
                            _categories[_selectedCategory])
                        .length,
                itemBuilder: (context, index) {
                  final filteredProducts = _selectedCategory == 0
                      ? _products
                      : _products
                          .where((product) =>
                              product['category'] ==
                              _categories[_selectedCategory])
                          .toList();
                  final product = filteredProducts[index];
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${product["price"]} €/${product["unit"]}",
                                style: const TextStyle(fontSize: 12),
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
                                setState(() {
                                  // Ajouter le produit au panier
                                  _cartItems.add(product);
                                });
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
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Portefeuille'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Panier'),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            // Accueil, rien à faire
          } else if (index == 1) {
            // Portefeuille
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PortefeuillePage()),
            );
          } else if (index == 2) {
            // Panier
          Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PanierPage(cartItems: _cartItems, user: _currentUser),
  ),
);

          }
        },
      ),
    );
  }
}
