// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Pour formater les dates
// import 'package:cloud_firestore/cloud_firestore.dart'; // Pour Firestore
// import 'package:firebase_core/firebase_core.dart'; // Pour initialiser Firebase

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // Initialiser Firebase
//   runApp(MaterialApp(
//     title: 'Market Manager',
//     initialRoute: '/orders',
//     routes: {
//       '/orders': (context) => OrdersScreen(),
//       '/order-detail': (context) => OrderDetailScreen(order: ModalRoute.of(context)!.settings.arguments as Order),
//     },
//   ));
// }

// class OrdersScreen extends StatelessWidget {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Méthode pour récupérer les commandes destinées aux marchands
//   Stream<List<Order>> _getMerchantOrders() {
//     return _firestore
//         .collection('orders')
//         .where('merchantId', isNotEqualTo: '') // Commandes avec un marchand
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) => Order.fromMap(doc.data())).toList());
//   }

//   // Méthode pour récupérer les commandes gérées par le Market Manager
//   Stream<List<Order>> _getMarketManagerOrders() {
//     return _firestore
//         .collection('orders')
//         .where('marketManagerId', isNotEqualTo: '') // Commandes avec un Market Manager
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) => Order.fromMap(doc.data())).toList());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2, // Deux onglets : Marchands et Market Manager
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Commandes'),
//           bottom: TabBar(
//             tabs: [
//               Tab(text: 'Marchands'),
//               Tab(text: 'Market Manager'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // Onglet des commandes destinées aux marchands
//             StreamBuilder<List<Order>>(
//               stream: _getMerchantOrders(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Erreur: ${snapshot.error}'));
//                 }
//                 final orders = snapshot.data ?? [];
//                 return _buildOrderList(orders);
//               },
//             ),

//             // Onglet des commandes gérées par le Market Manager
//             StreamBuilder<List<Order>>(
//               stream: _getMarketManagerOrders(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Erreur: ${snapshot.error}'));
//                 }
//                 final orders = snapshot.data ?? [];
//                 return _buildOrderList(orders);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Méthode pour construire une liste de commandes
//   Widget _buildOrderList(List<Order> orders) {
//     if (orders.isEmpty) {
//       return Center(
//         child: Text(
//           'Aucune commande trouvée',
//           style: TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: orders.length,
//       itemBuilder: (context, index) {
//         final order = orders[index];
//         return Card(
//           margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           elevation: 2,
//           child: InkWell(
//             onTap: () => Navigator.pushNamed(
//               context,
//               '/order-detail',
//               arguments: order,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       _buildStatusIcon(order.status),
//                       SizedBox(width: 8),
//                       Text(
//                         'Commande ${order.id}',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Text('Date: ${DateFormat('dd/MM/yyyy').format(order.createdAt)}'),
//                   SizedBox(height: 8),
//                   Text('Total: ${_calculateTotal(order.products)} €'),
//                   SizedBox(height: 8),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: Icon(Icons.arrow_forward_ios, size: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Méthode pour calculer le total d'une commande
//   double _calculateTotal(List<Product> products) {
//     return products.fold(0, (sum, product) => sum + (product.price * product.quantity));
//   }

//   // Méthode pour afficher une icône en fonction du statut
//   Widget _buildStatusIcon(String status) {
//     switch (status) {
//       case 'Livré':
//         return Icon(Icons.check_circle, color: Colors.green);
//       case 'En attente':
//         return Icon(Icons.access_time, color: Colors.orange);
//       default:
//         return Icon(Icons.error, color: Colors.red);
//     }
//   }
// }

// class OrderDetailScreen extends StatelessWidget {
//   final Order order;

//   OrderDetailScreen({required this.order});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Détails de la commande')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Commande ${order.id}',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Text('Statut: ${order.status}'),
//             SizedBox(height: 8),
//             Text('Date: ${DateFormat('dd/MM/yyyy').format(order.createdAt)}'),
//             SizedBox(height: 8),
//             Text('Total: ${_calculateTotal(order.products)} €'),
//             SizedBox(height: 16),
//             Text(
//               'Produits :',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             ...order.products.map((product) {
//               return ListTile(
//                 title: Text(product.name),
//                 subtitle: Text('Quantité: ${product.quantity} - Prix: ${product.price} €'),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   // Méthode pour calculer le total d'une commande
//   double _calculateTotal(List<Product> products) {
//     return products.fold(0, (sum, product) => sum + (product.price * product.quantity));
//   }
// }

// // Modèles de données
// class Order {
//   final String id;
//   final String merchantId;
//   final String marketManagerId;
//   final List<Product> products;
//   final String status;
//   final DateTime createdAt;

//   Order({
//     required this.id,
//     this.merchantId = '',
//     this.marketManagerId = '',
//     required this.products,
//     required this.status,
//     required this.createdAt,
//   });

//   // Convertir un document Firestore en objet Order
//   factory Order.fromMap(Map<String, dynamic> data) {
//     return Order(
//       id: data['id'],
//       merchantId: data['merchantId'] ?? '',
//       marketManagerId: data['marketManagerId'] ?? '',
//       products: (data['products'] as List).map((product) => Product.fromMap(product)).toList(),
//       status: data['status'],
//       createdAt: (data['createdAt'] as Timestamp).toDate(),
//     );
//   }
// }

// class Product {
//   final String id;
//   final String name;
//   final double price;
//   final int quantity;

//   Product({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.quantity,
//   });

//   // Convertir un document Firestore en objet Product
//   factory Product.fromMap(Map<String, dynamic> data) {
//     return Product(
//       id: data['id'],
//       name: data['name'],
//       price: data['price'],
//       quantity: data['quantity'],
//     );
//   }
// }