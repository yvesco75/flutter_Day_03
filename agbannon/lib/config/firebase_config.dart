// lib/config/firebase_config.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../firebase_options.dart'; // Assurez-vous d'importer vos options Firebase

class FirebaseConfig {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  // Initialisation de Firebase avec gestion des erreurs
  static Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('Firebase initialisé avec succès');
    } catch (e) {
      print('Erreur lors de l\'initialisation de Firebase : $e');
      rethrow; // Relancer l'erreur pour une gestion plus haut
    }
  }
}
