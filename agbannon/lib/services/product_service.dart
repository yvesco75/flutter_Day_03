// product_service.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductService {
  final BuildContext context;

  ProductService(this.context);

  Future<List<Product>> fetchProducts() async {
    try {
      return await Provider.of<ProductProvider>(context, listen: false)
          .fetchProducts();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erreur lors du chargement des produits: $error')),
      );
      return [];
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .addProduct(product);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout du produit: $error')),
      );
    }
  }
}
