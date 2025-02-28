// lib/config/firebase_config.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Classe pour gérer les instances Firebase
class FirebaseConfig {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  // Initialisation de Firebase
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }
}
