import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:intl/intl.dart';
import '../models/payment.dart'; // Import Payment et PaymentMethod
import '../providers/order_provider.dart';

class PaymentService {
  final BuildContext context;

  PaymentService(this.context);

  Future<List<Payment>> fetchPayments(
      DateTime startDate, DateTime endDate) async {
    try {
      return await Provider.of<OrderProvider>(context, listen: false)
          .fetchPayments(startDate, endDate);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erreur lors du chargement des paiements: $error')),
      );
      return [];
    }
  }

  Future<void> selectDateRange(
      Function(DateTimeRange) onDateRangeSelected) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateRangeSelected(picked);
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  double calculateTotalAmount(List<Payment> payments) {
    return payments.fold(0.0, (sum, payment) => sum + payment.amount);
  }

  Map<String, List<Payment>> groupPaymentsByDate(List<Payment> payments) {
    final Map<String, List<Payment>> groupedPayments = {};
    final dateFormat = DateFormat('dd/MM/yyyy');

    for (var payment in payments) {
      final dateKey = dateFormat.format(payment.date);
      if (!groupedPayments.containsKey(dateKey)) {
        groupedPayments[dateKey] = [];
      }
      groupedPayments[dateKey]!.add(payment);
    }

    return groupedPayments;
  }

  IconData getPaymentMethodIcon(PaymentMethod method) {
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

  Color getPaymentMethodColor(PaymentMethod method) {
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

  String getPaymentMethodText(PaymentMethod method) {
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
}
