// lib/services/offer_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/offer.dart';

class OfferService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Offer>> fetchOffers() async {
    try {
      final querySnapshot = await _firestore.collection('offers').get();
      return querySnapshot.docs
          .map((doc) => Offer.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Impossible de charger les offres');
    }
  }

  Future<void> deleteOffer(String offerId) async {
    try {
      await _firestore.collection('offers').doc(offerId).delete();
    } catch (e) {
      throw Exception('Erreur de suppression de l\'offre');
    }
  }
}
