import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../models/offer.dart';
import '../../providers/offer_provider.dart';
import '../../widgets/common/app_bar.dart';

class CreateOfferScreen extends StatefulWidget {
  const CreateOfferScreen({Key? key}) : super(key: key);

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _discountPercentageController = TextEditingController();
  final _endDateController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _discountPercentageController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Créer une offre',
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.blue),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final offer = Offer(
                  title: _titleController.text,
                  description: '', // Description vide
                  discountPercentage:
                      double.parse(_discountPercentageController.text),
                  startDate: DateTime.now(), // Date de début actuelle
                  endDate: DateTime.parse(
                      _endDateController.text), // Date de fin parsée
                  applicableProductIds: [], // Liste vide pour les IDs de produits applicables
                );

                try {
                  await Provider.of<OfferProvider>(context, listen: false)
                      .addOffer(offer);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Offre créée avec succès')),
                  );
                  context.go('/offers');
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur : $error')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titre de l\'offre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _discountPercentageController,
                decoration: const InputDecoration(
                  labelText: 'Pourcentage de réduction',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un pourcentage';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _endDateController,
                decoration: const InputDecoration(
                  labelText: 'Date de fin',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une date';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
