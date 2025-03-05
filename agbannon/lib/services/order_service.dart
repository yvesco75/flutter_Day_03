// Dans services/order_service.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';

class OrderService {
  final BuildContext context;

  OrderService(this.context);

  Future<List<Order>> fetchOrders() async {
    try {
      // Appel de fetchOrders dans OrderProvider et retourne la liste des commandes
      return await Provider.of<OrderProvider>(context, listen: false)
          .fetchOrders();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erreur lors du chargement des commandes: $error')),
      );
      return []; // Retourne une liste vide en cas d'erreur
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await Provider.of<OrderProvider>(context, listen: false)
          .updateOrderStatus(orderId, status);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erreur lors de la mise à jour du statut: $error')),
      );
    }
  }
}
