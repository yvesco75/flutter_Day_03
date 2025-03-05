import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../widgets/order/order_card.dart';
import 'order_detail_screen.dart';

class OrderListScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erreur lors du chargement des commandes: $error')),
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
        title: const Text('Commandes'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'En cours'),
            Tab(text: 'Livrées'),
            Tab(text: 'Annulées'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadOrders,
              child: Consumer<OrderProvider>(
                builder: (ctx, orderProvider, child) {
                  final pendingOrders = orderProvider.getPendingOrders();
                  final deliveredOrders = orderProvider.getDeliveredOrders();
                  final cancelledOrders = orderProvider.getCancelledOrders();

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOrderList(pendingOrders),
                      _buildOrderList(deliveredOrders),
                      _buildOrderList(cancelledOrders),
                    ],
                  );
                },
              ),
            ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Text('Aucune commande disponible'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (ctx, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OrderDetailScreen(orderId: order.id),
              ),
            );
          },
        );
      },
    );
  }
}
