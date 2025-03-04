import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product.dart';
import 'package:go_router/go_router.dart';

class ProductListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProductListScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  // Constructeur de fabrique pour la création à partir des paramètres de route Go Router
  static ProductListScreen fromGoRouterState(GoRouterState state) {
    final categoryId = state.pathParameters['categoryId'] ?? '';
    final extra = state.extra as Map<String, dynamic>?;
    final categoryName = extra?['categoryName'] as String? ?? 'Catégorie';

    return ProductListScreen(
      categoryId: categoryId,
      categoryName: categoryName,
    );
  }

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Charger les produits depuis Firestore pour la catégorie spécifique
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('categoryId', isEqualTo: widget.categoryId)
          .orderBy('createdAt', descending: true)
          .get();

      final loadedProducts = querySnapshot.docs.map((doc) {
        return Product(
          id: doc.id,
          name: doc['name'],
          description: doc['description'],
          price: doc['price'].toDouble(),
          imageUrl: doc['imageUrl'],
          categoryId: doc['categoryId'],
        );
      }).toList();

      if (mounted) {
        setState(() {
          products = loadedProducts;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement des produits: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadProducts,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Aucun produit trouvé dans cette catégorie'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => context.goNamed('add-product'),
                        child: const Text('Ajouter un produit'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadProducts,
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: Hero(
                            tag: 'product_image_${product.id}',
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(product.imageUrl),
                              onBackgroundImageError: (_, __) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 20),
                          onTap: () {
                            // Navigation vers les détails du produit avec go_router
                            context.goNamed('edit-product', extra: product);
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed('add-product');
        },
        tooltip: 'Ajouter un produit',
        child: const Icon(Icons.add),
      ),
    );
  }
}
