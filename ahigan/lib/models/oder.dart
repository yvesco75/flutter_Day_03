// lib/models/Oder.dart
class Oder {
  final String id;
  final String nomMarchand;
  final String standMarchand;
  final List<Produit> produits;
  final String status;

  Oder({
    required this.id,
    required this.nomMarchand,
    required this.standMarchand,
    required this.produits,
    required this.status,
  });

  factory Oder.fromFirestore(Map<String, dynamic> data, String id) {
    return Oder(
      id: id,
      nomMarchand: data['nomMarchand'],
      standMarchand: data['standMarchand'],
      produits: (data['produits'] as List)
          .map((produit) => Produit.fromMap(produit))
          .toList(),
      status: data['status'],
    );
  }
}

class Produit {
  final String name;
  final int quantite;
  final String statusArrive;

  Produit({
    required this.name,
    required this.quantite,
    required this.statusArrive,
  });

  factory Produit.fromMap(Map<String, dynamic> data) {
    return Produit(
      name: data['name'],
      quantite: data['quantite'],
      statusArrive: data['statusArrive'],
    );
  }
}