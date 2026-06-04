import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.quantity,
    required this.reorderThreshold,
    this.unitPrice = 0,
    this.createdAt,
  });

  final String id;
  final String name;
  final String categoryId;
  final int quantity;
  final int reorderThreshold;
  final double unitPrice;
  final DateTime? createdAt;

  bool get isLowStock => quantity <= reorderThreshold;

  Product copyWith({
    String? id,
    String? name,
    String? categoryId,
    int? quantity,
    int? reorderThreshold,
    double? unitPrice,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      quantity: quantity ?? this.quantity,
      reorderThreshold: reorderThreshold ?? this.reorderThreshold,
      unitPrice: unitPrice ?? this.unitPrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'categoryId': categoryId,
        'quantity': quantity,
        'reorderThreshold': reorderThreshold,
        'unitPrice': unitPrice,
        if (createdAt != null) 'createdAt': createdAt,
      };

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] as String? ?? '',
      categoryId: map['categoryId'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      reorderThreshold: (map['reorderThreshold'] as num?)?.toInt() ?? 5,
      unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0,
      createdAt: _parseDate(map['createdAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  @override
  List<Object?> get props =>
      [id, name, categoryId, quantity, reorderThreshold, unitPrice, createdAt];
}
