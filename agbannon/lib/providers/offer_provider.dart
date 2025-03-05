// lib/providers/offer_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/offer.dart';

class OfferProvider with ChangeNotifier {
  // Liste des offres
  List<Offer> _offers = [];
  List<Offer> get offers => _offers;

  // État de chargement et gestion des erreurs
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupération des offres
  Future<List<Offer>> fetchOffers({
    DocumentSnapshot? lastDoc,
    int limit = 10,
    bool? isActive,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      Query query = _firestore
          .collection('offers')
          .orderBy('createdAt', descending: true);

      // Filtre optionnel pour les offres actives
      if (isActive != null) {
        query = query.where('isActive', isEqualTo: isActive);
      }

      query = query.limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final QuerySnapshot snapshot = await query.get();

      _offers = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Offer.fromMap({...data, 'id': doc.id});
      }).toList();

      _isLoading = false;
      notifyListeners();
      return _offers;
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Erreur lors de la récupération des offres : $e";
      notifyListeners();
      throw Exception(_errorMessage);
    }
  }

  // Récupération des détails d'une offre
  Future<Offer> fetchOfferDetails(String offerId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('offers').doc(offerId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return Offer.fromMap({...data, 'id': doc.id});
      } else {
        throw Exception('Offre introuvable');
      }
    } catch (e) {
      _errorMessage = "Erreur lors de la récupération des détails : $e";
      notifyListeners();
      throw Exception(_errorMessage);
    }
  }

  // Ajout d'une nouvelle offre
  Future<Offer> addOffer(Offer offer) async {
    try {
      // Générer un ID si non fourni
      final docRef = offer.id == null || offer.id!.isEmpty
          ? _firestore.collection('offers').doc()
          : _firestore.collection('offers').doc(offer.id);

      // Préparer les données de l'offre
      final offerData = offer.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
      );

      // Ajouter ou mettre à jour l'offre
      await docRef.set(offerData.toMap());

      // Insérer dans la liste locale
      _offers.insert(0, offerData);
      notifyListeners();

      return offerData;
    } catch (e) {
      _errorMessage = "Erreur lors de l'ajout de l'offre : $e";
      notifyListeners();
      throw Exception(_errorMessage);
    }
  }

  // Mise à jour d'une offre
  Future<void> updateOffer(String offerId, Offer updatedOffer) async {
    try {
      // Assurez-vous que l'ID est correct
      final offerToUpdate = updatedOffer.copyWith(id: offerId);

      await _firestore
          .collection('offers')
          .doc(offerId)
          .update(offerToUpdate.toMap());

      final index = _offers.indexWhere((offer) => offer.id == offerId);
      if (index != -1) {
        _offers[index] = offerToUpdate;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Erreur lors de la mise à jour : $e";
      notifyListeners();
      throw Exception(_errorMessage);
    }
  }

  // Suppression d'une offre
  Future<void> deleteOffer(String offerId) async {
    try {
      await _firestore.collection('offers').doc(offerId).delete();

      _offers.removeWhere((offer) => offer.id == offerId);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Erreur lors de la suppression : $e";
      notifyListeners();
      throw Exception(_errorMessage);
    }
  }

  // Activation/Désactivation d'une offre
  Future<void> toggleOfferStatus(String offerId, bool isActive) async {
    try {
      await _firestore
          .collection('offers')
          .doc(offerId)
          .update({'isActive': isActive});

      final index = _offers.indexWhere((offer) => offer.id == offerId);
      if (index != -1) {
        _offers[index] = _offers[index].copyWith(isActive: isActive);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Erreur lors de la modification du statut : $e";
      notifyListeners();
      throw Exception(_errorMessage);
    }
  }

  // Filtrer les offres
  List<Offer> filterOffers({
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    double? minDiscount,
    double? maxDiscount,
  }) {
    return _offers.where((offer) {
      bool matchesActiveStatus = isActive == null || offer.isActive == isActive;

      bool matchesStartDate = startDate == null ||
          offer.startDate.isAfter(startDate) ||
          offer.startDate.isAtSameMomentAs(startDate);

      bool matchesEndDate = endDate == null ||
          offer.endDate.isBefore(endDate) ||
          offer.endDate.isAtSameMomentAs(endDate);

      bool matchesMinDiscount =
          minDiscount == null || offer.discountPercentage >= minDiscount;

      bool matchesMaxDiscount =
          maxDiscount == null || offer.discountPercentage <= maxDiscount;

      return matchesActiveStatus &&
          matchesStartDate &&
          matchesEndDate &&
          matchesMinDiscount &&
          matchesMaxDiscount;
    }).toList();
  }

  // Récupérer les offres actives
  List<Offer> getActiveOffers() {
    return filterOffers(isActive: true);
  }

  // Récupérer les offres expirées
  List<Offer> getExpiredOffers() {
    final now = DateTime.now();
    return _offers
        .where((offer) => offer.endDate.isBefore(now) || !offer.isActive)
        .toList();
  }

  // Réinitialisation des erreurs
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Recherche d'offres
  List<Offer> searchOffers(String query) {
    return _offers
        .where((offer) =>
            offer.title.toLowerCase().contains(query.toLowerCase()) ||
            offer.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Méthode supplémentaire pour gérer les cas où l'ID pourrait être null
  String _ensureValidId(String? id) {
    return (id == null || id.isEmpty)
        ? _firestore.collection('offers').doc().id
        : id;
  }
}
