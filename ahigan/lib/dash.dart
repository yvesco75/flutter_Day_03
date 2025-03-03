// import 'package:flutter/material.dart';

// class DashboardPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tableau de bord'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               // Ajouter la logique de déconnexion ici
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 _buildStatCard('Commandes', '50'),
//                 SizedBox(width: 16),
//                 _buildStatCard('Revenus', '500 000 FCFA'),
//               ],
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 _buildStatCard('Marchands actifs', '10'),
//                 SizedBox(width: 16),
//                 _buildStatCard('Produits disponibles', '200'),
//               ],
//             ),
//             SizedBox(height: 24),
//             Expanded(
//               child: ListView(
//                 children: [
//                   ListTile(
//                     title: Text('Commande ID123'),
//                     subtitle: Text('En attente - 10 000 FCFA'),
//                     trailing: Icon(Icons.arrow_forward),
//                     onTap: () {
//                       // Naviguer vers les détails de la commande
//                     },
//                   ),
//                   ListTile(
//                     title: Text('Commande ID456'),
//                     subtitle: Text('Validée - 15 000 FCFA'),
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

//   Widget _buildStatCard(String title, String value) {
//     return Expanded(
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 value,
//                 style: TextStyle(fontSize: 24, color: Colors.blue),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }