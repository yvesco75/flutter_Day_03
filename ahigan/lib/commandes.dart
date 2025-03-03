// import 'package:flutter/material.dart';

// class CommandePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Gestion des commandes'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Rechercher une commande',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 FilterChip(
//                   label: Text('En attente'),
//                   onSelected: (bool value) {
//                     // Filtrer les commandes
//                   },
//                 ),
//                 SizedBox(width: 8),
//                 FilterChip(
//                   label: Text('Validées'),
//                   onSelected: (bool value) {
//                     // Filtrer les commandes
//                   },
//                 ),
//                 SizedBox(width: 8),
//                 FilterChip(
//                   label: Text('Livrées'),
//                   onSelected: (bool value) {
//                     // Filtrer les commandes
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: ListView(
//                 children: [
//                   ListTile(
//                     title: Text('Commande ID123'),
//                     subtitle: Text('Client A - 10 000 FCFA'),
//                     trailing: Icon(Icons.arrow_forward),
//                     onTap: () {
//                       // Naviguer vers les détails de la commande
//                     },
//                   ),
//                   ListTile(
//                     title: Text('Commande ID456'),
//                     subtitle: Text('Client B - 15 000 FCFA'),
//                     trailing: Icon(Icons.arrow_forward),
//                     onTap: () {
//                       // Naviguer vers les détails de la commande
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }