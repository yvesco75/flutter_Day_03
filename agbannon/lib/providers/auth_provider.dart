// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  Marchand? _marchandData;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  Marchand? get marchandData => _marchandData;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  // Initialiser l'état d'authentification
  AuthProvider() {
    _initAuthState();
  }

  // Écouter les changements d'état d'authentification
  void _initAuthState() {
    _setLoading(true);

    _authService.authStateChanges.listen((User? user) async {
      _user = user;

      if (user != null) {
        await _loadUserData();
      } else {
        _marchandData = null;
      }

      _setLoading(false);
      notifyListeners();
    });
  }

  // Charger les données du marchand
  Future<void> _loadUserData() async {
    try {
      _marchandData = await _authService.getCurrentMarchandData();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Inscription
  Future<bool> register({
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
      _setLoading(true);
      _clearError();

      await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        nom: nom,
        prenom: prenom,
        telephone: telephone,
        boutiqueName: boutiqueName,
        marche: marche,
        adresse: adresse,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_handleAuthError(e));
      return false;
    }
  }

  // Connexion
  Future<bool> login({required String email, required String password}) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_handleAuthError(e));
      return false;
    }
  }

  // Déconnexion
  Future<void> logout() async {
    try {
      _setLoading(true);
      await _authService.signOut();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
    }
  }

  // Mettre à jour le profil
  Future<bool> updateProfile(Marchand marchand) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.updateMarchandProfile(marchand);
      _marchandData = marchand;

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  // Réinitialiser le mot de passe
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.resetPassword(email);

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_handleAuthError(e));
      return false;
    }
  }

  // Définir l'état de chargement
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Définir un message d'erreur
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  // Effacer le message d'erreur
  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Gérer les erreurs d'authentification Firebase
  String _handleAuthError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return 'Adresse email invalide.';
        case 'user-disabled':
          return 'Ce compte a été désactivé.';
        case 'user-not-found':
          return 'Aucun utilisateur trouvé avec cette adresse email.';
        case 'wrong-password':
          return 'Mot de passe incorrect.';
        case 'email-already-in-use':
          return 'Cette adresse email est déjà utilisée.';
        case 'operation-not-allowed':
          return 'Opération non autorisée.';
        case 'weak-password':
          return 'Le mot de passe est trop faible.';
        default:
          return 'Une erreur s\'est produite: ${e.message}';
      }
    }
    return e.toString();
  }
}
