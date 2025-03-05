import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import pour DateFormat
import '../../models/order.dart';
import '../../utils/formatters.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap; // Ajout du paramètre onTap

  const OrderCard({
    Key? key,
    required this.order,
    required this.onTap, // Ajout du paramètre onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap, // Utilisation du paramètre onTap
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Commande #${order.id}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Statut: ${_getOrderStatusText(order.status)}',
                style: TextStyle(
                  color: _getOrderStatusColor(order.status),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Montant: ${CurrencyFormatter.formatPrice(order.totalAmount)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Date: ${DateFormat('dd/MM/yyyy').format(order.date)}',
                style: const TextStyle(
                  color:
                      Colors.grey, // Correction de "grey" (au lieu de "grey")
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getOrderStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'En attente';
      case OrderStatus.processing:
        return 'En cours';
      case OrderStatus.delivered: // Utilisez une valeur existante
        return 'Terminée';
      case OrderStatus.cancelled:
        return 'Annulée';
      default:
        return 'Inconnu';
    }
  }

  Color _getOrderStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.delivered: // Utilisez une valeur existante
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
