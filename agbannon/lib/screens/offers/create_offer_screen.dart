// lib/screens/offers/offer_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/offer.dart';
import '../../providers/offer_provider.dart';
import '../../widgets/common/app_bar.dart';
import '../../widgets/common/loading.dart';

class OfferListScreen extends StatefulWidget {
  const OfferListScreen({Key? key}) : super(key: key);

  @override
  _OfferListScreenState createState() => _OfferListScreenState();
}

class _OfferListScreenState extends State<OfferListScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les offres lors de l'initialisation de l'écran
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OfferProvider>(context, listen: false).fetchOffers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Mes Offres',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/offers/create'),
          ),
        ],
      ),
      body: Consumer<OfferProvider>(
        builder: (context, offerProvider, child) {
          // Gestion des différents états de chargement
          if (offerProvider.isLoading) {
            return const LoadingWidget();
          }

          if (offerProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erreur : ${offerProvider.errorMessage}'),
                  ElevatedButton(
                    onPressed: () => offerProvider.fetchOffers(),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          // Liste des offres
          final offers = offerProvider.offers;

          if (offers.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucune offre disponible',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => offerProvider.fetchOffers(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return _buildOfferCard(context, offer);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context, Offer offer) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(
          offer.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Réduction: ${offer.discountPercentage}%'),
            Text('Valide jusqu\'au: ${offer.endDate}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                // Navigation vers l'écran d'édition de l'offre
                context.go('/offers/edit/${offer.id}');
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmationDialog(context, offer);
              },
            ),
          ],
        ),
        onTap: () {
          // Navigation vers les détails de l'offre
          context.go('/offers/${offer.id}');
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Offer offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'offre'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette offre ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // Suppression de l'offre
              Provider.of<OfferProvider>(context, listen: false)
                  .deleteOffer(offer.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
