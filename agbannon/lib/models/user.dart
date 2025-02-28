// lib/models/user.dart

class Marchand {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final String? photoUrl;
  final String? boutiqueName;
  final String? marche;
  final String? adresse;
  final String role = 'marchand'; // Rôle par défaut

  Marchand({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    this.photoUrl,
    this.boutiqueName,
    this.marche,
    this.adresse,
  });

  // Conversion de Map à Marchand (pour récupérer les données de Firestore)
  factory Marchand.fromMap(Map<String, dynamic> map, String id) {
    return Marchand(
      id: id,
      nom: map['nom'] ?? '',
      prenom: map['prenom'] ?? '',
      email: map['email'] ?? '',
      telephone: map['telephone'] ?? '',
      photoUrl: map['photoUrl'],
      boutiqueName: map['boutiqueName'],
      marche: map['marche'],
      adresse: map['adresse'],
    );
  }

  // Conversion de Marchand à Map (pour stocker dans Firestore)
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'photoUrl': photoUrl,
      'boutiqueName': boutiqueName,
      'marche': marche,
      'adresse': adresse,
      'role': role,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // Créer une copie du marchand avec des modifications
  Marchand copyWith({
    String? nom,
    String? prenom,
    String? email,
    String? telephone,
    String? photoUrl,
    String? boutiqueName,
    String? marche,
    String? adresse,
  }) {
    return Marchand(
      id: this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      photoUrl: photoUrl ?? this.photoUrl,
      boutiqueName: boutiqueName ?? this.boutiqueName,
      marche: marche ?? this.marche,
      adresse: adresse ?? this.adresse,
    );
  }
}
