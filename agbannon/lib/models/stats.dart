// File: lib/models/stats.dart

enum SalesPeriod {
  day,
  week,
  month,
  year,
  custom,
}

class ChartPoint {
  final String label;
  final double value;

  ChartPoint({required this.label, required this.value});
}

class ProductStat {
  final String id;
  final String name;
  int quantity; // Changed from final to mutable
  double revenue;
  final double cost;

  ProductStat({
    required this.id,
    required this.name,
    required this.quantity,
    required this.revenue,
    required this.cost,
  });
}

class LowStockProduct {
  final String id;
  final String name;
  final int currentStock;
  final int minStock;

  LowStockProduct({
    required this.id,
    required this.name,
    required this.currentStock,
    required this.minStock,
  });
}

class SalesStats {
  // Données de base
  final double totalRevenue;
  final double totalCost;
  final int totalOrders;
  final int totalCustomers;
  final double averageOrderValue;

  // Taux de croissance (pourcentage)
  final double? revenueGrowth;
  final double? ordersGrowth;
  final double? aovGrowth;
  final double? customersGrowth;

  // Données des graphiques
  final List<ChartPoint> salesChart;
  final Map<String, int> ordersByStatus;
  final Map<String, double> paymentMethods;
  final Map<int, double> salesByHour;
  final Map<String, double> salesByCategory;

  // Produits
  final List<ProductStat> topProducts;
  final List<ProductStat> productPerformance;
  final List<LowStockProduct> lowStockProducts;

  // Ajout des paramètres startDate et endDate
  final DateTime startDate;
  final DateTime endDate;

  // Weekly Sales Data
  final List<double> weeklySales;

  SalesStats({
    required this.totalRevenue,
    required this.totalCost,
    required this.totalOrders,
    required this.totalCustomers,
    required this.averageOrderValue,
    this.revenueGrowth,
    this.ordersGrowth,
    this.aovGrowth,
    this.customersGrowth,
    required this.salesChart,
    required this.ordersByStatus,
    required this.paymentMethods,
    required this.salesByHour,
    required this.salesByCategory,
    required this.topProducts,
    required this.productPerformance,
    required this.lowStockProducts,
    required this.startDate,
    required this.endDate,
    required this.weeklySales, // Added weeklySales
  });

  // Factory pour créer un objet vide ou par défaut
  factory SalesStats.empty() {
    return SalesStats(
      totalRevenue: 0,
      totalCost: 0,
      totalOrders: 0,
      totalCustomers: 0,
      averageOrderValue: 0,
      salesChart: [],
      ordersByStatus: {},
      paymentMethods: {},
      salesByHour: {},
      salesByCategory: {},
      topProducts: [],
      productPerformance: [],
      lowStockProducts: [],
      startDate: DateTime.now(), // Valeur par défaut
      endDate: DateTime.now(), // Valeur par défaut
      weeklySales: [], // Initialize weeklySales
    );
  }

