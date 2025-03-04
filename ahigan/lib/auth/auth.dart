import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  // methode de connexion avec email-pwd
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //methode de deconnexion
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  //methode de creation de compte avec email-pwd
Future<void> createUserWithEmailAndPassword(String email, String password) async{
  await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
}
}

