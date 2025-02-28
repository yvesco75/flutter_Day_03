// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/firebase_config.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseConfig.auth;
  final FirebaseFirestore _firestore = FirebaseConfig.firestore;

  // Collection des marchands
  final CollectionReference _marchandsCollection = FirebaseFirestore.instance
      .collection('marchands');

  // Obtenir l'utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Stream pour suivre les changements d'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Inscription avec email et mot de passe
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required String telephone,
    String? boutiqueName,
    String? marche,
    String? adresse,
  }) async {
    try {
      // Créer l'utilisateur dans Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Créer le document marchand dans Firestore
      Marchand marchand = Marchand(
        id: result.user!.uid,
        nom: nom,
        prenom: prenom,
        email: email,
        telephone: telephone,
        boutiqueName: boutiqueName,
        marche: marche,
        adresse: adresse,
      );

      await _marchandsCollection.doc(result.user!.uid).set(marchand.toMap());

      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Connexion avec email et mot de passe
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // Récupérer les données du marchand actuel
  Future<Marchand?> getCurrentMarchandData() async {
    try {
      if (_auth.currentUser == null) return null;

      DocumentSnapshot doc =
          await _marchandsCollection.doc(_auth.currentUser!.uid).get();

      if (doc.exists) {
        return Marchand.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Mettre à jour le profil du marchand
  Future<void> updateMarchandProfile(Marchand marchand) async {
    try {
      await _marchandsCollection.doc(marchand.id).update(marchand.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Réinitialiser le mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
}
