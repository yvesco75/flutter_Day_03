class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final String category; // Ajout de la propriété category
  final int stock;
  final bool isAvailable;
  final int quantity; // Ajout de la propriété quantity

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    this.category = '', // Initialisation par défaut de category
    this.stock = 0,
    this.isAvailable = true,
    this.quantity = 0, // Initialisation par défaut de quantity
  });

  // Convertir un objet Product en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'category': category, // Ajout de category à la map
      'stock': stock,
      'isAvailable': isAvailable,
      'quantity': quantity, // Ajout de quantity à la map
    };
  }

  // Créer un objet Product à partir d'un Map de Firestore
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      categoryId: map['categoryId'] ?? '',
      category: map['category'] ?? '', // Ajout de category
      stock: map['stock'] ?? 0,
      isAvailable: map['isAvailable'] ?? true,
      quantity: map['quantity'] ?? 0, // Ajout de quantity
    );
  }

  // Créer une copie d'un produit avec des modifications
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? categoryId,
    String? category, // Ajout de category
    int? stock,
    bool? isAvailable,
    int? quantity, // Ajout de quantity
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category, // Ajout de category
      stock: stock ?? this.stock,
      isAvailable: isAvailable ?? this.isAvailable,
      quantity: quantity ?? this.quantity, // Ajout de quantity
    );
  }
}
