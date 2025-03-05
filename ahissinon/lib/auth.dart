import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Connexion avec email et mot de passe
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception("Erreur de connexion : ${e.toString()}");
    }
  }

  // Déconnexion
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Création de compte avec email et mot de passe
  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception("Erreur lors de l'inscription : ${e.toString()}");
    }
  }
}
