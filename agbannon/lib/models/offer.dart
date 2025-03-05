import 'package:flutter/foundation.dart';

class Offer {
  final String? id;
  final String title;
  final String description;
  final double discountPercentage;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final List<String> applicableProductIds;
  final DateTime createdAt;

  Offer({
    this.id,
    required this.title,
    required this.description,
    required this.discountPercentage,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.applicableProductIds = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Offer copyWith({
    String? id,
    String? title,
    String? description,
    double? discountPercentage,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    List<String>? applicableProductIds,
    DateTime? createdAt,
  }) {
    return Offer(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      applicableProductIds: applicableProductIds ?? this.applicableProductIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Offer.fromMap(Map<String, dynamic> map) {
    return Offer(
      id: map['id'] as String?,
      title: (map['title'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      discountPercentage: _parseDouble(map['discountPercentage'], 0.0),
      startDate: _parseDateTime(map['startDate'], DateTime.now()),
      endDate: _parseDateTime(
          map['endDate'], DateTime.now().add(const Duration(days: 30))),
      isActive: map['isActive'] as bool? ?? true,
      applicableProductIds: _parseStringList(map['applicableProductIds']),
      createdAt: _parseDateTime(map['createdAt'], DateTime.now()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'discountPercentage': discountPercentage,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'applicableProductIds': applicableProductIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static double _parseDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    try {
      return double.parse(value.toString());
    } catch (_) {
      return defaultValue;
    }
  }

  static DateTime _parseDateTime(dynamic value, [DateTime? defaultValue]) {
    if (value == null) return defaultValue ?? DateTime.now();
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return defaultValue ?? DateTime.now();
    }
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e?.toString() ?? '').toList();
    }
    return [];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Offer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          discountPercentage == other.discountPercentage &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          isActive == other.isActive &&
          listEquals(applicableProductIds, other.applicableProductIds);

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      discountPercentage.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      isActive.hashCode ^
      applicableProductIds.hashCode;

  @override
  String toString() {
    return 'Offer{id: $id, title: $title, description: $description, discountPercentage: $discountPercentage, startDate: $startDate, endDate: $endDate, isActive: $isActive, applicableProductIds: $applicableProductIds}';
  }
}
