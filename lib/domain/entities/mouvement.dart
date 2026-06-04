import 'package:equatable/equatable.dart';

enum MouvementType { entree, sortie }

class Mouvement extends Equatable {
  const Mouvement({
    required this.id,
    required this.productId,
    required this.type,
    required this.quantity,
    required this.date,
    this.note,
    this.categoryId,
    this.unitPrice,
  });

  final String id;
  final String productId;
  final MouvementType type;
  final int quantity;
  final DateTime date;
  final String? note;
  final String? categoryId;
  final double? unitPrice;

  bool get isSale => type == MouvementType.sortie;

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'type': type.name,
        'quantity': quantity,
        'date': date,
        if (note != null) 'note': note,
        if (categoryId != null) 'categoryId': categoryId,
        if (unitPrice != null) 'unitPrice': unitPrice,
      };

  factory Mouvement.fromMap(String id, Map<String, dynamic> map) {
    final typeStr = map['type'] as String? ?? 'entree';
    return Mouvement(
      id: id,
      productId: map['productId'] as String? ?? '',
      type: typeStr == 'sortie' ? MouvementType.sortie : MouvementType.entree,
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      date: _parseDate(map['date']) ?? DateTime.now(),
      note: map['note'] as String?,
      categoryId: map['categoryId'] as String?,
      unitPrice: (map['unitPrice'] as num?)?.toDouble(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  @override
  List<Object?> get props =>
      [id, productId, type, quantity, date, note, categoryId, unitPrice];
}
