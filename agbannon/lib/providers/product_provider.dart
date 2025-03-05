import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour récupérer tous les produits
  // providers/product_provider.dart

  Future<List<Product>> fetchProducts() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('products').get();

      // Conversion correcte des documents en objets Product
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Product.fromMap(data);
      }).toList();
    } catch (e) {
      debugPrint("Erreur lors de la récupération des produits : $e");
      throw Exception('Erreur lors de la récupération des produits : $e');
    }
  }

  // Méthode pour ajouter un produit
  Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection('products').add(product.toMap());
      _products.add(product);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur lors de l'ajout du produit : $e");
    }
  }
}
