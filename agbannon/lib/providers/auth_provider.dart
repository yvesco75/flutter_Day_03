import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomAuthProvider with ChangeNotifier {
  // FirebaseAuth instance to manage authentication
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Getter for the current authenticated user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Method for login with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners(); // Notifie les listeners que l'état a changé
    } catch (e) {
      throw FirebaseAuthException(
        code: 'LOGIN_FAILED',
        message: 'Failed to login. Please check your credentials.',
      );
    }
  }

  // Method to log out the current user
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      notifyListeners(); // Notifie les listeners que l'état a changé
    } catch (e) {
      throw FirebaseAuthException(
        code: 'LOGOUT_FAILED',
        message: 'Failed to log out. Please try again later.',
      );
    }
  }

  // Method to create a new user with email and password
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners(); // Notifie les listeners que l'état a changé
    } catch (e) {
      throw FirebaseAuthException(
        code: 'SIGNUP_FAILED',
        message: 'Failed to create an account. Please try again.',
      );
    }
  }
}