  // Factory pour créer à partir des données JSON
  factory SalesStats.fromJson(Map<String, dynamic> json) {
    // Traitement des points du graphique de ventes
    List<ChartPoint> chartPoints = [];
    if (json['salesChart'] != null) {
      chartPoints = (json['salesChart'] as List)
          .map((dynamic point) => ChartPoint(
                // Added dynamic
                label: point['label'] as String, // Added as String
                value: (point['value'] as num).toDouble(), // Added as num
              ))
          .toList();
    }

    // Traitement des produits les plus vendus
    List<ProductStat> topProductsList = [];
    if (json['topProducts'] != null) {
      topProductsList = (json['topProducts'] as List)
          .map((dynamic product) => ProductStat(
                // Added dynamic
                id: product['id'] as String, // Added as String
                name: product['name'] as String, // Added as String
                quantity: product['quantity'] as int, // Added as int
                revenue: (product['revenue'] as num).toDouble(), // Added as num
                cost: (product['cost'] as num).toDouble(), // Added as num
              ))
          .toList();
    }

    // Traitement des performances des produits
    List<ProductStat> productPerformanceList = [];
    if (json['productPerformance'] != null) {
      productPerformanceList = (json['productPerformance'] as List)
          .map((dynamic product) => ProductStat(
                // Added dynamic
                id: product['id'] as String, // Added as String
                name: product['name'] as String, // Added as String
                quantity: product['quantity'] as int, // Added as int
                revenue: (product['revenue'] as num).toDouble(), // Added as num
                cost: (product['cost'] as num).toDouble(), // Added as num
              ))
          .toList();
    }

    // Traitement des produits à faible stock
    List<LowStockProduct> lowStockList = [];
    if (json['lowStockProducts'] != null) {
      lowStockList = (json['lowStockProducts'] as List)
          .map((dynamic product) => LowStockProduct(
                // Added dynamic
                id: product['id'] as String, // Added as String
                name: product['name'] as String, // Added as String
                currentStock: product['currentStock'] as int, // Added as int
                minStock: product['minStock'] as int, // Added as int
              ))
          .toList();
    }

    // Conversion pour les différentes cartes (maps)
    Map<String, int> ordersByStatus = {};
    if (json['ordersByStatus'] != null) {
      json['ordersByStatus'].forEach((key, value) {
        ordersByStatus[key as String] = value as int; // Added type casting
      });
    }

    Map<String, double> paymentMethods = {};
    if (json['paymentMethods'] != null) {
      json['paymentMethods'].forEach((key, value) {
        paymentMethods[key as String] =
            (value as num).toDouble(); // Added type casting
      });
    }

    Map<int, double> salesByHour = {};
    if (json['salesByHour'] != null) {
      json['salesByHour'].forEach((key, value) {
        salesByHour[int.parse(key as String)] =
            (value as num).toDouble(); // Added type casting
      });
    }

    Map<String, double> salesByCategory = {};
    if (json['salesByCategory'] != null) {
      json['salesByCategory'].forEach((key, value) {
        salesByCategory[key as String] =
            (value as num).toDouble(); // Added type casting
      });
    }

    // Handle weeklySales conversion
    List<double> weeklySalesList = [];
    if (json['weeklySales'] != null) {
      weeklySalesList = (json['weeklySales'] as List<dynamic>)
          .map<double>(
              (dynamic item) => (item as num).toDouble()) // Added dynamic + num
          .toList();
    }

    return SalesStats(
      totalRevenue:
          (json['totalRevenue'] as num?)?.toDouble() ?? 0, // Added num?
      totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0, // Added num?
      totalOrders: json['totalOrders'] as int? ?? 0, // Added int?
      totalCustomers: json['totalCustomers'] as int? ?? 0, // Added int?
      averageOrderValue:
          (json['averageOrderValue'] as num?)?.toDouble() ?? 0, // Added num?
      revenueGrowth: (json['revenueGrowth'] as num?)?.toDouble(), // Added num?
      ordersGrowth: (json['ordersGrowth'] as num?)?.toDouble(), // Added num?
      aovGrowth: (json['aovGrowth'] as num?)?.toDouble(), // Added num?
      customersGrowth:
          (json['customersGrowth'] as num?)?.toDouble(), // Added num?
      salesChart: chartPoints,
      ordersByStatus: ordersByStatus,
      paymentMethods: paymentMethods,
      salesByHour: salesByHour,
      salesByCategory: salesByCategory,
      topProducts: topProductsList,
      productPerformance: productPerformanceList,
      lowStockProducts: lowStockList,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String) //Added as String
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String) //Added as String
          : DateTime.now(),
      weeklySales: weeklySalesList, // Assign weeklySalesList
    );
  }

  // Méthode pour convertir en JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; // Short form

    data['totalRevenue'] = totalRevenue;
    data['totalCost'] = totalCost;
    data['totalOrders'] = totalOrders;
    data['totalCustomers'] = totalCustomers;
    data['averageOrderValue'] = averageOrderValue;

    if (revenueGrowth != null) data['revenueGrowth'] = revenueGrowth;
    if (ordersGrowth != null) data['ordersGrowth'] = ordersGrowth;
    if (aovGrowth != null) data['aovGrowth'] = aovGrowth;
    if (customersGrowth != null) data['customersGrowth'] = customersGrowth;

    data['salesChart'] = salesChart
        .map((point) => {
              'label': point.label,
              'value': point.value,
            })
        .toList();

    data['ordersByStatus'] = ordersByStatus;
    data['paymentMethods'] = paymentMethods;

    // Conversion du Map<int, double> en Map<String, dynamic>
    data['salesByHour'] =
        salesByHour.map((key, value) => MapEntry(key.toString(), value));

    data['salesByCategory'] = salesByCategory;

    data['topProducts'] = topProducts
        .map((product) => {
              'id': product.id,
              'name': product.name,
              'quantity': product.quantity,
              'revenue': product.revenue,
              'cost': product.cost,
            })
        .toList();

    data['productPerformance'] = productPerformance
        .map((product) => {
              'id': product.id,
              'name': product.name,
              'quantity': product.quantity,
              'revenue': product.revenue,
              'cost': product.cost,
            })
        .toList();

    data['lowStockProducts'] = lowStockProducts
        .map((product) => {
              'id': product.id,
              'name': product.name,
              'currentStock': product.currentStock,
              'minStock': product.minStock,
            })
        .toList();

    data['startDate'] = startDate.toIso8601String();
    data['endDate'] = endDate.toIso8601String();
    data['weeklySales'] = weeklySales;

    return data;
  }
}
