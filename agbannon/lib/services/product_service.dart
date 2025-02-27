// lib/services/product_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/product.dart';
import 'auth_service.dart';

class ProductService {
  final AuthService _authService = AuthService();

  Future<List<Product>> getProducts({
    int page = 1,
    int limit = AppConstants.defaultPageSize,
    String? category,
    String? search,
    bool inStock = false,
  }) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Construction de l'URL avec les paramètres
      final queryParams = {'page': page.toString(), 'limit': limit.toString()};

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (inStock) {
        queryParams['in_stock'] = 'true';
      }

      final Uri uri = Uri.parse(
        AppConstants.productsEndpoint,
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'];

        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(AppConstants.serverError);
      }
    } catch (e) {
      throw Exception(
        'Erreur lors de la récupération des produits: ${e.toString()}',
      );
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      final response = await http.get(
        Uri.parse('${AppConstants.productsEndpoint}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Produit non trouvé');
      }
    } catch (e) {
      throw Exception(
        'Erreur lors de la récupération du produit: ${e.toString()}',
      );
    }
  }

  Future<Product> addProduct(Product product, File? imageFile) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Si une image est fournie, on l'upload d'abord
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile);
      }

      // Préparation des données du produit
      final productData = product.toJson();
      if (imageUrl != null) {
        productData['imageUrl'] = imageUrl;
      }

      final response = await http.post(
        Uri.parse(AppConstants.productsEndpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(productData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Erreur lors de l\'ajout du produit');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du produit: ${e.toString()}');
    }
  }

  Future<Product> updateProduct(
    String id,
    Product product,
    File? imageFile,
  ) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Si une image est fournie, on l'upload d'abord
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile);
      }

      // Préparation des données du produit
      final productData = product.toJson();
      if (imageUrl != null) {
        productData['imageUrl'] = imageUrl;
      }

      final response = await http.put(
        Uri.parse('${AppConstants.productsEndpoint}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(productData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Erreur lors de la mise à jour du produit');
      }
    } catch (e) {
      throw Exception(
        'Erreur lors de la mise à jour du produit: ${e.toString()}',
      );
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      final response = await http.delete(
        Uri.parse('${AppConstants.productsEndpoint}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception(
        'Erreur lors de la suppression du produit: ${e.toString()}',
      );
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/categories'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> categoriesJson = data['categories'];

        return categoriesJson.map((json) => json['name'].toString()).toList();
      } else {
        // En cas d'erreur, retourner les catégories par défaut
        return AppConstants.defaultCategories;
      }
    } catch (e) {
      // En cas d'erreur, retourner les catégories par défaut
      return AppConstants.defaultCategories;
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Création d'une requête multipart pour l'upload d'image
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.baseUrl}/upload'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Ajout du fichier à la requête
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      // Envoi de la requête
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['url'];
      } else {
        throw Exception('Erreur lors de l\'upload de l\'image');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'upload de l\'image: ${e.toString()}');
    }
  }
}
