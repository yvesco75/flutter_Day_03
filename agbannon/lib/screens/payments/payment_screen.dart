import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/payment.dart';
import '../../providers/order_provider.dart';
import '../../utils/formatters.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payments';

  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
  List<Payment> _payments = [];

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final payments = await Provider.of<OrderProvider>(context, listen: false)
          .fetchPayments(_dateRange.start, _dateRange.end);
      setState(() {
        _payments = payments;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erreur lors du chargement des paiements: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
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

    if (picked != null && picked != _dateRange) {
      setState(() {
        _dateRange = picked;
      });
      _loadPayments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = _payments.fold<double>(
        0.0, (sum, payment) => sum + (payment.amount ?? 0.0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPayments,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateFilter(),
          _buildSummaryCard(totalAmount),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _payments.isEmpty
                    ? const Center(
                        child: Text('Aucun paiement pour cette période'),
                      )
                    : _buildPaymentsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.date_range),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Du ${dateFormat.format(_dateRange.start)} au ${dateFormat.format(_dateRange.end)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: _selectDateRange,
            child: const Text('Changer'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(double totalAmount) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Résumé des paiements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(
                  'Total',
                  CurrencyFormatter.formatPrice(totalAmount),
                  Colors.blue,
                  Icons.attach_money,
                ),
                _buildSummaryItem(
                  'Nombre',
                  _payments.length.toString(),
                  Colors.green,
                  Icons.receipt_long,
                ),
                _buildSummaryItem(
                  'Moyenne',
                  _payments.isEmpty
                      ? '0 F'
                      : CurrencyFormatter.formatPrice(
                          totalAmount / _payments.length),
                  Colors.orange,
                  Icons.equalizer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
      String title, String value, Color color, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          radius: 24,
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentsList() {
    // Regrouper les paiements par jour
    final Map<String, List<Payment>> groupedPayments = {};
    final dateFormat = DateFormat('dd/MM/yyyy');

    for (var payment in _payments) {
      final dateKey = dateFormat.format(payment.date);
      if (!groupedPayments.containsKey(dateKey)) {
        groupedPayments[dateKey] = [];
      }
      groupedPayments[dateKey]!.add(payment);
    }

    // Trier les clés par date (plus récent en premier)
    final sortedDates = groupedPayments.keys.toList()
      ..sort((a, b) {
        final dateA = dateFormat.parse(a);
        final dateB = dateFormat.parse(b);
        return dateB.compareTo(dateA);
      });

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDates[index];
        final paymentsForDate = groupedPayments[dateKey]!;
        final totalForDay = paymentsForDate.fold<double>(
            0.0, (sum, payment) => sum + (payment.amount ?? 0.0));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateKey,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.formatPrice(totalForDay),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.zero,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paymentsForDate.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, idx) {
                  final payment = paymentsForDate[idx];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getPaymentMethodColor(payment.method)
                          .withOpacity(0.2),
                      child: Icon(
                        _getPaymentMethodIcon(payment.method),
                        color: _getPaymentMethodColor(payment.method),
                      ),
                    ),
                    title: Text(
                        'Commande #${payment.orderId ?? 'N/A'}'), // Provide a default value if orderId is null
                    subtitle: Text(_getPaymentMethodText(payment.method)),
                    trailing: Text(
                      CurrencyFormatter.formatPrice(payment.amount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      // Naviguer vers les détails de la commande associée
                      Navigator.pushNamed(
                        context,
                        '/orders/details',
                        arguments: payment.orderId,
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  IconData _getPaymentMethodIcon(PaymentMethod method) {
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

  Color _getPaymentMethodColor(PaymentMethod method) {
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

  String _getPaymentMethodText(PaymentMethod method) {
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
