// models/order.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  pending,
  processing,
  delivered,
  cancelled,
}

enum PaymentMethod {
  cash, // Espèces
  mobileMoney, // Mobile Money
  card, // Carte bancaire
  bankTransfer, // Virement bancaire
}

class Order {
  final String id;
  final String customerName;
  final String? customerPhone;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime date;

  // Propriétés modifiables
  OrderStatus status;
  bool isPaid;
  DateTime? paymentDate;
  final double? deliveryFee;
  final String? deliveryAddress;
  PaymentMethod? paymentMethod;

  Order({
    required this.id,
    required this.customerName,
    this.customerPhone,
    required this.items,
    required this.totalAmount,
    required this.date,
    this.status = OrderStatus.pending,
    this.isPaid = false,
    this.paymentDate,
    this.deliveryFee,
    this.deliveryAddress,
    this.paymentMethod,
  });

  // Conversion de Map vers Order (Firestore)
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] ?? '',
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'],
      items: List<OrderItem>.from(
        (map['items'] as List<dynamic>).map<OrderItem>(
            (item) => OrderItem.fromMap(item as Map<String, dynamic>)),
      ),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      date: (map['date'] as Timestamp).toDate(),
      status: map['status'] != null
          ? OrderStatus.values.firstWhere(
              (e) => e.toString() == map['status'],
              orElse: () => OrderStatus.pending,
            )
          : OrderStatus.pending,
      isPaid: map['isPaid'] ?? false,
      paymentDate: map['paymentDate'] != null
          ? (map['paymentDate'] as Timestamp).toDate()
          : null,
      deliveryFee: (map['deliveryFee'] ?? 0).toDouble(),
      deliveryAddress: map['deliveryAddress'],
      paymentMethod: map['paymentMethod'] != null
          ? PaymentMethod.values.firstWhere(
              (e) => e.toString() == map['paymentMethod'],
              orElse: () => PaymentMethod.cash,
            )
          : null,
    );
  }

  // Conversion d'un objet Order vers Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'date': Timestamp.fromDate(date),
      'status': status.toString(),
      'isPaid': isPaid,
      'paymentDate':
          paymentDate != null ? Timestamp.fromDate(paymentDate!) : null,
      'deliveryFee': deliveryFee,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod?.toString(),
    };
  }

  // Ajout d'une méthode pour copier un objet Order
  Order copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    List<OrderItem>? items,
    double? totalAmount,
    DateTime? date,
    OrderStatus? status,
    bool? isPaid,
    DateTime? paymentDate,
    double? deliveryFee,
    String? deliveryAddress,
    PaymentMethod? paymentMethod,
  }) {
    return Order(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      date: date ?? this.date,
      status: status ?? this.status,
      isPaid: isPaid ?? this.isPaid,
      paymentDate: paymentDate ?? this.paymentDate,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  // Conversion de Map vers OrderItem (Firestore)
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: (map['quantity'] ?? 0),
      price: (map['price'] ?? 0).toDouble(),
    );
  }

  // Conversion d'un objet OrderItem vers Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }

  // Ajout d'une méthode pour copier un objet OrderItem
  OrderItem copyWith({
    String? productId,
    String? productName,
    int? quantity,
    double? price,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}
