import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Puisque vous débutez, utilisons une configuration simple
    return const FirebaseOptions(
      apiKey: 'VOTRE_API_KEY',
      appId: 'VOTRE_APP_ID',
      messagingSenderId: 'VOTRE_MESSAGING_SENDER_ID',
      projectId: 'VOTRE_PROJECT_ID',
      storageBucket: 'VOTRE_STORAGE_BUCKET',
      authDomain: 'VOTRE_AUTH_DOMAIN',
    );
  }
}
