import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../config/routes.dart';
// Importez votre service de produits si nécessaire
// import '../../services/product_service.dart';

class ProductListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProductListScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

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
      // Remplacez ceci par votre propre logique pour charger les produits
      // Exemple avec un service:
      // final loadedProducts = await ProductService().getProductsByCategory(widget.categoryId);

      // Pour l'exemple, je crée une liste factice
      final loadedProducts = [
        Product(
          id: '1',
          name: 'Produit 1 de ${widget.categoryName}',
          description: 'Description du produit 1',
          price: 199.99,
          imageUrl: 'https://via.placeholder.com/150',
          categoryId: widget.categoryId,
        ),
        Product(
          id: '2',
          name: 'Produit 2 de ${widget.categoryName}',
          description: 'Description du produit 2',
          price: 299.99,
          imageUrl: 'https://via.placeholder.com/150',
          categoryId: widget.categoryId,
        ),
        // Ajoutez plus de produits fictifs au besoin
      ];

      setState(() {
        products = loadedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Gérer l'erreur (afficher un message, etc.)
      print('Erreur lors du chargement des produits: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(
                  child: Text('Aucun produit trouvé dans cette catégorie'))
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Image.network(
                          products[index].imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, error, _) =>
                              const Icon(Icons.image_not_supported, size: 50),
                        ),
                        title: Text(products[index].name),
                        subtitle: Text(
                            '\$${products[index].price.toStringAsFixed(2)}'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Naviguer vers les détails du produit
                          Routes.navigatePushWithArgs(
                            context,
                            Routes.productDetail,
                            products[index],
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Routes.navigatePush(context, Routes.addProduct);
        },
        child: const Icon(Icons.add),
        tooltip: 'Ajouter un produit',
      ),
    );
  }
}
