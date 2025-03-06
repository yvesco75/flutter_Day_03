import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/stats.dart';
import '../../utils/formatters.dart'; // Ensure this exists
import '../../widgets/stats/sales_chart.dart'; // Ensure this exists

class StatsScreen extends StatefulWidget {
  static const routeName = '/stats';

  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SalesPeriod _selectedPeriod = SalesPeriod.week;
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isLoading = true;
  String? _errorMessage;
  SalesStats _stats =
      SalesStats.empty(); // Initialize with empty SalesStats object

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _setupDateRange();
    _loadStats();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _setupDateRange() {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case SalesPeriod.day:
        _startDate = DateTime(now.year, now.month, now.day);
        _endDate = now;
        break;
      case SalesPeriod.week:
        _startDate = now.subtract(Duration(days: now.weekday - 1));
        _startDate =
            DateTime(_startDate.year, _startDate.month, _startDate.day);
        _endDate = now;
        break;
      case SalesPeriod.month:
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = now;
        break;
      case SalesPeriod.year:
        _startDate = DateTime(now.year, 1, 1);
        _endDate = now;
        break;
      case SalesPeriod.custom:
        // In this case, keep the existing dates.
        break;
    }
  }

  Future<void> _loadStats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // Fetch sales data from Firestore
      final salesData = await _fetchSalesData(_startDate, _endDate);

      // Calculate statistics from the sales data
      final stats = _calculateStats(salesData);

      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchSalesData(
      DateTime start, DateTime end) async {
    final firestore = FirebaseFirestore.instance;
    final startTimestamp = Timestamp.fromDate(start);
    final endTimestamp = Timestamp.fromDate(end.add(const Duration(days: 1)));

    final ordersSnapshot = await firestore
        .collection('orders')
        .where('createdAt', isGreaterThanOrEqualTo: startTimestamp)
        .where('createdAt', isLessThan: endTimestamp)
        .get();

    final List<Map<String, dynamic>> orders = [];
    for (var doc in ordersSnapshot.docs) {
      final data = doc.data();
      data['id'] = doc.id;
      orders.add(data);
    }

    return orders;
  }

  SalesStats _calculateStats(List<Map<String, dynamic>> salesData) {
    // Initialize variables for calculations
    double totalRevenue = 0;
    double totalCost = 0; // Addition of totalCost
    int totalOrders = salesData.length;
    Set<String> uniqueCustomers = {};
    Map<String, int> ordersByStatus = {};
    Map<String, double> paymentMethods = {}; // Addition of paymentMethods
    Map<int, double> salesByHour = {}; // Addition of salesByHour
    Map<String, double> salesByCategory = {}; // Addition of salesByCategory
    Map<String, ProductStat> productsMap = {};
    List<LowStockProduct> lowStockProducts = []; // Addition of lowStockProducts
    List<double> weeklySales = []; // Addition of weeklySales

    // Maps for the evolution of sales according to the period
    final Map<String, double> salesByPeriod = {};

    // Browse commands to calculate statistics
    for (var order in salesData) {
      // Verify if the necessary fields exist
      if (order['total'] != null) {
        totalRevenue += (order['total'] as num).toDouble();
      }
      if (order['cost'] != null) {
        totalCost += (order['cost'] as num).toDouble(); // Addition of totalCost
      }

      if (order['customerId'] != null) {
        uniqueCustomers.add(order['customerId'].toString());
      }

      if (order['status'] != null) {
        final status = order['status'].toString();
        ordersByStatus[status] = (ordersByStatus[status] ?? 0) + 1;
      }

      // Calculate the period date for the chart
      if (order['createdAt'] != null) {
        final createdAt = (order['createdAt'] as Timestamp).toDate();
        String periodKey;

        switch (_selectedPeriod) {
          case SalesPeriod.day:
            periodKey = DateFormat('HH:00').format(createdAt);
            break;
          case SalesPeriod.week:
            periodKey = DateFormat('EEE').format(createdAt);
            break;
          case SalesPeriod.month:
            periodKey = DateFormat('dd').format(createdAt);
            break;
          case SalesPeriod.year:
            periodKey = DateFormat('MMM').format(createdAt);
            break;
          case SalesPeriod.custom:
            // For a custom period, the days are used
            periodKey = DateFormat('dd/MM').format(createdAt);
            break;
        }

        salesByPeriod[periodKey] = (salesByPeriod[periodKey] ?? 0) +
            (order['total'] != null ? (order['total'] as num).toDouble() : 0);
      }

      // Calculate product statistics
      if (order['items'] != null) {
        final items = order['items'] as List<dynamic>;
        for (var item in items) {
          if (item['productId'] != null &&
              item['name'] != null &&
              item['price'] != null &&
              item['quantity'] != null &&
              item['cost'] != null) {
            // Addition of cost
            final productId = item['productId'].toString();
            final name = item['name'].toString();
            final price = (item['price'] as num).toDouble();
            final quantity = (item['quantity'] as num).toInt();
            final revenue = price * quantity;
            final cost = (item['cost'] as num).toDouble(); // Addition of cost

            if (productsMap.containsKey(productId)) {
              productsMap[productId]!.quantity += quantity;
              productsMap[productId]!.revenue += revenue;
            } else {
              productsMap[productId] = ProductStat(
                id: productId,
                name: name,
                quantity: quantity,
                revenue: revenue,
                cost: cost, // Addition of cost
              );
            }
          }
        }
      }

      // Adding data for paymentMethods, salesByHour, salesByCategory, etc.
      if (order['paymentMethod'] != null) {
        final paymentMethod = order['paymentMethod'].toString();
        paymentMethods[paymentMethod] = (paymentMethods[paymentMethod] ?? 0) +
            (order['total'] as num).toDouble();
      }

      if (order['createdAt'] != null) {
        final hour = (order['createdAt'] as Timestamp).toDate().hour;
        salesByHour[hour] =
            (salesByHour[hour] ?? 0) + (order['total'] as num).toDouble();
      }

      if (order['category'] != null) {
        final category = order['category'].toString();
        salesByCategory[category] = (salesByCategory[category] ?? 0) +
            (order['total'] as num).toDouble();
      }
    }

    // Calculate the average order value
    final averageOrderValue =
        totalOrders > 0 ? totalRevenue / totalOrders : 0.0;

    // Convert the sales data into points for the chart
    final List<ChartPoint> salesChart = [];
    final sortedPeriods = salesByPeriod.keys.toList()..sort();
    for (var period in sortedPeriods) {
      salesChart.add(ChartPoint(
        label: period,
        value: salesByPeriod[period]!,
      ));
    }

    // Sort products by revenue
    final topProducts = productsMap.values.toList()
      ..sort((a, b) => b.revenue.compareTo(a.revenue));
    // Simulate data for productPerformance and lowStockProducts
    final productPerformance = topProducts.take(5).toList(); // Example
    lowStockProducts = productsMap.values
        .where((product) => product.quantity < 10) // Example of threshold
        .map((product) => LowStockProduct(
              id: product.id,
              name: product.name,
              currentStock: product.quantity,
              minStock: 10, // Example of threshold
            ))
        .toList();

    // Simulate data for weeklySales
    weeklySales = List.generate(
        7, (index) => salesByPeriod.values.elementAtOrNull(index) ?? 0.0);

    // Create and return the SalesStats object
    return SalesStats(
      totalRevenue: totalRevenue,
      totalCost: totalCost,
      totalOrders: totalOrders,
      totalCustomers: uniqueCustomers.length,
      averageOrderValue: averageOrderValue,
      revenueGrowth: 5.2, // Simulated
      ordersGrowth: 3.7, // Simulated
      aovGrowth: 1.5, // Simulated
      customersGrowth: 4.8, // Simulated
      salesChart: salesChart,
      ordersByStatus: ordersByStatus,
      paymentMethods: paymentMethods,
      salesByHour: salesByHour,
      salesByCategory: salesByCategory,
      topProducts: topProducts,
      productPerformance: productPerformance,
      lowStockProducts: lowStockProducts,
      startDate: _startDate,
      endDate: _endDate,
      weeklySales: weeklySales,
    );
  }

  Future<void> _selectCustomDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
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
      setState(() {
        _selectedPeriod = SalesPeriod.custom;
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadStats();
    }
  }

  void _changePeriod(SalesPeriod period) {
    setState(() {
      _selectedPeriod = period;
      _setupDateRange();
      _loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Aperçu'),
            Tab(text: 'Ventes'),
            Tab(text: 'Produits'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Erreur: $_errorMessage'))
              : Column(
                  children: [
                    _buildPeriodSelector(),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildOverviewTab(_stats),
                          _buildSalesTab(_stats),
                          _buildProductsTab(_stats),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildPeriodSelector() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _periodButton('Jour', SalesPeriod.day),
              _periodButton('Semaine', SalesPeriod.week),
              _periodButton('Mois', SalesPeriod.month),
              _periodButton('Année', SalesPeriod.year),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _selectCustomDateRange,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _selectedPeriod == SalesPeriod.custom
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.date_range, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Du ${dateFormat.format(_startDate)} au ${dateFormat.format(_endDate)}',
                    style: TextStyle(
                      fontWeight: _selectedPeriod == SalesPeriod.custom
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _periodButton(String text, SalesPeriod period) {
    return GestureDetector(
      onTap: () => _changePeriod(period),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _selectedPeriod == period
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight:
                _selectedPeriod == period ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab(SalesStats stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(stats),
          const SizedBox(height: 24),
          _buildSalesChart(stats),
          const SizedBox(height: 24),
          const Text(
            'Répartition des commandes',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildOrderStatusPieChart(stats),
          const SizedBox(height: 24),
          const Text(
            'Top 5 des produits',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildTopProductsList(stats),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(SalesStats stats) {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildSummaryCard(
            'Chiffre d\'affaires',
            CurrencyFormatter.formatPrice(stats.totalRevenue),
            Icons.attach_money,
            Colors.green,
            stats.revenueGrowth ?? 0.0,
          ),
          _buildSummaryCard(
            'Coût total',
            CurrencyFormatter.formatPrice(stats.totalCost),
            Icons.money_off,
            Colors.redAccent,
            stats.revenueGrowth ?? 0.0,
          ),
          _buildSummaryCard(
            'Nombre de commandes',
            stats.totalOrders.toString(),
            Icons.shopping_cart,
            Colors.blue,
            stats.ordersGrowth ?? 0.0,
          ),
          _buildSummaryCard(
            'Nombre de clients',
            stats.totalCustomers.toString(),
            Icons.people,
            Colors.orange,
            stats.customersGrowth ?? 0.0,
          ),
          _buildSummaryCard(
            'Panier moyen',
            CurrencyFormatter.formatPrice(stats.averageOrderValue),
            Icons.shopping_basket,
            Colors.purple,
            stats.aovGrowth ?? 0.0,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color, double growth) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(
                growth > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                color: growth > 0 ? Colors.green : Colors.red,
              ),
              Text(
                '${growth.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: growth > 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalesChart(SalesStats stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Évolution des ventes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: const SalesChart(), // Supprimez le paramètre 'data'
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusPieChart(SalesStats stats) {
    final ordersByStatus = stats.ordersByStatus;
    final totalOrders = stats.totalOrders;

    List<PieChartSectionData> sections = ordersByStatus.entries.map((entry) {
      final status = entry.key;
      final count = entry.value;
      final percentage = (count / totalOrders) * 100;
      Color color;

      switch (status) {
        case 'pending':
          color = Colors.orange;
          break;
        case 'processing':
          color = Colors.blue;
          break;
        case 'completed':
          color = Colors.green;
          break;
        case 'cancelled':
          color = Colors.red;
          break;
        default:
          color = Colors.grey;
      }

      return PieChartSectionData(
        color: color,
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ordersByStatus.entries.map((entry) {
              final status = entry.key;
              final count = entry.value;
              Color color;

              switch (status) {
                case 'pending':
                  color = Colors.orange;
                  break;
                case 'processing':
                  color = Colors.blue;
                  break;
                case 'completed':
                  color = Colors.green;
                  break;
                case 'cancelled':
                  color = Colors.red;
                  break;
                default:
                  color = Colors.grey;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: color, size: 16),
                    const SizedBox(width: 8),
                    Text('$status: $count'),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProductsList(SalesStats stats) {
    final topProducts = stats.topProducts;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: topProducts.map((product) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(product.name),
                Text(
                    '${product.quantity} unités - ${CurrencyFormatter.formatPrice(product.revenue)}'),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSalesTab(SalesStats stats) {
    return const Center(
      child: Text('Sales Tab Content'),
    );
  }

  Widget _buildProductsTab(SalesStats stats) {
    return const Center(
      child: Text('Products Tab Content'),
    );
  }
}
