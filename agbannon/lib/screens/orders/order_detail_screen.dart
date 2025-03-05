import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart'; // Import Order et OrderStatus
import '../../providers/order_provider.dart';
import '../../widgets/common/loading.dart';
import '../../utils/formatters.dart'; // Import CurrencyFormatter et DateFormatter

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Utilisation de l'alias OrderProv pour accéder à OrderProvider
      await Provider.of<OrderProvider>(context, listen: false)
          .fetchOrderDetails(widget.orderId);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erreur lors du chargement des détails: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateOrderStatus(OrderStatus status) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Utilisation de l'alias OrderProv pour accéder à OrderProvider
      await Provider.of<OrderProvider>(context, listen: false)
          .updateOrderStatus(widget.orderId, status);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Statut de la commande mis à jour')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commande #${widget.orderId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrderDetails,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget()
          : Consumer<OrderProvider>(
              builder: (ctx, orderProvider, child) {
                final order = orderProvider.findOrderById(widget.orderId);

                if (order == null) {
                  return const Center(
                    child: Text('Commande introuvable'),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderStatusCard(order),
                      const SizedBox(height: 16),
                      _buildCustomerInfoCard(order),
                      const SizedBox(height: 16),
                      _buildOrderItemsCard(order),
                      const SizedBox(height: 16),
                      _buildPaymentInfoCard(order),
                      const SizedBox(height: 24),
                      _buildActionButtons(order),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildOrderStatusCard(Order order) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statut de la commande',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getStatusText(order.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Date: ${DateFormatter.formatDate(order.date)}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfoCard(Order order) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations client',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(order.customerName),
              subtitle: Text(order.customerPhone ?? 'Aucun téléphone'),
            ),
            if (order.deliveryAddress != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on),
                title: const Text('Adresse de livraison'),
                subtitle: Text(order.deliveryAddress!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemsCard(Order order) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Articles commandés',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${order.items.length} article(s)',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = order.items[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.productName),
                  subtitle: Text('Quantité: ${item.quantity}'),
                  trailing: Text(
                    CurrencyFormatter.formatPrice(item.price * item.quantity),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sous-total',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(CurrencyFormatter.formatPrice(order.totalAmount)),
                ],
              ),
            ),
            if (order.deliveryFee != null && order.deliveryFee! > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Frais de livraison',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(CurrencyFormatter.formatPrice(order.deliveryFee!)),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.formatPrice(order.totalAmount),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfoCard(Order order) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paiement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Méthode'),
                Text(
                  _getPaymentMethodText(order.paymentMethod),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Statut'),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: order.isPaid ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    order.isPaid ? 'Payée' : 'En attente',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (order.paymentDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Date de paiement'),
                    Text(
                      'Date: ${DateFormatter.formatDate(order.date)}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Order order) {
    return Row(
      children: [
        if (order.status == OrderStatus.pending)
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              label: const Text('Accepter la commande'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () => _updateOrderStatus(OrderStatus.processing),
            ),
          ),
        if (order.status == OrderStatus.pending) const SizedBox(width: 16),
        if (order.status == OrderStatus.pending)
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.cancel),
              label: const Text('Refuser'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () => _showCancelDialog(),
            ),
          ),
        if (order.status == OrderStatus.processing)
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.local_shipping),
              label: const Text('Marquer comme livrée'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () => _updateOrderStatus(OrderStatus.delivered),
            ),
          ),
        if (!order.isPaid)
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.payment),
              label: const Text('Marquer comme payée'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              onPressed: _markAsPaid,
            ),
          ),
      ],
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Annuler la commande'),
        content: const Text('Êtes-vous sûr de vouloir annuler cette commande?'),
        actions: [
          TextButton(
            child: const Text('Non'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Oui'),
            onPressed: () {
              Navigator.of(ctx).pop();
              _updateOrderStatus(OrderStatus.cancelled);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _markAsPaid() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate == null) return; // L'utilisateur a annulé la sélection

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<OrderProvider>(context, listen: false)
          .markOrderAsPaid(widget.orderId, selectedDate);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Commande marquée comme payée')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'En attente';
      case OrderStatus.processing:
        return 'En cours de traitement';
      case OrderStatus.delivered:
        return 'Livrée';
      case OrderStatus.cancelled:
        return 'Annulée';
      default:
        return 'Inconnu';
    }
  }

  String _getPaymentMethodText(PaymentMethod? method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Espèces';
      case PaymentMethod.mobileMoney:
        return 'Mobile Money';
      case PaymentMethod.card:
        return 'Carte bancaire';
      case PaymentMethod.bankTransfer:
        return 'Virement bancaire';
      default:
        return 'Non spécifiée';
    }
  }
}
