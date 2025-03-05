import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/stats_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/stats.dart';
import '../../widgets/common/loading.dart';
import '../../utils/formatters.dart';

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
        // Début de la semaine (lundi)
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
        // Dans ce cas, on garde les dates existantes
        break;
    }
  }

  Future<void> _loadStats() async {
    // Load the stats data
    await Provider.of<StatsProvider>(context, listen: false)
        .fetchStats(_startDate, _endDate);
  }

  void _changePeriod(SalesPeriod period) {
    setState(() {
      _selectedPeriod = period;
    });
    _setupDateRange();
    _loadStats();
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
      body: Consumer<StatsProvider>(
        builder: (context, statsProvider, _) {
          if (statsProvider.isLoading) {
            return const LoadingWidget();
          } else if (statsProvider.errorMessage != null) {
            return Center(
              child: Text('Error: ${statsProvider.errorMessage}'),
            );
          } else if (statsProvider.stats == null) {
            return const Center(
              child: Text('No data available'),
            );
          } else {
            return Column(
              children: [
                _buildPeriodSelector(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(statsProvider.stats!),
                      _buildSalesTab(),
                      _buildProductsTab(),
                    ],
                  ),
                ),
              ],
            );
          }
        },
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildOrderStatusPieChart(stats),
          const SizedBox(height: 24),
          const Text(
            'Top 5 des produits',
            style: TextStyle(
              fontSize: 18,
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
            stats.revenueGrowth,
          ),
          _buildSummaryCard(
            'Commandes',
            stats.totalOrders.toString(),
            Icons.shopping_bag,
            Colors.blue,
            stats.ordersGrowth,
          ),
          _buildSummaryCard(
            'Panier moyen',
            CurrencyFormatter.formatPrice(stats.averageOrderValue),
            Icons.shopping_cart,
            Colors.orange,
            stats.aovGrowth,
          ),
          _buildSummaryCard(
            'Clients',
            stats.totalCustomers.toString(),
            Icons.people,
            Colors.purple,
            stats.customersGrowth,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
    double? growth,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: SizedBox(
        width: 170,
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: color.withOpacity(0.2),
                      child: Icon(
                        icon,
                        color: color,
                        size: 20,
                      ),
                    ),
                    if (growth != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: growth >= 0
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              growth >= 0
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: growth >= 0 ? Colors.green : Colors.red,
                              size: 12,
                            ),
                            Text(
                              '${growth.abs().toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: growth >= 0 ? Colors.green : Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSalesChart(SalesStats stats) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: (stats.salesChart.isEmpty)
                  ? const Center(
                      child: Text('Aucune donnée de vente disponible'),
                    )
                  : LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value >= 1000
                                      ? '${(value / 1000).toStringAsFixed(0)}k'
                                      : value.toStringAsFixed(0),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 &&
                                    index < stats.salesChart.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      stats.salesChart[index].label,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                              reservedSize: 30,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: stats.salesChart
                                .asMap()
                                .entries
                                .map((entry) => FlSpot(
                                    entry.key.toDouble(), entry.value.value))
                                .toList(),
                            isCurved: true,
                            color: Theme.of(context).primaryColor,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusPieChart(SalesStats stats) {
    // Implement the pie chart
    return const Text('Pie chart content');
  }

  Widget _buildTopProductsList(SalesStats stats) {
    // Implement the product list
    return const Text('Top products content');
  }

  Widget _buildSalesTab() {
    return const Center(
      child: Text('Sales Tab Content'),
    );
  }

  Widget _buildProductsTab() {
    return const Center(
      child: Text('Products Tab Content'),
    );
  }
}
