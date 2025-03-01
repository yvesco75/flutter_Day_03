import 'package:flutter/material.dart';
import 'package:background_app_bar/background_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'Toutes les catégories';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 220.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.orange,
              flexibleSpace: BackgroundFlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 8),
                title: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: const Text(
                      "Simplifier votre quotidien en effectuant vos achats partout et à tout moment.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.orange.withAlpha((255 * 0.4).round()),
                        BlendMode.srcATop,
                      ),
                      child: Image.asset(
                        'asset/market.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'asset/logoahissinon.png',
                    width: 80,
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle, color: Colors.white),
                    onPressed: () {
                      debugPrint("Profil ouvert");
                    },
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue!;
                            debugPrint('Catégorie sélectionnée : $_selectedCategory');
                          });
                        },
                        items: <String>[
                          'Toutes les catégories',
                          'Fruits et légumes',
                          'Céréales et légumineuses',
                          'Viandes et poissons',
                          'Produits laitiers',
                          'Condiments et épices',
                          'Boissons',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        dropdownColor: Colors.white,
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                        underline: Container(),
                        isExpanded: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Rechercher un produit...',
                            suffixIcon: InkWell( // Utilisez InkWell pour rendre l'icône cliquable
                              onTap: () {
                                debugPrint('Recherche : ${_searchController.text}');
                                // Ajoutez ici la logique de recherche
                              },
                              child: const Icon(Icons.search),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ... autres parties à ajouter ici (grille des produits, pagination, barre de navigation) ...
          ],
        ),
      ),
    );
  }
}