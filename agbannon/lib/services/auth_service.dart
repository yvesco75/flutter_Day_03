import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/firebase_config.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseConfig.auth;
  final FirebaseFirestore _firestore = FirebaseConfig.firestore;

  // Collection des marchands
  final CollectionReference _marchandsCollection =
      FirebaseFirestore.instance.collection('marchands');

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

      // Notifier les écouteurs des changements
      notifyListeners();

      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw 'Une erreur inattendue s\'est produite. Veuillez réessayer.';
    }
  }

  // Connexion avec email et mot de passe
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Notifier les écouteurs des changements
      notifyListeners();

      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw 'Une erreur inattendue s\'est produite. Veuillez réessayer.';
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    try {
      await _auth.signOut();

      // Notifier les écouteurs des changements
      notifyListeners();
    } catch (e) {
      throw 'Erreur lors de la déconnexion. Veuillez réessayer.';
    }
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
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw 'Une erreur inattendue s\'est produite. Veuillez réessayer.';
    }
  }

  // Mettre à jour le profil du marchand
  Future<void> updateMarchandProfile(Marchand marchand) async {
    try {
      await _marchandsCollection.doc(marchand.id).update(marchand.toMap());

      // Notifier les écouteurs des changements
      notifyListeners();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw 'Une erreur inattendue s\'est produite. Veuillez réessayer.';
    }
  }

  // Réinitialiser le mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw 'Une erreur inattendue s\'est produite. Veuillez réessayer.';
    }
  }

  // Gestion des erreurs Firebase Auth
  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'invalid-email':
        return 'L\'email est invalide.';
      case 'operation-not-allowed':
        return 'L\'opération n\'est pas autorisée.';
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      default:
        return 'Une erreur s\'est produite. Veuillez réessayer.';
    }
  }

  // Gestion des erreurs Firebase Firestore
  String _handleFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Permission refusée.';
      case 'unavailable':
        return 'Le service est indisponible. Veuillez réessayer plus tard.';
      default:
        return 'Une erreur s\'est produite. Veuillez réessayer.';
    }
  }
}
