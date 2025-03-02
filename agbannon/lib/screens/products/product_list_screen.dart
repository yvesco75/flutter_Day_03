import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_product_screen.dart'; // Écran pour ajouter un produit

class ProductListScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  ProductListScreen({required this.categoryId, required this.categoryName});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Naviguer vers l'écran d'ajout de produit
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddProductScreen(categoryId: categoryId),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('products')
            .where('categoryId', isEqualTo: categoryId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des produits'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun produit disponible'));
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final productName = product['name'];
              final productPrice = product['price'];
              final productImage = product['imageUrl'];
              final productQuantity = product['quantity'];

              return ListTile(
                leading: productImage != null
                    ? Image.network(productImage, width: 50, height: 50)
                    : Icon(Icons.shopping_basket),
                title: Text(productName),
                subtitle: Text(
                    'Prix: $productPrice FCFA - Quantité: $productQuantity'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    // Supprimer le produit
                    await _firestore
                        .collection('products')
                        .doc(product.id)
                        .delete();
                  },
                ),
                onTap: () {
                  // Naviguer vers l'écran de détails ou de modification du produit
                  // (À implémenter)
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviguer vers l'écran d'ajout de produit
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreen(categoryId: categoryId),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
