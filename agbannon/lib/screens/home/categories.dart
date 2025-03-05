import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/category.dart';
import '../../widgets/common/app_bar.dart';
import '../../widgets/common/drawer.dart';
import '../../widgets/common/bottom_nav.dart'; // Importez BottomNavBar

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _categoriesStream;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategoryId;
  bool _isEditing = false;
  int _selectedIndex = 0; // Index sélectionné pour la BottomNavBar

  // Nouvelle méthode pour naviguer vers la liste des produits
  void _navigateToProductList(String categoryId, String categoryName) {
    GoRouter.of(context).go('/categories/$categoryId/products',
        extra: {'categoryName': categoryName});
  }

  @override
  void initState() {
    super.initState();
    _categoriesStream = _firestore.collection('categories').snapshots();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _descriptionController.clear();
      _selectedCategoryId = null;
      _isEditing = false;
    });
  }

  Future<void> _saveCategory() async {
    try {
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez entrer un nom de catégorie')),
        );
        return;
      }

      final categoryData = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (_isEditing && _selectedCategoryId != null) {
        // Mise à jour
        await _firestore
            .collection('categories')
            .doc(_selectedCategoryId)
            .update(categoryData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catégorie mise à jour avec succès')),
        );
      } else {
        // Création
        await _firestore.collection('categories').add(categoryData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catégorie ajoutée avec succès')),
        );
      }

      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  void _editCategory(Category category) {
    setState(() {
      _nameController.text = category.name;
      _descriptionController.text = category.description ?? '';
      _selectedCategoryId = category.id;
      _isEditing = true;
    });

    // Faire défiler vers le formulaire
    _showAddEditDialog(context);
  }

  Future<void> _deleteCategory(String categoryId) async {
    try {
      // Vérifier si la catégorie est utilisée par des produits
      final productsQuery = await _firestore
          .collection('products')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      if (productsQuery.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Cette catégorie est utilisée par des produits et ne peut pas être supprimée'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await _firestore.collection('categories').doc(categoryId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catégorie supprimée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  Future<void> _showAddEditDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              _isEditing ? 'Modifier la catégorie' : 'Ajouter une catégorie'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de la catégorie',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optionnelle)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetForm();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveCategory();
                Navigator.of(context).pop();
              },
              child: Text(_isEditing ? 'Mettre à jour' : 'Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _onBottomNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Gérer la navigation en fonction de l'index sélectionné
    switch (index) {
      case 0: // Accueil
        GoRouter.of(context).go('/home');
        break;
      case 1: // Catégories (rester sur la page actuelle)
        break;
      case 2: // Profil
        GoRouter.of(context).go('/profile');
        break;
      // Ajoutez d'autres cas pour les autres éléments de la barre de navigation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Catégories'),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Gestion des catégories',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddEditDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Nouvelle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _categoriesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erreur: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aucune catégorie trouvée.\nCliquez sur + pour en ajouter.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                // Convertir les documents en objets Category
                final categories = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Category(
                    id: doc.id,
                    name: data['name'] ?? '',
                    description: data['description'],
                  );
                }).toList();

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (ctx, index) {
                      final category = categories[index];
                      return _buildCategoryCard(category);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onBottomNavBarItemTapped,
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    // Générer une couleur pastel aléatoire
    final colors = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.amber.shade100,
      Colors.purple.shade100,
      Colors.pink.shade100,
      Colors.teal.shade100
    ];
    final colorIndex = category.name.hashCode % colors.length;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [colors[colorIndex], Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: InkWell(
          onTap: () {
            // Utiliser la nouvelle méthode de navigation
            _navigateToProductList(category.id, category.name);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editCategory(category);
                        } else if (value == 'delete') {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirmer la suppression'),
                              content: Text(
                                  'Voulez-vous vraiment supprimer la catégorie "${category.name}" ?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    _deleteCategory(category.id);
                                  },
                                  child: const Text(
                                    'Supprimer',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Text('Modifier'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Supprimer',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (category.description != null &&
                    category.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      category.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Utiliser la nouvelle méthode de navigation
                        _navigateToProductList(category.id, category.name);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text('Voir les produits'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
