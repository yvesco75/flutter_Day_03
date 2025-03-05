import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as OrderModel;
import '../models/stats.dart'; // Assurez-vous que ce chemin est correct
import '../models/payment.dart'; // Importez votre modèle Payment

class OrderProvider with ChangeNotifier {
  List<OrderModel.Order> _orders = [];
  List<OrderModel.Order> get orders => _orders;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<OrderModel.Order>> fetchOrders(
      {DocumentSnapshot? lastDoc}) async {
    try {
      Query query = _firestore.collection('orders').orderBy('date').limit(10);
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final QuerySnapshot snapshot = await query.get();
      _orders = snapshot.docs
          .map((doc) =>
              OrderModel.Order.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
      return _orders;
    } catch (e) {
      debugPrint("Erreur lors de la récupération des commandes : $e");
      throw Exception('Erreur lors de la récupération des commandes : $e');
    }
  }

  Future<OrderModel.Order> fetchOrderDetails(String orderId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return OrderModel.Order.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('Commande introuvable');
      }
    } catch (e) {
      debugPrint(
          "Erreur lors de la récupération des détails de la commande : $e");
      throw Exception(
          "Erreur lors de la récupération des détails de la commande : $e");
    }
  }

  Future<void> addOrder(OrderModel.Order order, BuildContext context) async {
    try {
      await _firestore.collection('orders').add(order.toMap());
      _orders.add(order);
      notifyListeners();
    } catch (e) {
      _handleError("Erreur lors de l'ajout de la commande", e, context);
    }
  }

  Future<void> updateOrder(String orderId, OrderModel.Order updatedOrder,
      BuildContext context) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update(updatedOrder.toMap());
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = updatedOrder;
        notifyListeners();
      }
    } catch (e) {
      _handleError("Erreur lors de la mise à jour de la commande", e, context);
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderModel.OrderStatus status,
      BuildContext context, // Ajoutez ce paramètre
      {String? reason}) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status.toString(),
        'statusReason': reason, // Ajout de la raison si nécessaire
      });
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index].status = status;
        notifyListeners();
      }
    } catch (e) {
      _handleError("Erreur lors de la mise à jour du statut", e, context);
    }
  }

  Future<void> markOrderAsPaid(String orderId, DateTime paymentDate,
      BuildContext context // Ajoutez ce paramètre
      ) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({'isPaid': true, 'paymentDate': paymentDate});
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index].isPaid = true;
        _orders[index].paymentDate = paymentDate;
        notifyListeners();
      }
    } catch (e) {
      _handleError("Erreur lors du marquage comme payée", e, context);
    }
  }

  OrderModel.Order? findOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null; // Retourne null si la commande n'est pas trouvée
    }
  }

  // Méthode pour récupérer les commandes en attente
  List<OrderModel.Order> getPendingOrders() {
    return _orders
        .where((order) => order.status == OrderModel.OrderStatus.pending)
        .toList();
  }

  // Méthode pour récupérer les commandes livrées
  List<OrderModel.Order> getDeliveredOrders() {
    return _orders
        .where((order) => order.status == OrderModel.OrderStatus.delivered)
        .toList();
  }

  // Méthode pour récupérer les commandes annulées
  List<OrderModel.Order> getCancelledOrders() {
    return _orders
        .where((order) => order.status == OrderModel.OrderStatus.cancelled)
        .toList();
  }

  void _handleError(String message, dynamic error, BuildContext context) {
    debugPrint("$message : $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$message : $error')),
    );
  }

  // Méthode pour récupérer les statistiques de vente
  Future<SalesStats> fetchStats(DateTime startDate, DateTime endDate) async {
    final response = await http.get(
      Uri.parse('https://votre-api.com/stats?start=$startDate&end=$endDate'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return SalesStats.fromJson(data);
    } else {
      throw Exception('Failed to load stats');
    }
  }

  // Méthode pour récupérer les paiements
  Future<List<Payment>> fetchPayments(
      DateTime startDate, DateTime endDate) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('payments')
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();

      return snapshot.docs.map((doc) {
        return Payment.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint("Erreur lors de la récupération des paiements : $e");
      throw Exception('Erreur lors de la récupération des paiements : $e');
    }
  }
}
