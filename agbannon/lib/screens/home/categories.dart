import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String imageUrl;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.color,
  });
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Category> _categories = [
    Category(
      id: '1',
      name: 'Vêtements',
      imageUrl: 'assets/images/clothes.png',
      color: Colors.purple.shade400,
    ),
    Category(
      id: '2',
      name: 'Électronique',
      imageUrl: 'assets/images/electronics.png',
      color: Colors.blue.shade400,
    ),
    Category(
      id: '3',
      name: 'Alimentation',
      imageUrl: 'assets/images/food.png',
      color: Colors.orange.shade400,
    ),
    Category(
      id: '4',
      name: 'Maison',
      imageUrl: 'assets/images/home.png',
      color: Colors.green.shade400,
    ),
    Category(
      id: '5',
      name: 'Beauté',
      imageUrl: 'assets/images/beauty.png',
      color: Colors.pink.shade400,
    ),
    Category(
      id: '6',
      name: 'Sports',
      imageUrl: 'assets/images/sports.png',
      color: Colors.red.shade400,
    ),
    Category(
      id: '7',
      name: 'Livres',
      imageUrl: 'assets/images/books.png',
      color: Colors.teal.shade400,
    ),
    Category(
      id: '8',
      name: 'Jouets',
      imageUrl: 'assets/images/toys.png',
      color: Colors.amber.shade400,
    ),
  ];

  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Category> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return _categories;
    }
    return _categories
        .where((category) =>
            category.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher une catégorie...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: TextStyle(color: Colors.white),
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Text('Catégories'),
        backgroundColor: const Color.fromARGB(255, 97, 13, 233),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigation vers les notifications
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 97, 13, 233).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Explorer les catégories',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: _filteredCategories.isEmpty
                  ? Center(
                      child: Text(
                        'Aucune catégorie trouvée',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _filteredCategories.length,
                      itemBuilder: (ctx, index) {
                        return CategoryItem(
                          category: _filteredCategories[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 97, 13, 233),
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // Index pour la page catégories
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: 'Catégories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          // Navigation vers les différentes pages
        },
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigation vers la page de la catégorie
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => CategoryDetailScreen(category: category),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              category.color.withOpacity(0.7),
              category.color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: category.color.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  category.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, error, _) {
                    return Icon(
                      Icons.category,
                      size: 40,
                      color: category.color,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Page de détail d'une catégorie (squelette à compléter)
class CategoryDetailScreen extends StatelessWidget {
  final Category category;

  const CategoryDetailScreen({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: category.color,
      ),
      body: Center(
        child: Text(
          'Liste des produits de la catégorie ${category.name} à venir',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
