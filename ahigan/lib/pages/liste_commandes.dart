import 'package:flutter/material.dart';

// Classe Produit
class Produit {
  final String nom;
  final int quantite;
  final double prix;

  Produit({required this.nom, required this.quantite, required this.prix});
}

// Classe Commande
class Commande {
  final String id;
  final String clientNom;
  final String clientTelephone;
  final String clientAdresse;
  final double montant;
  String statut; // "En attente", "Validée", "Livrée", "Attribuée"
  final DateTime date;
  final List<Produit> produits;
  String? marchand; // Ajout du champ marchand

  Commande({
    required this.id,
    required this.clientNom,
    required this.clientTelephone,
    required this.clientAdresse,
    required this.montant,
    required this.statut,
    required this.date,
    required this.produits,
    this.marchand, // Initialisation du champ marchand
  });
}

// Liste statique des commandes
List<Commande> commandes = [
  Commande(
    id: "CMD001",
    clientNom: "Jean Dupont",
    clientTelephone: "0123456789",
    clientAdresse: "123 Rue des Fleurs",
    montant: 150.0,
    statut: "En attente",
    date: DateTime.now(),
    produits: [
      Produit(nom: "Tomates", quantite: 2, prix: 5.0),
      Produit(nom: "Pommes", quantite: 3, prix: 10.0),
    ],
    marchand: null, // Pas encore attribué
  ),
  Commande(
    id: "CMD002",
    clientNom: "Marie Curie",
    clientTelephone: "0987654321",
    clientAdresse: "456 Avenue Lumière",
    montant: 300.0,
    statut: "Validée",
    date: DateTime.now(),
    produits: [
      Produit(nom: "Oranges", quantite: 5, prix: 8.0),
    ],
    marchand: "Maman Exau", // Exemple de marchand attribué
  ),
  Commande(
    id: "CMD003",
    clientNom: "Abdou Abd",
    clientTelephone: "0987654321",
    clientAdresse: "456 Avenue Lumière",
    montant: 300.0,
    statut: "Validée",
    date: DateTime.now(),
    produits: [
      Produit(nom: "Pain", quantite: 1, prix: 5.0),
    ],
  ),Commande(
    id: "CMD004",
    clientNom: "Vivien Y",
    clientTelephone: "344455667",
    clientAdresse: "456 Avenue Lumière",
    montant: 300.0,
    statut: "Livrée",
    date: DateTime.now(),
    produits: [
      Produit(nom: "Kiwi", quantite: 2, prix: 4.0),
    ],
  ),Commande(
    id: "CMD005",
    clientNom: "Marc Loto",
    clientTelephone: "0987654321",
    clientAdresse: "456 Avenue Lumière",
    montant: 300.0,
    statut: "Validée",
    date: DateTime.now(),
    produits: [
      Produit(nom: "Pince", quantite: 15, prix: 150.0),
    ],
  ),
];


// Écran Liste des Commandes
class ListeCommandes extends StatefulWidget {
  const ListeCommandes({super.key});

  @override
  _ListeCommandesState createState() => _ListeCommandesState();
}

class _ListeCommandesState extends State<ListeCommandes> {
  String filtreStatut = "Tous";
  TextEditingController rechercheController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Commande> commandesFiltrees = commandes.where((commande) {
      if (filtreStatut != "Tous" && commande.statut != filtreStatut) {
        return false;
      }
      if (rechercheController.text.isNotEmpty &&
          !commande.id.contains(rechercheController.text)) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Liste des Commandes")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: rechercheController,
              decoration: const InputDecoration(
                labelText: "Rechercher par ID",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          DropdownButton<String>(
            value: filtreStatut,
            items: ["Tous", "En attente", "Validée", "Livrée"]
                .map((statut) => DropdownMenuItem(
                      value: statut,
                      child: Text(statut),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                filtreStatut = value!;
              });
            },
          ),

          Expanded(
            child: ListView.builder(
              itemCount: commandesFiltrees.length,
              itemBuilder: (context, index) {
                var commande = commandesFiltrees[index];
                return Card(
                  child: ListTile(
                    title: Text("Commande ${commande.id} - ${commande.clientNom}"),
                    subtitle: Text("Montant: ${commande.montant} € - Statut: ${commande.statut}"),
                    trailing: ElevatedButton(
                      child: const Text("Détails"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsCommande(commande: commande),
                          ),
                        ).then((_) => setState(() {}));
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Page Détails d'une Commande
class DetailsCommande extends StatefulWidget {
  final Commande commande;
  const DetailsCommande({super.key, required this.commande});

  @override
  _DetailsCommandeState createState() => _DetailsCommandeState();
}

class _DetailsCommandeState extends State<DetailsCommande> {
  List<String> marchands = ["Maman Exau", "Guinon", "Honon"];
  String? marchandSelectionne;

  void attribuerMarchand() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Attribuer un marchand"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: marchands.map((marchand) {
                  return RadioListTile<String>(
                    title: Text(marchand),
                    value: marchand,
                    groupValue: marchandSelectionne,
                    onChanged: (value) {
                      setStateDialog(() {
                        marchandSelectionne = value!;
                      });
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (marchandSelectionne != null) {
                      setState(() {
                        widget.commande.marchand = marchandSelectionne;
                        widget.commande.statut = "Attribuée à $marchandSelectionne";
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Attribuer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détails de la Commande")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Client: ${widget.commande.clientNom}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Téléphone: ${widget.commande.clientTelephone}"),
            Text("Adresse: ${widget.commande.clientAdresse}"),
            const SizedBox(height: 10),

            const Text("Produits commandés:", style: TextStyle(fontWeight: FontWeight.bold)),
            ...widget.commande.produits.map((produit) => ListTile(
                  title: Text(produit.nom),
                  subtitle: Text("Quantité: ${produit.quantite} - Prix: ${produit.prix} €"),
                )),

            const SizedBox(height: 20),

            // Affichage du marchand qui a géré la commande
            widget.commande.marchand != null
                ? Text("Marchand: ${widget.commande.marchand}",
                    style: const TextStyle(fontWeight: FontWeight.bold))
                : const SizedBox.shrink(),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => widget.commande.statut = "Validée"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Valider"),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => widget.commande.statut = "Refusée"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Refuser"),
                ),
                ElevatedButton(
                  onPressed: attribuerMarchand,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text("Attribuer"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}