// models/payment.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PaymentMethod {
  cash,
  mobileMoney,
  bankTransfer,
  card,
}

class Payment {
  final String? orderId; // Ajout de l'orderId, qui est optionnel
  final double amount;
  final DateTime date;
  final PaymentMethod method;

  Payment({
    this.orderId, // Ajout dans le constructeur
    required this.amount,
    required this.date,
    required this.method,
  });

  // Méthode pour formatter la date
  String formattedDate() {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Méthode pour obtenir le texte du mode de paiement
  String paymentMethodText() {
    switch (method) {
      case PaymentMethod.cash:
        return 'Espèces';
      case PaymentMethod.mobileMoney:
        return 'Mobile Money';
      case PaymentMethod.bankTransfer:
        return 'Virement bancaire';
      case PaymentMethod.card:
        return 'Carte bancaire';
      default:
        return 'Autre';
    }
  }

  // Méthode pour obtenir l'icône du mode de paiement
  IconData paymentMethodIcon() {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.mobileMoney:
        return Icons.phone_android;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance;
      case PaymentMethod.card:
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  // Méthode pour obtenir la couleur du mode de paiement
  Color paymentMethodColor() {
    switch (method) {
      case PaymentMethod.cash:
        return Colors.green;
      case PaymentMethod.mobileMoney:
        return Colors.orange;
      case PaymentMethod.bankTransfer:
        return Colors.blue;
      case PaymentMethod.card:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Constructeur pour créer un objet Payment à partir d'un Map
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      orderId: map['orderId'],
      amount: map['amount'],
      date: map['date'].toDate(),
      method: PaymentMethod.values.byName(map['method']),
    );
  }
}
